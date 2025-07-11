# Shared Admin Credentials Patterns

Comprehensive patterns for implementing shared admin credentials across multiple applications with security considerations, single sign-on capabilities, and centralized management.

## Centralized Admin Authentication Service

### Master Admin Service
```javascript
// master-admin-service.js - Centralized admin authentication
import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';
import crypto from 'crypto';

class MasterAdminService {
  constructor(config) {
    this.config = {
      jwtSecret: config.jwtSecret,
      tokenExpiry: config.tokenExpiry || '24h',
      refreshTokenExpiry: config.refreshTokenExpiry || '30d',
      applications: config.applications || {},
      encryptionKey: config.encryptionKey,
      ...config
    };
    this.database = config.database;
  }

  async authenticateAdmin(email, password) {
    // Find master admin record
    const admin = await this.database.masterAdmin.findUnique({
      where: { email, isActive: true },
      include: { 
        applications: true,
        permissions: true,
        sessions: {
          where: { expiresAt: { gt: new Date() } }
        }
      }
    });

    if (!admin) {
      throw new Error('Invalid credentials');
    }

    // Verify password
    const isValidPassword = await bcrypt.compare(password, admin.passwordHash);
    if (!isValidPassword) {
      await this.logFailedLogin(email);
      throw new Error('Invalid credentials');
    }

    // Generate tokens for all authorized applications
    const tokens = await this.generateApplicationTokens(admin);
    
    // Create master session
    const masterSession = await this.createMasterSession(admin, tokens);

    // Log successful login
    await this.logSuccessfulLogin(admin);

    return {
      admin: this.sanitizeAdminData(admin),
      masterSession,
      applicationTokens: tokens
    };
  }

  async generateApplicationTokens(admin) {
    const tokens = {};
    
    for (const app of admin.applications) {
      const appConfig = this.config.applications[app.applicationName];
      if (!appConfig) continue;

      const payload = {
        sub: admin.id,
        email: admin.email,
        role: 'ADMIN',
        app: app.applicationName,
        permissions: this.getAppPermissions(admin, app.applicationName),
        masterSession: true
      };

      const token = jwt.sign(payload, appConfig.jwtSecret || this.config.jwtSecret, {
        expiresIn: this.config.tokenExpiry,
        issuer: 'master-admin-service',
        audience: app.applicationName
      });

      tokens[app.applicationName] = {
        token,
        permissions: payload.permissions,
        expiresAt: new Date(Date.now() + this.parseExpiry(this.config.tokenExpiry))
      };
    }

    return tokens;
  }

  async createMasterSession(admin, tokens) {
    const sessionId = crypto.randomUUID();
    const refreshToken = crypto.randomBytes(32).toString('hex');

    const session = await this.database.masterSession.create({
      data: {
        id: sessionId,
        adminId: admin.id,
        refreshToken: await bcrypt.hash(refreshToken, 10),
        applicationTokens: this.encryptTokens(tokens),
        expiresAt: new Date(Date.now() + this.parseExpiry(this.config.refreshTokenExpiry)),
        createdAt: new Date(),
        lastAccessedAt: new Date()
      }
    });

    return {
      sessionId,
      refreshToken,
      expiresAt: session.expiresAt
    };
  }

  async refreshApplicationTokens(sessionId, refreshToken) {
    const session = await this.database.masterSession.findUnique({
      where: { id: sessionId, expiresAt: { gt: new Date() } },
      include: { admin: { include: { applications: true, permissions: true } } }
    });

    if (!session) {
      throw new Error('Invalid session');
    }

    // Verify refresh token
    const isValidRefresh = await bcrypt.compare(refreshToken, session.refreshToken);
    if (!isValidRefresh) {
      throw new Error('Invalid refresh token');
    }

    // Generate new tokens
    const newTokens = await this.generateApplicationTokens(session.admin);

    // Update session
    await this.database.masterSession.update({
      where: { id: sessionId },
      data: {
        applicationTokens: this.encryptTokens(newTokens),
        lastAccessedAt: new Date()
      }
    });

    return newTokens;
  }

  getAppPermissions(admin, applicationName) {
    return admin.permissions
      .filter(p => p.applicationName === applicationName || p.applicationName === '*')
      .map(p => p.permission);
  }

  encryptTokens(tokens) {
    const cipher = crypto.createCipher('aes-256-gcm', this.config.encryptionKey);
    let encrypted = cipher.update(JSON.stringify(tokens), 'utf8', 'hex');
    encrypted += cipher.final('hex');
    return encrypted;
  }

  decryptTokens(encryptedTokens) {
    const decipher = crypto.createDecipher('aes-256-gcm', this.config.encryptionKey);
    let decrypted = decipher.update(encryptedTokens, 'hex', 'utf8');
    decrypted += decipher.final('utf8');
    return JSON.parse(decrypted);
  }

  parseExpiry(expiry) {
    const units = { s: 1000, m: 60000, h: 3600000, d: 86400000 };
    const match = expiry.match(/^(\d+)([smhd])$/);
    if (!match) return 3600000; // Default 1 hour
    return parseInt(match[1]) * units[match[2]];
  }

  sanitizeAdminData(admin) {
    const { passwordHash, ...sanitized } = admin;
    return sanitized;
  }

  async logSuccessfulLogin(admin) {
    await this.database.auditLog.create({
      data: {
        action: 'MASTER_ADMIN_LOGIN',
        adminId: admin.id,
        details: JSON.stringify({
          email: admin.email,
          timestamp: new Date(),
          applications: admin.applications.map(a => a.applicationName)
        })
      }
    });
  }

  async logFailedLogin(email) {
    await this.database.auditLog.create({
      data: {
        action: 'MASTER_ADMIN_LOGIN_FAILED',
        details: JSON.stringify({
          email,
          timestamp: new Date()
        })
      }
    });
  }
}

export default MasterAdminService;
```

## Application-Side Integration

### Shared Admin Middleware
```javascript
// shared-admin-middleware.js - Application middleware for shared admin
class SharedAdminMiddleware {
  constructor(config) {
    this.config = config;
    this.masterAdminService = config.masterAdminService;
    this.applicationName = config.applicationName;
  }

  authenticateSharedAdmin() {
    return async (req, res, next) => {
      try {
        const token = this.extractToken(req);
        if (!token) {
          return res.status(401).json({ error: 'Authentication required' });
        }

        // Verify token
        const decoded = jwt.verify(token, this.config.jwtSecret);
        
        // Check if it's a master session token
        if (decoded.masterSession && decoded.app === this.applicationName) {
          req.admin = decoded;
          req.isMasterAdmin = true;
          next();
        } else {
          // Fall back to local admin authentication
          next();
        }
      } catch (error) {
        if (error.name === 'TokenExpiredError') {
          return res.status(401).json({ 
            error: 'Token expired',
            code: 'TOKEN_EXPIRED'
          });
        }
        return res.status(403).json({ error: 'Invalid token' });
      }
    };
  }

  requireSharedAdminPermission(permission) {
    return (req, res, next) => {
      if (!req.isMasterAdmin) {
        return res.status(403).json({ error: 'Master admin access required' });
      }

      const hasPermission = req.admin.permissions.includes(permission) ||
                           req.admin.permissions.includes('*');

      if (!hasPermission) {
        return res.status(403).json({ 
          error: 'Insufficient permissions',
          required: permission
        });
      }

      next();
    };
  }

  extractToken(req) {
    const authHeader = req.headers.authorization;
    if (authHeader && authHeader.startsWith('Bearer ')) {
      return authHeader.substring(7);
    }
    return null;
  }
}

export default SharedAdminMiddleware;
```

### Cross-Application Admin Dashboard
```javascript
// admin-dashboard-service.js - Unified admin dashboard
class CrossAppAdminDashboard {
  constructor(applications, masterAdminService) {
    this.applications = applications;
    this.masterAdminService = masterAdminService;
  }

  async getDashboardData(adminId, sessionId) {
    const session = await this.masterAdminService.getSession(sessionId);
    if (!session) {
      throw new Error('Invalid session');
    }

    const dashboardData = {
      admin: session.admin,
      applications: {},
      aggregatedStats: {
        totalUsers: 0,
        totalSessions: 0,
        systemHealth: 'unknown'
      }
    };

    // Fetch data from each application
    for (const [appName, appConfig] of Object.entries(this.applications)) {
      try {
        const appData = await this.fetchApplicationData(appName, appConfig, session);
        dashboardData.applications[appName] = appData;
        
        // Aggregate stats
        dashboardData.aggregatedStats.totalUsers += appData.userCount || 0;
        dashboardData.aggregatedStats.totalSessions += appData.activeSessions || 0;
      } catch (error) {
        dashboardData.applications[appName] = {
          error: error.message,
          status: 'unavailable'
        };
      }
    }

    return dashboardData;
  }

  async fetchApplicationData(appName, appConfig, session) {
    const token = session.applicationTokens[appName]?.token;
    if (!token) {
      throw new Error('No token available for application');
    }

    const response = await fetch(`${appConfig.apiUrl}/admin/dashboard`, {
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    });

    if (!response.ok) {
      throw new Error(`Failed to fetch data: ${response.statusText}`);
    }

    return await response.json();
  }

  async executeGlobalAction(action, params, sessionId) {
    const session = await this.masterAdminService.getSession(sessionId);
    const results = {};

    for (const [appName, appConfig] of Object.entries(this.applications)) {
      try {
        const result = await this.executeAppAction(appName, appConfig, action, params, session);
        results[appName] = { success: true, result };
      } catch (error) {
        results[appName] = { success: false, error: error.message };
      }
    }

    return results;
  }

  async executeAppAction(appName, appConfig, action, params, session) {
    const token = session.applicationTokens[appName]?.token;
    if (!token) {
      throw new Error('No token available for application');
    }

    const response = await fetch(`${appConfig.apiUrl}/admin/actions/${action}`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(params)
    });

    if (!response.ok) {
      throw new Error(`Action failed: ${response.statusText}`);
    }

    return await response.json();
  }
}
```

## Security Considerations

### Security Best Practices
```javascript
// security-manager.js - Security controls for shared admin
class SharedAdminSecurityManager {
  constructor(config) {
    this.config = config;
    this.maxFailedAttempts = config.maxFailedAttempts || 5;
    this.lockoutDuration = config.lockoutDuration || 30 * 60 * 1000; // 30 minutes
  }

  async checkAccountLockout(email) {
    const lockout = await this.database.adminLockout.findUnique({
      where: { email }
    });

    if (lockout && lockout.lockedUntil > new Date()) {
      const remainingTime = Math.ceil((lockout.lockedUntil - new Date()) / 60000);
      throw new Error(`Account locked. Try again in ${remainingTime} minutes.`);
    }

    return true;
  }

  async recordFailedAttempt(email) {
    const existing = await this.database.adminLockout.findUnique({
      where: { email }
    });

    if (existing) {
      const newAttempts = existing.failedAttempts + 1;
      
      if (newAttempts >= this.maxFailedAttempts) {
        // Lock the account
        await this.database.adminLockout.update({
          where: { email },
          data: {
            failedAttempts: newAttempts,
            lockedUntil: new Date(Date.now() + this.lockoutDuration),
            lastAttempt: new Date()
          }
        });
      } else {
        await this.database.adminLockout.update({
          where: { email },
          data: {
            failedAttempts: newAttempts,
            lastAttempt: new Date()
          }
        });
      }
    } else {
      await this.database.adminLockout.create({
        data: {
          email,
          failedAttempts: 1,
          lastAttempt: new Date()
        }
      });
    }
  }

  async clearFailedAttempts(email) {
    await this.database.adminLockout.delete({
      where: { email }
    }).catch(() => {}); // Ignore if doesn't exist
  }

  async validateSessionSecurity(sessionId, request) {
    const session = await this.database.masterSession.findUnique({
      where: { id: sessionId }
    });

    if (!session) {
      throw new Error('Invalid session');
    }

    // Check session expiry
    if (session.expiresAt < new Date()) {
      await this.database.masterSession.delete({ where: { id: sessionId } });
      throw new Error('Session expired');
    }

    // Check for suspicious activity
    const ipAddress = this.getClientIP(request);
    const userAgent = request.headers['user-agent'];

    if (session.ipAddress && session.ipAddress !== ipAddress) {
      await this.logSecurityEvent('IP_CHANGE', sessionId, {
        oldIP: session.ipAddress,
        newIP: ipAddress
      });
    }

    // Update session tracking
    await this.database.masterSession.update({
      where: { id: sessionId },
      data: {
        lastAccessedAt: new Date(),
        ipAddress,
        userAgent
      }
    });

    return true;
  }

  async logSecurityEvent(eventType, sessionId, details) {
    await this.database.securityEvent.create({
      data: {
        eventType,
        sessionId,
        details: JSON.stringify(details),
        timestamp: new Date()
      }
    });
  }

  getClientIP(request) {
    return request.headers['x-forwarded-for'] ||
           request.headers['x-real-ip'] ||
           request.connection.remoteAddress ||
           request.socket.remoteAddress ||
           (request.connection.socket ? request.connection.socket.remoteAddress : null);
  }
}
```

## Related Documentation

### Core Authentication Documentation
- [Authentication Best Practices](./best-practices.md) - Security guidelines and implementation standards
- [Authentication Common Patterns](./common-patterns.md) - General authentication patterns and admin setup
- [RBAC Patterns](./rbac-patterns.md) - Role-based access control with admin privileges
- [Authentication Troubleshooting](./troubleshooting.md) - Common authentication issues

### Database Integration
- [Database Security](../database/best-practices.md) - Database security considerations
- [Database Common Patterns](../database/common-patterns.md) - Admin account database schemas

### Troubleshooting Integration
- [Active Blockers](../../../templates/troubleshooting/active-blockers/README.md) - Current authentication issues
- [Framework-Specific Issues](../../../templates/troubleshooting/framework-specific/README.md) - Authentication framework problems

### Project Lifecycle Integration
- [Feature Development](../../project-lifecycle/feature-development/README.md) - Authentication feature development process
- [Security Planning](../../project-lifecycle/03-design-and-architecture/README.md) - Authentication architecture design

---

*Last Updated: 2025-07-11*
*Security Level: Enterprise*
*Framework Support: Multi-application*
*Integration: Database, Troubleshooting, Project Lifecycle*
