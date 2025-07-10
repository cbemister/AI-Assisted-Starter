# Authentication & Authorization Best Practices

Comprehensive security guidelines and implementation standards for authentication systems.

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
