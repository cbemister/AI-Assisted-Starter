# Authentication & Authorization Best Practices

Comprehensive security guidelines and implementation standards for authentication systems, including admin account security, shared credential management, and enterprise-grade access control.

## Admin Account Security Best Practices

### Admin Account Creation and Management
```javascript
// Secure admin account creation with enhanced security
class SecureAdminAccountManager {
  constructor(config) {
    this.config = {
      minPasswordLength: 16,
      requireMFA: true,
      sessionTimeout: 30 * 60 * 1000, // 30 minutes
      maxFailedAttempts: 3,
      lockoutDuration: 60 * 60 * 1000, // 1 hour
      ...config
    };
  }

  async createAdminAccount(adminData) {
    // Validate admin creation permissions
    await this.validateAdminCreationPermissions(adminData.createdBy);

    // Generate secure password if not provided
    const password = adminData.password || this.generateSecurePassword();

    // Enhanced password validation for admin accounts
    await this.validateAdminPassword(password);

    // Create admin with additional security measures
    const admin = await this.createSecureAdmin({
      ...adminData,
      password,
      requirePasswordChange: !adminData.password, // Force change if generated
      mfaRequired: true,
      sessionTimeout: this.config.sessionTimeout
    });

    // Set up mandatory MFA
    await this.setupMandatoryMFA(admin.id);

    // Log admin creation
    await this.auditAdminCreation(admin, adminData.createdBy);

    return admin;
  }

  async validateAdminPassword(password) {
    const requirements = {
      minLength: this.config.minPasswordLength,
      requireUppercase: true,
      requireLowercase: true,
      requireNumbers: true,
      requireSpecialChars: true,
      preventCommonPasswords: true,
      preventPersonalInfo: true
    };

    if (password.length < requirements.minLength) {
      throw new Error(`Admin password must be at least ${requirements.minLength} characters`);
    }

    if (!/[A-Z]/.test(password)) {
      throw new Error('Admin password must contain uppercase letters');
    }

    if (!/[a-z]/.test(password)) {
      throw new Error('Admin password must contain lowercase letters');
    }

    if (!/\d/.test(password)) {
      throw new Error('Admin password must contain numbers');
    }

    if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)) {
      throw new Error('Admin password must contain special characters');
    }

    // Check against common passwords
    if (await this.isCommonPassword(password)) {
      throw new Error('Admin password cannot be a common password');
    }
  }

  generateSecurePassword(length = 20) {
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const special = '!@#$%^&*()_+-=[]{}|;:,.<>?';

    let password = '';

    // Ensure at least one character from each category
    password += this.getRandomChar(uppercase);
    password += this.getRandomChar(lowercase);
    password += this.getRandomChar(numbers);
    password += this.getRandomChar(special);

    // Fill remaining length
    const allChars = uppercase + lowercase + numbers + special;
    for (let i = 4; i < length; i++) {
      password += this.getRandomChar(allChars);
    }

    // Shuffle password
    return password.split('').sort(() => Math.random() - 0.5).join('');
  }

  async setupMandatoryMFA(adminId) {
    // Generate TOTP secret
    const secret = this.generateTOTPSecret();

    await this.db.adminMFA.create({
      data: {
        adminId,
        type: 'TOTP',
        secret: this.encryptSecret(secret),
        isRequired: true,
        isEnabled: false, // Will be enabled after verification
        createdAt: new Date()
      }
    });

    return secret;
  }
}
```

### Admin Session Security
```javascript
// Enhanced admin session management
class AdminSessionManager {
  constructor(config) {
    this.config = {
      sessionTimeout: 30 * 60 * 1000, // 30 minutes
      maxConcurrentSessions: 2,
      requireReauth: 15 * 60 * 1000, // Re-auth for sensitive operations
      ipWhitelist: config.ipWhitelist || [],
      ...config
    };
  }

  async createAdminSession(admin, request) {
    // Validate IP whitelist if configured
    if (this.config.ipWhitelist.length > 0) {
      const clientIP = this.getClientIP(request);
      if (!this.config.ipWhitelist.includes(clientIP)) {
        throw new Error('Admin access not allowed from this IP address');
      }
    }

    // Check concurrent session limit
    await this.enforceSessionLimit(admin.id);

    // Create enhanced session
    const session = await this.db.adminSession.create({
      data: {
        adminId: admin.id,
        sessionId: crypto.randomUUID(),
        ipAddress: this.getClientIP(request),
        userAgent: request.headers['user-agent'],
        expiresAt: new Date(Date.now() + this.config.sessionTimeout),
        lastActivity: new Date(),
        requiresReauth: false,
        securityLevel: 'high'
      }
    });

    // Set up session monitoring
    this.setupSessionMonitoring(session.sessionId);

    return session;
  }

  async validateAdminSession(sessionId, request) {
    const session = await this.db.adminSession.findUnique({
      where: { sessionId, expiresAt: { gt: new Date() } },
      include: { admin: true }
    });

    if (!session) {
      throw new Error('Invalid or expired admin session');
    }

    // Check for suspicious activity
    const currentIP = this.getClientIP(request);
    if (session.ipAddress !== currentIP) {
      await this.logSecurityEvent('IP_CHANGE', sessionId, {
        originalIP: session.ipAddress,
        newIP: currentIP
      });

      // Optionally terminate session on IP change
      if (this.config.terminateOnIPChange) {
        await this.terminateSession(sessionId);
        throw new Error('Session terminated due to IP address change');
      }
    }

    // Update last activity
    await this.db.adminSession.update({
      where: { sessionId },
      data: { lastActivity: new Date() }
    });

    return session;
  }

  async enforceSessionLimit(adminId) {
    const activeSessions = await this.db.adminSession.findMany({
      where: {
        adminId,
        expiresAt: { gt: new Date() }
      },
      orderBy: { lastActivity: 'desc' }
    });

    if (activeSessions.length >= this.config.maxConcurrentSessions) {
      // Terminate oldest sessions
      const sessionsToTerminate = activeSessions.slice(this.config.maxConcurrentSessions - 1);

      for (const session of sessionsToTerminate) {
        await this.terminateSession(session.sessionId);
      }
    }
  }
}
```

## Shared Credential Management

### Cross-Application Authentication
```javascript
// Secure shared credential management
class SharedCredentialManager {
  constructor(config) {
    this.config = {
      masterKeyRotationInterval: 30 * 24 * 60 * 60 * 1000, // 30 days
      applicationTokenExpiry: 24 * 60 * 60 * 1000, // 24 hours
      encryptionAlgorithm: 'aes-256-gcm',
      ...config
    };
    this.masterKey = this.loadMasterKey();
  }

  async createSharedCredential(adminData, applications) {
    // Validate admin permissions for shared access
    await this.validateSharedAccessPermissions(adminData.createdBy, applications);

    // Create master credential record
    const sharedCredential = await this.db.sharedCredential.create({
      data: {
        adminId: adminData.adminId,
        applications: applications,
        masterKeyVersion: this.getCurrentKeyVersion(),
        isActive: true,
        createdAt: new Date(),
        lastRotated: new Date()
      }
    });

    // Generate application-specific tokens
    const applicationTokens = {};
    for (const app of applications) {
      applicationTokens[app] = await this.generateApplicationToken(
        sharedCredential.id,
        app,
        adminData
      );
    }

    // Store encrypted tokens
    await this.storeEncryptedTokens(sharedCredential.id, applicationTokens);

    return {
      sharedCredentialId: sharedCredential.id,
      applicationTokens
    };
  }

  async rotateSharedCredentials(sharedCredentialId) {
    const credential = await this.db.sharedCredential.findUnique({
      where: { id: sharedCredentialId },
      include: { admin: true }
    });

    if (!credential) {
      throw new Error('Shared credential not found');
    }

    // Generate new tokens for all applications
    const newTokens = {};
    for (const app of credential.applications) {
      newTokens[app] = await this.generateApplicationToken(
        credential.id,
        app,
        credential.admin
      );
    }

    // Update stored tokens
    await this.storeEncryptedTokens(credential.id, newTokens);

    // Update rotation timestamp
    await this.db.sharedCredential.update({
      where: { id: sharedCredentialId },
      data: { lastRotated: new Date() }
    });

    // Notify applications of token rotation
    await this.notifyApplicationsOfRotation(credential.applications, newTokens);

    return newTokens;
  }

  async validateSharedToken(token, applicationName) {
    try {
      const decoded = jwt.verify(token, this.getApplicationSecret(applicationName));

      // Verify shared credential is still active
      const credential = await this.db.sharedCredential.findUnique({
        where: { id: decoded.sharedCredentialId, isActive: true }
      });

      if (!credential) {
        throw new Error('Shared credential deactivated');
      }

      // Check if token needs rotation
      const tokenAge = Date.now() - decoded.iat * 1000;
      if (tokenAge > this.config.applicationTokenExpiry * 0.8) {
        // Token is 80% through its lifetime, suggest rotation
        return {
          valid: true,
          admin: decoded,
          suggestRotation: true
        };
      }

      return {
        valid: true,
        admin: decoded,
        suggestRotation: false
      };
    } catch (error) {
      return {
        valid: false,
        error: error.message
      };
    }
  }

  encryptData(data) {
    const iv = crypto.randomBytes(16);
    const cipher = crypto.createCipher(this.config.encryptionAlgorithm, this.masterKey);

    let encrypted = cipher.update(JSON.stringify(data), 'utf8', 'hex');
    encrypted += cipher.final('hex');

    return {
      encrypted,
      iv: iv.toString('hex'),
      algorithm: this.config.encryptionAlgorithm
    };
  }

  decryptData(encryptedData) {
    const decipher = crypto.createDecipher(
      encryptedData.algorithm,
      this.masterKey
    );

    let decrypted = decipher.update(encryptedData.encrypted, 'hex', 'utf8');
    decrypted += decipher.final('utf8');

    return JSON.parse(decrypted);
  }
}

## Password Security

### Password Hashing
```javascript
// Use bcrypt with appropriate salt rounds
const bcrypt = require('bcrypt');
const saltRounds = 12; // Adjust based on security requirements

async function hashPassword(password) {
    return await bcrypt.hash(password, saltRounds);
}

async function verifyPassword(password, hash) {
    return await bcrypt.compare(password, hash);
}
```

### Password Policies
- **Minimum Length**: 8 characters (12+ recommended)
- **Complexity**: Mix of uppercase, lowercase, numbers, symbols
- **Common Password Prevention**: Check against known weak passwords
- **Password History**: Prevent reuse of last 5-10 passwords
- **Expiration**: Consider for high-security environments (90-180 days)

## JWT Implementation Best Practices

### Token Structure
```javascript
// JWT Payload Structure
{
    "sub": "user_id",           // Subject (user identifier)
    "iat": 1641024000,          // Issued at timestamp
    "exp": 1641027600,          // Expiration timestamp (1 hour)
    "aud": "your-app.com",      // Audience
    "iss": "your-auth-service", // Issuer
    "roles": ["user", "admin"], // User roles
    "permissions": ["read", "write"] // Specific permissions
}
```

### Token Security
- **Short Expiration**: Access tokens 15-60 minutes
- **Refresh Tokens**: Longer-lived (days/weeks) for token renewal
- **Secure Storage**: HttpOnly cookies or secure storage
- **Token Rotation**: Rotate refresh tokens on use
- **Revocation**: Implement token blacklisting for logout

### JWT Configuration
```javascript
// Secure JWT configuration
const jwt = require('jsonwebtoken');

const jwtConfig = {
    algorithm: 'RS256',        // Use asymmetric algorithms
    expiresIn: '15m',         // Short access token lifetime
    issuer: 'your-app.com',
    audience: 'your-app.com'
};

// Sign token
function signToken(payload) {
    return jwt.sign(payload, privateKey, jwtConfig);
}

// Verify token
function verifyToken(token) {
    return jwt.verify(token, publicKey, {
        algorithms: ['RS256'],
        issuer: 'your-app.com',
        audience: 'your-app.com'
    });
}
```

## Session Management

### Session Configuration
```javascript
// Express session configuration
const session = require('express-session');
const MongoStore = require('connect-mongo');

app.use(session({
    secret: process.env.SESSION_SECRET, // Strong random secret
    resave: false,
    saveUninitialized: false,
    store: MongoStore.create({
        mongoUrl: process.env.MONGODB_URI
    }),
    cookie: {
        secure: process.env.NODE_ENV === 'production', // HTTPS only
        httpOnly: true,                                // Prevent XSS
        maxAge: 1000 * 60 * 60 * 24,                  // 24 hours
        sameSite: 'strict'                            // CSRF protection
    }
}));
```

### Session Security
- **Secure Cookies**: HTTPS-only in production
- **HttpOnly**: Prevent JavaScript access
- **SameSite**: CSRF protection
- **Session Regeneration**: On privilege changes
- **Session Timeout**: Automatic expiration

## OAuth 2.0 Implementation

### OAuth Configuration
```javascript
// OAuth 2.0 configuration example
const passport = require('passport');
const GoogleStrategy = require('passport-google-oauth20').Strategy;

passport.use(new GoogleStrategy({
    clientID: process.env.GOOGLE_CLIENT_ID,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    callbackURL: "/auth/google/callback",
    scope: ['profile', 'email']
}, async (accessToken, refreshToken, profile, done) => {
    // Handle user creation/authentication
    const user = await findOrCreateUser(profile);
    return done(null, user);
}));
```

### OAuth Security
- **State Parameter**: CSRF protection for OAuth flows
- **PKCE**: Proof Key for Code Exchange for public clients
- **Scope Limitation**: Request minimal necessary permissions
- **Token Validation**: Verify tokens with provider
- **Secure Redirect URIs**: Whitelist allowed redirect URLs

## Role-Based Access Control (RBAC)

### RBAC Data Model
```javascript
// User-Role-Permission model
const userSchema = {
    id: String,
    email: String,
    roles: [String], // ['user', 'admin', 'moderator']
    permissions: [String] // Direct permissions
};

const roleSchema = {
    name: String,
    permissions: [String],
    description: String
};

const permissionSchema = {
    name: String,
    resource: String,
    action: String // 'create', 'read', 'update', 'delete'
};
```

### Permission Checking
```javascript
// Permission checking middleware
function requirePermission(permission) {
    return (req, res, next) => {
        const user = req.user;
        
        if (hasPermission(user, permission)) {
            next();
        } else {
            res.status(403).json({ error: 'Insufficient permissions' });
        }
    };
}

function hasPermission(user, requiredPermission) {
    // Check direct permissions
    if (user.permissions.includes(requiredPermission)) {
        return true;
    }
    
    // Check role-based permissions
    return user.roles.some(role => {
        const rolePermissions = getRolePermissions(role);
        return rolePermissions.includes(requiredPermission);
    });
}
```

## Security Headers and Middleware

### Essential Security Headers
```javascript
// Security headers middleware
app.use((req, res, next) => {
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('X-Frame-Options', 'DENY');
    res.setHeader('X-XSS-Protection', '1; mode=block');
    res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
    res.setHeader('Content-Security-Policy', "default-src 'self'");
    next();
});
```

### Rate Limiting
```javascript
// Rate limiting for authentication endpoints
const rateLimit = require('express-rate-limit');

const authLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 5, // 5 attempts per window
    message: 'Too many authentication attempts',
    standardHeaders: true,
    legacyHeaders: false
});

app.use('/auth/login', authLimiter);
```

## Multi-Factor Authentication (MFA)

### TOTP Implementation
```javascript
// Time-based One-Time Password (TOTP)
const speakeasy = require('speakeasy');

// Generate secret for user
function generateMFASecret(userEmail) {
    return speakeasy.generateSecret({
        name: userEmail,
        issuer: 'Your App Name',
        length: 32
    });
}

// Verify TOTP token
function verifyMFAToken(secret, token) {
    return speakeasy.totp.verify({
        secret: secret,
        encoding: 'base32',
        token: token,
        window: 2 // Allow 2 time steps of variance
    });
}
```

## Error Handling and Logging

### Authentication Error Handling
```javascript
// Standardized authentication errors
class AuthenticationError extends Error {
    constructor(message, code = 'AUTH_ERROR') {
        super(message);
        this.name = 'AuthenticationError';
        this.code = code;
        this.statusCode = 401;
    }
}

class AuthorizationError extends Error {
    constructor(message, code = 'AUTHZ_ERROR') {
        super(message);
        this.name = 'AuthorizationError';
        this.code = code;
        this.statusCode = 403;
    }
}
```

### Security Logging
```javascript
// Security event logging
function logSecurityEvent(event, user, details = {}) {
    const logEntry = {
        timestamp: new Date().toISOString(),
        event: event,
        userId: user?.id,
        userEmail: user?.email,
        ip: details.ip,
        userAgent: details.userAgent,
        success: details.success,
        reason: details.reason
    };
    
    // Log to security monitoring system
    securityLogger.info(logEntry);
    
    // Alert on suspicious activity
    if (isSuspiciousActivity(event, details)) {
        alertSecurityTeam(logEntry);
    }
}
```

## Methodology-Specific Guidelines

### MVP/Rapid Implementation
- Use established authentication libraries (NextAuth.js, Passport.js)
- Basic JWT or session authentication
- Simple role-based authorization
- Essential security headers
- Basic rate limiting

### Balanced/Standard Implementation
- Custom authentication with security best practices
- Refresh token implementation
- Comprehensive RBAC system
- Security monitoring and logging
- MFA support

### Comprehensive/Enterprise Implementation
- Full OAuth 2.0/OIDC implementation
- Advanced RBAC/ABAC systems
- Comprehensive security monitoring
- Audit logging and compliance
- Advanced threat detection

## Security Checklist

- [ ] Password hashing with bcrypt/Argon2
- [ ] HTTPS enforcement
- [ ] Secure token storage
- [ ] CSRF protection
- [ ] Rate limiting on auth endpoints
- [ ] Security headers implementation
- [ ] Session security configuration
- [ ] Input validation and sanitization
- [ ] Error message security (no information leakage)
- [ ] Audit logging for security events
- [ ] Regular security testing
- [ ] Dependency vulnerability scanning

---

*Security Standards: OWASP Top 10 Compliance*
*Last Updated: 2025-07-10*
