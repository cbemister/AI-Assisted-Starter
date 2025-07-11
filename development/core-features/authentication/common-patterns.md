# Authentication Common Patterns

Reusable code patterns and templates for implementing authentication across different frameworks and scenarios, including admin account creation and cross-application authentication patterns.

## Admin User Account Creation Patterns

### Admin Account Setup Service
```javascript
// admin-setup.js - Comprehensive admin account creation service
import bcrypt from 'bcrypt';
import crypto from 'crypto';

class AdminAccountService {
  constructor(database, config = {}) {
    this.db = database;
    this.config = {
      defaultAdminEmail: config.defaultAdminEmail || 'admin@example.com',
      defaultAdminRole: config.defaultAdminRole || 'admin',
      requireEmailVerification: config.requireEmailVerification || false,
      generateSecurePassword: config.generateSecurePassword || true,
      ...config
    };
  }

  async createDefaultAdmin(overrides = {}) {
    const adminData = {
      email: this.config.defaultAdminEmail,
      role: this.config.defaultAdminRole,
      firstName: 'System',
      lastName: 'Administrator',
      isActive: true,
      emailVerified: !this.config.requireEmailVerification,
      ...overrides
    };

    // Generate secure password if not provided
    if (!adminData.password) {
      adminData.password = this.generateSecurePassword();
      console.log(`Generated admin password: ${adminData.password}`);
      console.log('⚠️  Please change this password after first login!');
    }

    return await this.createAdminUser(adminData);
  }

  async createAdminUser(adminData) {
    const { email, password, role, ...profileData } = adminData;

    // Check if admin already exists
    const existingAdmin = await this.findUserByEmail(email);
    if (existingAdmin) {
      throw new Error(`Admin user with email ${email} already exists`);
    }

    // Hash password
    const passwordHash = await bcrypt.hash(password, 12);

    // Create admin user with transaction
    return await this.db.transaction(async (tx) => {
      // Create user record
      const user = await tx.user.create({
        data: {
          email,
          passwordHash,
          role: role.toUpperCase(),
          isActive: true,
          emailVerified: !this.config.requireEmailVerification,
          profile: {
            create: {
              firstName: profileData.firstName || 'Admin',
              lastName: profileData.lastName || 'User',
              bio: profileData.bio || 'System administrator account',
              preferences: JSON.stringify({
                theme: 'dark',
                notifications: true,
                language: 'en',
                timezone: 'UTC'
              })
            }
          }
        },
        include: { profile: true }
      });

      // Create admin-specific permissions
      await this.assignAdminPermissions(tx, user.id);

      // Log admin creation
      await this.logAdminCreation(tx, user);

      return user;
    });
  }

  async assignAdminPermissions(tx, userId) {
    const adminPermissions = [
      'users:create', 'users:read', 'users:update', 'users:delete',
      'roles:create', 'roles:read', 'roles:update', 'roles:delete',
      'permissions:create', 'permissions:read', 'permissions:update', 'permissions:delete',
      'system:configure', 'system:monitor', 'system:backup',
      'audit:read', 'audit:export'
    ];

    for (const permission of adminPermissions) {
      await tx.userPermission.create({
        data: {
          userId,
          permission,
          grantedAt: new Date(),
          grantedBy: 'system'
        }
      });
    }
  }

  async logAdminCreation(tx, user) {
    await tx.auditLog.create({
      data: {
        action: 'ADMIN_CREATED',
        userId: user.id,
        details: JSON.stringify({
          email: user.email,
          role: user.role,
          createdBy: 'system',
          timestamp: new Date()
        }),
        ipAddress: '127.0.0.1',
        userAgent: 'System'
      }
    });
  }

  generateSecurePassword(length = 16) {
    const charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*';
    let password = '';

    // Ensure at least one character from each category
    password += this.getRandomChar('abcdefghijklmnopqrstuvwxyz'); // lowercase
    password += this.getRandomChar('ABCDEFGHIJKLMNOPQRSTUVWXYZ'); // uppercase
    password += this.getRandomChar('0123456789'); // numbers
    password += this.getRandomChar('!@#$%^&*'); // special chars

    // Fill remaining length
    for (let i = 4; i < length; i++) {
      password += this.getRandomChar(charset);
    }

    // Shuffle the password
    return password.split('').sort(() => Math.random() - 0.5).join('');
  }

  getRandomChar(charset) {
    return charset.charAt(Math.floor(Math.random() * charset.length));
  }

  async findUserByEmail(email) {
    return await this.db.user.findUnique({
      where: { email },
      include: { profile: true }
    });
  }
}

export default AdminAccountService;
```

### Cross-Application Admin Setup
```javascript
// cross-app-admin.js - Shared admin account across multiple applications
class CrossApplicationAdminService {
  constructor(applications, sharedDatabase) {
    this.applications = applications;
    this.sharedDb = sharedDatabase;
  }

  async setupSharedAdmin(adminConfig) {
    const {
      email,
      password,
      applications: targetApps = Object.keys(this.applications),
      permissions = {}
    } = adminConfig;

    // Create master admin record
    const masterAdmin = await this.createMasterAdminRecord({
      email,
      password,
      applications: targetApps
    });

    // Setup admin access for each application
    const setupResults = {};
    for (const appName of targetApps) {
      try {
        setupResults[appName] = await this.setupApplicationAdmin(
          appName,
          masterAdmin,
          permissions[appName] || 'full'
        );
      } catch (error) {
        console.error(`Failed to setup admin for ${appName}:`, error);
        setupResults[appName] = { error: error.message };
      }
    }

    return {
      masterAdmin,
      applicationSetup: setupResults
    };
  }

  async createMasterAdminRecord(adminData) {
    return await this.sharedDb.transaction(async (tx) => {
      const passwordHash = await bcrypt.hash(adminData.password, 12);

      const admin = await tx.masterAdmin.create({
        data: {
          email: adminData.email,
          passwordHash,
          applications: adminData.applications,
          isActive: true,
          createdAt: new Date(),
          lastSync: new Date()
        }
      });

      // Create shared session token
      const sharedToken = this.generateSharedToken(admin);
      await tx.sharedToken.create({
        data: {
          adminId: admin.id,
          token: sharedToken,
          expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days
          applications: adminData.applications
        }
      });

      return { ...admin, sharedToken };
    });
  }

  async setupApplicationAdmin(appName, masterAdmin, permissionLevel) {
    const appConfig = this.applications[appName];
    if (!appConfig) {
      throw new Error(`Application ${appName} not configured`);
    }

    const appDb = appConfig.database;

    return await appDb.transaction(async (tx) => {
      // Check if admin already exists in this app
      const existingAdmin = await tx.user.findUnique({
        where: { email: masterAdmin.email }
      });

      if (existingAdmin) {
        // Update existing admin
        return await this.updateExistingAdmin(tx, existingAdmin, masterAdmin, permissionLevel);
      } else {
        // Create new admin in this app
        return await this.createNewAppAdmin(tx, masterAdmin, permissionLevel, appName);
      }
    });
  }

  async createNewAppAdmin(tx, masterAdmin, permissionLevel, appName) {
    const admin = await tx.user.create({
      data: {
        email: masterAdmin.email,
        passwordHash: masterAdmin.passwordHash,
        role: 'ADMIN',
        isActive: true,
        emailVerified: true,
        masterAdminId: masterAdmin.id,
        profile: {
          create: {
            firstName: 'Cross-App',
            lastName: 'Administrator',
            bio: `Shared administrator for ${appName}`,
            preferences: JSON.stringify({
              crossAppAdmin: true,
              sourceApp: 'master',
              permissionLevel
            })
          }
        }
      },
      include: { profile: true }
    });

    // Assign permissions based on level
    await this.assignPermissionsByLevel(tx, admin.id, permissionLevel);

    return admin;
  }

  async assignPermissionsByLevel(tx, userId, level) {
    const permissionSets = {
      full: [
        'users:*', 'roles:*', 'permissions:*', 'system:*', 'audit:*'
      ],
      standard: [
        'users:read', 'users:update', 'roles:read', 'system:monitor'
      ],
      readonly: [
        'users:read', 'roles:read', 'audit:read'
      ]
    };

    const permissions = permissionSets[level] || permissionSets.standard;

    for (const permission of permissions) {
      await tx.userPermission.create({
        data: {
          userId,
          permission,
          grantedAt: new Date(),
          grantedBy: 'cross-app-system'
        }
      });
    }
  }

  generateSharedToken(admin) {
    return crypto.randomBytes(32).toString('hex');
  }
}
```

### Admin Account Migration Pattern
```javascript
// admin-migration.js - Migrate admin accounts between systems
class AdminMigrationService {
  constructor(sourceDb, targetDb) {
    this.sourceDb = sourceDb;
    this.targetDb = targetDb;
  }

  async migrateAdminAccounts(options = {}) {
    const {
      preservePasswords = true,
      updateRoles = true,
      migratePermissions = true,
      dryRun = false
    } = options;

    // Get all admin users from source
    const sourceAdmins = await this.sourceDb.user.findMany({
      where: { role: 'ADMIN' },
      include: { profile: true, permissions: true }
    });

    const migrationResults = [];

    for (const admin of sourceAdmins) {
      try {
        const result = await this.migrateAdmin(admin, {
          preservePasswords,
          updateRoles,
          migratePermissions,
          dryRun
        });
        migrationResults.push(result);
      } catch (error) {
        migrationResults.push({
          email: admin.email,
          success: false,
          error: error.message
        });
      }
    }

    return migrationResults;
  }

  async migrateAdmin(sourceAdmin, options) {
    const { preservePasswords, updateRoles, migratePermissions, dryRun } = options;

    if (dryRun) {
      return {
        email: sourceAdmin.email,
        action: 'would_migrate',
        permissions: sourceAdmin.permissions?.length || 0
      };
    }

    return await this.targetDb.transaction(async (tx) => {
      // Check if admin exists in target
      const existingAdmin = await tx.user.findUnique({
        where: { email: sourceAdmin.email }
      });

      if (existingAdmin) {
        // Update existing admin
        return await this.updateExistingAdmin(tx, existingAdmin, sourceAdmin, options);
      } else {
        // Create new admin
        return await this.createMigratedAdmin(tx, sourceAdmin, options);
      }
    });
  }

  async createMigratedAdmin(tx, sourceAdmin, options) {
    const adminData = {
      email: sourceAdmin.email,
      passwordHash: options.preservePasswords
        ? sourceAdmin.passwordHash
        : await bcrypt.hash(this.generateTempPassword(), 12),
      role: options.updateRoles ? 'ADMIN' : sourceAdmin.role,
      isActive: sourceAdmin.isActive,
      emailVerified: sourceAdmin.emailVerified,
      migratedFrom: 'legacy_system',
      migratedAt: new Date()
    };

    const admin = await tx.user.create({
      data: {
        ...adminData,
        profile: {
          create: {
            firstName: sourceAdmin.profile?.firstName || 'Migrated',
            lastName: sourceAdmin.profile?.lastName || 'Admin',
            bio: `Migrated admin account from legacy system`,
            preferences: sourceAdmin.profile?.preferences || '{}'
          }
        }
      },
      include: { profile: true }
    });

    // Migrate permissions if requested
    if (options.migratePermissions && sourceAdmin.permissions) {
      for (const permission of sourceAdmin.permissions) {
        await tx.userPermission.create({
          data: {
            userId: admin.id,
            permission: permission.permission,
            grantedAt: new Date(),
            grantedBy: 'migration_system'
          }
        });
      }
    }

    return {
      email: admin.email,
      success: true,
      action: 'created',
      passwordReset: !options.preservePasswords
    };
  }

  generateTempPassword() {
    return crypto.randomBytes(8).toString('hex');
  }
}

### Admin Setup CLI Tool
```javascript
// admin-cli.js - Command-line tool for admin setup
#!/usr/bin/env node
import inquirer from 'inquirer';
import AdminAccountService from './admin-setup.js';
import DatabaseFactory from '../database/database-factory.js';

class AdminSetupCLI {
  async run() {
    console.log('🔧 Admin Account Setup Tool\n');

    try {
      const config = await this.promptForConfig();
      const db = DatabaseFactory.create();
      const adminService = new AdminAccountService(db, config);

      if (config.setupType === 'default') {
        await this.setupDefaultAdmin(adminService, config);
      } else if (config.setupType === 'custom') {
        await this.setupCustomAdmin(adminService, config);
      } else if (config.setupType === 'cross-app') {
        await this.setupCrossAppAdmin(adminService, config);
      }

    } catch (error) {
      console.error('❌ Setup failed:', error.message);
      process.exit(1);
    }
  }

  async promptForConfig() {
    const answers = await inquirer.prompt([
      {
        type: 'list',
        name: 'setupType',
        message: 'What type of admin setup do you need?',
        choices: [
          { name: 'Default admin account', value: 'default' },
          { name: 'Custom admin account', value: 'custom' },
          { name: 'Cross-application admin', value: 'cross-app' }
        ]
      },
      {
        type: 'input',
        name: 'email',
        message: 'Admin email address:',
        default: 'admin@example.com',
        validate: (input) => /\S+@\S+\.\S+/.test(input) || 'Please enter a valid email'
      },
      {
        type: 'confirm',
        name: 'generatePassword',
        message: 'Generate secure password automatically?',
        default: true
      },
      {
        type: 'password',
        name: 'password',
        message: 'Enter admin password:',
        when: (answers) => !answers.generatePassword,
        validate: (input) => input.length >= 8 || 'Password must be at least 8 characters'
      }
    ]);

    return answers;
  }

  async setupDefaultAdmin(adminService, config) {
    console.log('\n🚀 Creating default admin account...');

    const admin = await adminService.createDefaultAdmin({
      email: config.email,
      password: config.password
    });

    console.log('✅ Default admin created successfully!');
    console.log(`📧 Email: ${admin.email}`);
    console.log(`🔑 Role: ${admin.role}`);
    console.log(`🆔 ID: ${admin.id}`);
  }
}

// Usage: node admin-cli.js
if (import.meta.url === `file://${process.argv[1]}`) {
  new AdminSetupCLI().run();
}
```

### Admin Account Templates
```javascript
// admin-templates.js - Predefined admin account templates
export const AdminTemplates = {
  // System administrator with full access
  systemAdmin: {
    role: 'ADMIN',
    permissions: [
      'users:*', 'roles:*', 'permissions:*', 'system:*', 'audit:*'
    ],
    profile: {
      firstName: 'System',
      lastName: 'Administrator',
      bio: 'Full system administrator with complete access',
      preferences: {
        theme: 'dark',
        notifications: true,
        language: 'en',
        timezone: 'UTC',
        dashboardLayout: 'admin'
      }
    }
  },

  // Content moderator with limited admin access
  contentModerator: {
    role: 'MODERATOR',
    permissions: [
      'users:read', 'users:update', 'content:*', 'reports:*'
    ],
    profile: {
      firstName: 'Content',
      lastName: 'Moderator',
      bio: 'Content moderation and user management',
      preferences: {
        theme: 'light',
        notifications: true,
        language: 'en',
        timezone: 'UTC',
        dashboardLayout: 'moderator'
      }
    }
  },

  // Support administrator
  supportAdmin: {
    role: 'SUPPORT_ADMIN',
    permissions: [
      'users:read', 'users:update', 'tickets:*', 'reports:read'
    ],
    profile: {
      firstName: 'Support',
      lastName: 'Administrator',
      bio: 'Customer support and user assistance',
      preferences: {
        theme: 'light',
        notifications: true,
        language: 'en',
        timezone: 'UTC',
        dashboardLayout: 'support'
      }
    }
  },

  // Development admin for testing
  devAdmin: {
    role: 'DEV_ADMIN',
    permissions: [
      'users:*', 'system:monitor', 'system:debug', 'audit:read'
    ],
    profile: {
      firstName: 'Development',
      lastName: 'Administrator',
      bio: 'Development and testing administrator',
      preferences: {
        theme: 'dark',
        notifications: false,
        language: 'en',
        timezone: 'UTC',
        dashboardLayout: 'developer'
      }
    }
  }
};

// Template application service
class AdminTemplateService {
  constructor(adminService) {
    this.adminService = adminService;
  }

  async createFromTemplate(templateName, overrides = {}) {
    const template = AdminTemplates[templateName];
    if (!template) {
      throw new Error(`Template '${templateName}' not found`);
    }

    const adminData = {
      ...template,
      ...overrides,
      profile: {
        ...template.profile,
        ...overrides.profile
      }
    };

    return await this.adminService.createAdminUser(adminData);
  }

  async createMultipleFromTemplates(templateConfigs) {
    const results = [];

    for (const config of templateConfigs) {
      try {
        const admin = await this.createFromTemplate(config.template, config.overrides);
        results.push({ success: true, admin, template: config.template });
      } catch (error) {
        results.push({
          success: false,
          error: error.message,
          template: config.template
        });
      }
    }

    return results;
  }

  listAvailableTemplates() {
    return Object.keys(AdminTemplates).map(key => ({
      name: key,
      role: AdminTemplates[key].role,
      description: AdminTemplates[key].profile.bio
    }));
  }
}
```

## JWT Authentication Patterns

### JWT Service Class
```javascript
// jwt-service.js - Reusable JWT service
class JWTService {
    constructor(config) {
        this.secret = config.secret;
        this.accessTokenExpiry = config.accessTokenExpiry || '15m';
        this.refreshTokenExpiry = config.refreshTokenExpiry || '7d';
    }

    generateTokens(payload) {
        const accessToken = jwt.sign(payload, this.secret, {
            expiresIn: this.accessTokenExpiry
        });
        
        const refreshToken = jwt.sign(
            { userId: payload.sub, type: 'refresh' },
            this.secret,
            { expiresIn: this.refreshTokenExpiry }
        );

        return { accessToken, refreshToken };
    }

    verifyAccessToken(token) {
        try {
            return jwt.verify(token, this.secret);
        } catch (error) {
            throw new AuthenticationError('Invalid access token');
        }
    }

    verifyRefreshToken(token) {
        try {
            const decoded = jwt.verify(token, this.secret);
            if (decoded.type !== 'refresh') {
                throw new Error('Invalid token type');
            }
            return decoded;
        } catch (error) {
            throw new AuthenticationError('Invalid refresh token');
        }
    }
}
```

### Authentication Middleware
```javascript
// auth-middleware.js - Express authentication middleware
function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

    if (!token) {
        return res.status(401).json({ error: 'Access token required' });
    }

    try {
        const decoded = jwtService.verifyAccessToken(token);
        req.user = decoded;
        next();
    } catch (error) {
        return res.status(403).json({ error: 'Invalid or expired token' });
    }
}

function requireRole(roles) {
    return (req, res, next) => {
        if (!req.user) {
            return res.status(401).json({ error: 'Authentication required' });
        }

        const userRoles = req.user.roles || [];
        const hasRole = roles.some(role => userRoles.includes(role));

        if (!hasRole) {
            return res.status(403).json({ error: 'Insufficient permissions' });
        }

        next();
    };
}
```

## Frontend Authentication Patterns

### React Authentication Hook
```javascript
// useAuth.js - React authentication hook
import { createContext, useContext, useReducer, useEffect } from 'react';

const AuthContext = createContext();

const authReducer = (state, action) => {
    switch (action.type) {
        case 'LOGIN_START':
            return { ...state, loading: true, error: null };
        case 'LOGIN_SUCCESS':
            return {
                ...state,
                loading: false,
                user: action.payload.user,
                token: action.payload.token,
                isAuthenticated: true
            };
        case 'LOGIN_ERROR':
            return {
                ...state,
                loading: false,
                error: action.payload,
                isAuthenticated: false
            };
        case 'LOGOUT':
            return {
                ...state,
                user: null,
                token: null,
                isAuthenticated: false
            };
        default:
            return state;
    }
};

export function AuthProvider({ children }) {
    const [state, dispatch] = useReducer(authReducer, {
        user: null,
        token: localStorage.getItem('token'),
        isAuthenticated: false,
        loading: false,
        error: null
    });

    const login = async (credentials) => {
        dispatch({ type: 'LOGIN_START' });
        try {
            const response = await authAPI.login(credentials);
            localStorage.setItem('token', response.token);
            dispatch({
                type: 'LOGIN_SUCCESS',
                payload: response
            });
        } catch (error) {
            dispatch({
                type: 'LOGIN_ERROR',
                payload: error.message
            });
        }
    };

    const logout = () => {
        localStorage.removeItem('token');
        dispatch({ type: 'LOGOUT' });
    };

    return (
        <AuthContext.Provider value={{ ...state, login, logout }}>
            {children}
        </AuthContext.Provider>
    );
}

export const useAuth = () => {
    const context = useContext(AuthContext);
    if (!context) {
        throw new Error('useAuth must be used within AuthProvider');
    }
    return context;
};
```

### Protected Route Component
```javascript
// ProtectedRoute.jsx - React protected route
import { Navigate, useLocation } from 'react-router-dom';
import { useAuth } from './useAuth';

export function ProtectedRoute({ children, roles = [] }) {
    const { isAuthenticated, user, loading } = useAuth();
    const location = useLocation();

    if (loading) {
        return <div>Loading...</div>;
    }

    if (!isAuthenticated) {
        return <Navigate to="/login" state={{ from: location }} replace />;
    }

    if (roles.length > 0) {
        const userRoles = user?.roles || [];
        const hasRole = roles.some(role => userRoles.includes(role));
        
        if (!hasRole) {
            return <Navigate to="/unauthorized" replace />;
        }
    }

    return children;
}
```

### Vue.js Authentication Composable
```javascript
// useAuth.js - Vue 3 Composition API
import { ref, computed, reactive } from 'vue';
import { useRouter } from 'vue-router';

const authState = reactive({
    user: null,
    token: localStorage.getItem('token'),
    loading: false,
    error: null
});

export function useAuth() {
    const router = useRouter();

    const isAuthenticated = computed(() => !!authState.token && !!authState.user);

    const login = async (credentials) => {
        authState.loading = true;
        authState.error = null;

        try {
            const response = await authAPI.login(credentials);
            authState.user = response.user;
            authState.token = response.token;
            localStorage.setItem('token', response.token);
            
            router.push('/dashboard');
        } catch (error) {
            authState.error = error.message;
        } finally {
            authState.loading = false;
        }
    };

    const logout = () => {
        authState.user = null;
        authState.token = null;
        localStorage.removeItem('token');
        router.push('/login');
    };

    const hasRole = (role) => {
        return authState.user?.roles?.includes(role) || false;
    };

    return {
        user: computed(() => authState.user),
        token: computed(() => authState.token),
        loading: computed(() => authState.loading),
        error: computed(() => authState.error),
        isAuthenticated,
        login,
        logout,
        hasRole
    };
}
```

## Session-Based Authentication Patterns

### Session Authentication Middleware
```javascript
// session-auth.js - Session-based authentication
function requireAuth(req, res, next) {
    if (req.session && req.session.userId) {
        // Load user from database
        User.findById(req.session.userId)
            .then(user => {
                if (user) {
                    req.user = user;
                    next();
                } else {
                    req.session.destroy();
                    res.status(401).json({ error: 'Session invalid' });
                }
            })
            .catch(error => {
                res.status(500).json({ error: 'Authentication error' });
            });
    } else {
        res.status(401).json({ error: 'Authentication required' });
    }
}

function createSession(req, user) {
    req.session.userId = user.id;
    req.session.roles = user.roles;
    req.session.save();
}

function destroySession(req) {
    req.session.destroy();
}
```

## OAuth 2.0 Patterns

### OAuth Strategy Pattern
```javascript
// oauth-strategy.js - Generic OAuth strategy
class OAuthStrategy {
    constructor(provider, config) {
        this.provider = provider;
        this.clientId = config.clientId;
        this.clientSecret = config.clientSecret;
        this.redirectUri = config.redirectUri;
        this.scope = config.scope;
    }

    getAuthorizationUrl(state) {
        const params = new URLSearchParams({
            client_id: this.clientId,
            redirect_uri: this.redirectUri,
            scope: this.scope.join(' '),
            response_type: 'code',
            state: state
        });

        return `${this.provider.authUrl}?${params.toString()}`;
    }

    async exchangeCodeForToken(code) {
        const response = await fetch(this.provider.tokenUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Accept': 'application/json'
            },
            body: new URLSearchParams({
                client_id: this.clientId,
                client_secret: this.clientSecret,
                code: code,
                redirect_uri: this.redirectUri,
                grant_type: 'authorization_code'
            })
        });

        return response.json();
    }

    async getUserProfile(accessToken) {
        const response = await fetch(this.provider.userUrl, {
            headers: {
                'Authorization': `Bearer ${accessToken}`,
                'Accept': 'application/json'
            }
        });

        return response.json();
    }
}
```

## Permission Checking Patterns

### Resource-Based Permissions
```javascript
// permissions.js - Resource-based permission checking
class PermissionChecker {
    constructor(user) {
        this.user = user;
    }

    can(action, resource) {
        // Check direct permissions
        const permission = `${action}:${resource}`;
        if (this.user.permissions.includes(permission)) {
            return true;
        }

        // Check role-based permissions
        return this.user.roles.some(role => {
            const rolePermissions = this.getRolePermissions(role);
            return rolePermissions.includes(permission);
        });
    }

    canAccess(resource, resourceId = null) {
        // Check if user can access specific resource instance
        if (resourceId && this.isResourceOwner(resource, resourceId)) {
            return true;
        }

        return this.can('read', resource);
    }

    canModify(resource, resourceId = null) {
        if (resourceId && this.isResourceOwner(resource, resourceId)) {
            return true;
        }

        return this.can('update', resource) || this.can('delete', resource);
    }

    isResourceOwner(resource, resourceId) {
        // Check if user owns the specific resource
        return this.user.ownedResources?.[resource]?.includes(resourceId);
    }

    getRolePermissions(role) {
        const rolePermissions = {
            admin: ['*:*'],
            moderator: ['read:*', 'update:posts', 'delete:comments'],
            user: ['read:posts', 'create:posts', 'update:own_posts']
        };

        return rolePermissions[role] || [];
    }
}

// Usage example
function requirePermission(action, resource) {
    return (req, res, next) => {
        const checker = new PermissionChecker(req.user);
        
        if (checker.can(action, resource)) {
            next();
        } else {
            res.status(403).json({ error: 'Insufficient permissions' });
        }
    };
}
```

## Error Handling Patterns

### Authentication Error Classes
```javascript
// auth-errors.js - Standardized authentication errors
class AuthError extends Error {
    constructor(message, code, statusCode = 401) {
        super(message);
        this.name = 'AuthError';
        this.code = code;
        this.statusCode = statusCode;
    }
}

class InvalidCredentialsError extends AuthError {
    constructor() {
        super('Invalid credentials', 'INVALID_CREDENTIALS', 401);
    }
}

class TokenExpiredError extends AuthError {
    constructor() {
        super('Token has expired', 'TOKEN_EXPIRED', 401);
    }
}

class InsufficientPermissionsError extends AuthError {
    constructor() {
        super('Insufficient permissions', 'INSUFFICIENT_PERMISSIONS', 403);
    }
}

// Error handling middleware
function handleAuthError(error, req, res, next) {
    if (error instanceof AuthError) {
        return res.status(error.statusCode).json({
            error: error.message,
            code: error.code
        });
    }

    next(error);
}
```

## Testing Patterns

### Authentication Test Helpers
```javascript
// auth-test-helpers.js - Testing utilities
class AuthTestHelper {
    static createMockUser(overrides = {}) {
        return {
            id: 'user-123',
            email: 'test@example.com',
            roles: ['user'],
            permissions: ['read:posts'],
            ...overrides
        };
    }

    static createMockToken(payload = {}) {
        const defaultPayload = {
            sub: 'user-123',
            roles: ['user'],
            iat: Math.floor(Date.now() / 1000),
            exp: Math.floor(Date.now() / 1000) + 3600
        };

        return jwt.sign({ ...defaultPayload, ...payload }, 'test-secret');
    }

    static mockAuthenticatedRequest(user = null) {
        const mockUser = user || this.createMockUser();
        const token = this.createMockToken({ sub: mockUser.id });

        return {
            headers: {
                authorization: `Bearer ${token}`
            },
            user: mockUser
        };
    }
}

// Usage in tests
describe('Protected Route', () => {
    it('should allow access with valid token', async () => {
        const req = AuthTestHelper.mockAuthenticatedRequest();
        const res = mockResponse();
        const next = jest.fn();

        authenticateToken(req, res, next);

        expect(next).toHaveBeenCalled();
        expect(req.user).toBeDefined();
    });
});
```

## Framework-Specific Admin Authentication Examples

### React Admin Authentication Integration
```jsx
// React hook for admin authentication
import { useState, useEffect, createContext, useContext } from 'react';
import { AdminAccountService } from '../services/admin-account-service';

const AdminAuthContext = createContext();

export function AdminAuthProvider({ children }) {
  const [admin, setAdmin] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const adminService = new AdminAccountService();

  useEffect(() => {
    checkAdminAuth();
  }, []);

  const checkAdminAuth = async () => {
    try {
      const token = localStorage.getItem('admin_token');
      if (token) {
        const adminData = await adminService.validateAdminToken(token);
        setAdmin(adminData);
      }
    } catch (err) {
      localStorage.removeItem('admin_token');
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const loginAdmin = async (credentials) => {
    try {
      setLoading(true);
      const { admin, token } = await adminService.authenticateAdmin(credentials);
      localStorage.setItem('admin_token', token);
      setAdmin(admin);
      return admin;
    } catch (err) {
      setError(err.message);
      throw err;
    } finally {
      setLoading(false);
    }
  };

  const logoutAdmin = () => {
    localStorage.removeItem('admin_token');
    setAdmin(null);
  };

  const createAdmin = async (adminData) => {
    try {
      return await adminService.createAdminUser(adminData);
    } catch (err) {
      setError(err.message);
      throw err;
    }
  };

  return (
    <AdminAuthContext.Provider value={{
      admin,
      loading,
      error,
      loginAdmin,
      logoutAdmin,
      createAdmin,
      isAuthenticated: !!admin
    }}>
      {children}
    </AdminAuthContext.Provider>
  );
}

export const useAdminAuth = () => {
  const context = useContext(AdminAuthContext);
  if (!context) {
    throw new Error('useAdminAuth must be used within AdminAuthProvider');
  }
  return context;
};

// React component for admin setup
function AdminSetupPage() {
  const { createAdmin, isAuthenticated } = useAdminAuth();
  const [formData, setFormData] = useState({
    email: '',
    firstName: '',
    lastName: '',
    role: 'admin'
  });

  if (!isAuthenticated) {
    return <div>Access denied. Admin authentication required.</div>;
  }

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const newAdmin = await createAdmin(formData);
      alert(`Admin created: ${newAdmin.email}`);
      setFormData({ email: '', firstName: '', lastName: '', role: 'admin' });
    } catch (error) {
      alert(`Error: ${error.message}`);
    }
  };

  return (
    <div className="admin-setup">
      <h2>Create New Admin</h2>
      <form onSubmit={handleSubmit}>
        <input
          type="email"
          placeholder="Email"
          value={formData.email}
          onChange={(e) => setFormData({...formData, email: e.target.value})}
          required
        />
        <input
          type="text"
          placeholder="First Name"
          value={formData.firstName}
          onChange={(e) => setFormData({...formData, firstName: e.target.value})}
          required
        />
        <input
          type="text"
          placeholder="Last Name"
          value={formData.lastName}
          onChange={(e) => setFormData({...formData, lastName: e.target.value})}
          required
        />
        <select
          value={formData.role}
          onChange={(e) => setFormData({...formData, role: e.target.value})}
        >
          <option value="admin">Admin</option>
          <option value="super_admin">Super Admin</option>
          <option value="moderator">Moderator</option>
        </select>
        <button type="submit">Create Admin</button>
      </form>
    </div>
  );
}
```

### Vue.js Admin Authentication Integration
```vue
<!-- Vue admin authentication composable -->
<script>
// composables/useAdminAuth.js
import { ref, reactive, computed } from 'vue';
import { AdminAccountService } from '../services/admin-account-service';

const adminState = reactive({
  admin: null,
  loading: false,
  error: null
});

export function useAdminAuth() {
  const adminService = new AdminAccountService();

  const isAuthenticated = computed(() => !!adminState.admin);

  const loginAdmin = async (credentials) => {
    adminState.loading = true;
    adminState.error = null;

    try {
      const { admin, token } = await adminService.authenticateAdmin(credentials);
      localStorage.setItem('admin_token', token);
      adminState.admin = admin;
      return admin;
    } catch (error) {
      adminState.error = error.message;
      throw error;
    } finally {
      adminState.loading = false;
    }
  };

  const logoutAdmin = () => {
    localStorage.removeItem('admin_token');
    adminState.admin = null;
  };

  const createAdmin = async (adminData) => {
    try {
      return await adminService.createAdminUser(adminData);
    } catch (error) {
      adminState.error = error.message;
      throw error;
    }
  };

  const checkAdminAuth = async () => {
    const token = localStorage.getItem('admin_token');
    if (token) {
      try {
        const adminData = await adminService.validateAdminToken(token);
        adminState.admin = adminData;
      } catch (error) {
        localStorage.removeItem('admin_token');
      }
    }
  };

  return {
    admin: computed(() => adminState.admin),
    loading: computed(() => adminState.loading),
    error: computed(() => adminState.error),
    isAuthenticated,
    loginAdmin,
    logoutAdmin,
    createAdmin,
    checkAdminAuth
  };
}
</script>

<!-- Vue component for admin setup -->
<template>
  <div class="admin-setup">
    <div v-if="!isAuthenticated" class="access-denied">
      Access denied. Admin authentication required.
    </div>
    <div v-else>
      <h2>Create New Admin</h2>
      <form @submit.prevent="handleSubmit">
        <input
          v-model="formData.email"
          type="email"
          placeholder="Email"
          required
        />
        <input
          v-model="formData.firstName"
          type="text"
          placeholder="First Name"
          required
        />
        <input
          v-model="formData.lastName"
          type="text"
          placeholder="Last Name"
          required
        />
        <select v-model="formData.role">
          <option value="admin">Admin</option>
          <option value="super_admin">Super Admin</option>
          <option value="moderator">Moderator</option>
        </select>
        <button type="submit" :disabled="loading">
          {{ loading ? 'Creating...' : 'Create Admin' }}
        </button>
      </form>
      <div v-if="error" class="error">{{ error }}</div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useAdminAuth } from '../composables/useAdminAuth';

const { isAuthenticated, createAdmin, loading, error, checkAdminAuth } = useAdminAuth();

const formData = ref({
  email: '',
  firstName: '',
  lastName: '',
  role: 'admin'
});

const handleSubmit = async () => {
  try {
    const newAdmin = await createAdmin(formData.value);
    alert(`Admin created: ${newAdmin.email}`);
    formData.value = { email: '', firstName: '', lastName: '', role: 'admin' };
  } catch (error) {
    alert(`Error: ${error.message}`);
  }
};

onMounted(checkAdminAuth);
</script>
```

### Angular Admin Authentication Integration
```typescript
// Angular admin authentication service
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { AdminAccountService } from '../services/admin-account-service';

@Injectable({
  providedIn: 'root'
})
export class AdminAuthService {
  private adminSubject = new BehaviorSubject<any>(null);
  private loadingSubject = new BehaviorSubject<boolean>(false);
  private errorSubject = new BehaviorSubject<string | null>(null);

  public admin$ = this.adminSubject.asObservable();
  public loading$ = this.loadingSubject.asObservable();
  public error$ = this.errorSubject.asObservable();
  public isAuthenticated$ = this.admin$.pipe(
    map(admin => !!admin)
  );

  private adminService = new AdminAccountService();

  constructor() {
    this.checkAdminAuth();
  }

  async checkAdminAuth(): Promise<void> {
    const token = localStorage.getItem('admin_token');
    if (token) {
      try {
        const adminData = await this.adminService.validateAdminToken(token);
        this.adminSubject.next(adminData);
      } catch (error) {
        localStorage.removeItem('admin_token');
        this.errorSubject.next(error.message);
      }
    }
  }

  async loginAdmin(credentials: any): Promise<any> {
    this.loadingSubject.next(true);
    this.errorSubject.next(null);

    try {
      const { admin, token } = await this.adminService.authenticateAdmin(credentials);
      localStorage.setItem('admin_token', token);
      this.adminSubject.next(admin);
      return admin;
    } catch (error) {
      this.errorSubject.next(error.message);
      throw error;
    } finally {
      this.loadingSubject.next(false);
    }
  }

  logoutAdmin(): void {
    localStorage.removeItem('admin_token');
    this.adminSubject.next(null);
  }

  async createAdmin(adminData: any): Promise<any> {
    try {
      return await this.adminService.createAdminUser(adminData);
    } catch (error) {
      this.errorSubject.next(error.message);
      throw error;
    }
  }
}

// Angular component for admin setup
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { AdminAuthService } from '../services/admin-auth.service';

@Component({
  selector: 'app-admin-setup',
  template: `
    <div class="admin-setup">
      <div *ngIf="!(isAuthenticated$ | async)" class="access-denied">
        Access denied. Admin authentication required.
      </div>
      <div *ngIf="isAuthenticated$ | async">
        <h2>Create New Admin</h2>
        <form [formGroup]="adminForm" (ngSubmit)="onSubmit()">
          <input formControlName="email" type="email" placeholder="Email" required>
          <input formControlName="firstName" type="text" placeholder="First Name" required>
          <input formControlName="lastName" type="text" placeholder="Last Name" required>
          <select formControlName="role">
            <option value="admin">Admin</option>
            <option value="super_admin">Super Admin</option>
            <option value="moderator">Moderator</option>
          </select>
          <button type="submit" [disabled]="adminForm.invalid || (loading$ | async)">
            {{ (loading$ | async) ? 'Creating...' : 'Create Admin' }}
          </button>
        </form>
        <div *ngIf="error$ | async as error" class="error">{{ error }}</div>
      </div>
    </div>
  `
})
export class AdminSetupComponent implements OnInit {
  adminForm: FormGroup;
  isAuthenticated$ = this.adminAuth.isAuthenticated$;
  loading$ = this.adminAuth.loading$;
  error$ = this.adminAuth.error$;

  constructor(
    private fb: FormBuilder,
    private adminAuth: AdminAuthService
  ) {
    this.adminForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      firstName: ['', Validators.required],
      lastName: ['', Validators.required],
      role: ['admin', Validators.required]
    });
  }

  ngOnInit(): void {}

  async onSubmit(): Promise<void> {
    if (this.adminForm.valid) {
      try {
        const newAdmin = await this.adminAuth.createAdmin(this.adminForm.value);
        alert(`Admin created: ${newAdmin.email}`);
        this.adminForm.reset({ role: 'admin' });
      } catch (error) {
        alert(`Error: ${error.message}`);
      }
    }
  }
}
```

### Vanilla JavaScript Admin Authentication
```javascript
// Vanilla JS admin authentication manager
class AdminAuthManager {
  constructor() {
    this.admin = null;
    this.loading = false;
    this.error = null;
    this.adminService = new AdminAccountService();
    this.init();
  }

  async init() {
    await this.checkAdminAuth();
    this.setupUI();
  }

  async checkAdminAuth() {
    const token = localStorage.getItem('admin_token');
    if (token) {
      try {
        const adminData = await this.adminService.validateAdminToken(token);
        this.admin = adminData;
      } catch (error) {
        localStorage.removeItem('admin_token');
        this.error = error.message;
      }
    }
  }

  async loginAdmin(credentials) {
    this.loading = true;
    this.updateUI();

    try {
      const { admin, token } = await this.adminService.authenticateAdmin(credentials);
      localStorage.setItem('admin_token', token);
      this.admin = admin;
      this.error = null;
      this.setupUI();
    } catch (error) {
      this.error = error.message;
      this.updateUI();
    } finally {
      this.loading = false;
    }
  }

  logoutAdmin() {
    localStorage.removeItem('admin_token');
    this.admin = null;
    this.setupUI();
  }

  async createAdmin(adminData) {
    try {
      const newAdmin = await this.adminService.createAdminUser(adminData);
      alert(`Admin created: ${newAdmin.email}`);
      return newAdmin;
    } catch (error) {
      this.error = error.message;
      this.updateUI();
      throw error;
    }
  }

  setupUI() {
    const container = document.getElementById('admin-container');

    if (!this.admin) {
      container.innerHTML = `
        <div class="admin-login">
          <h2>Admin Login</h2>
          <form id="login-form">
            <input type="email" id="login-email" placeholder="Admin Email" required>
            <input type="password" id="login-password" placeholder="Password" required>
            <button type="submit">Login</button>
          </form>
          ${this.error ? `<div class="error">${this.error}</div>` : ''}
        </div>
      `;

      document.getElementById('login-form').addEventListener('submit', async (e) => {
        e.preventDefault();
        const email = document.getElementById('login-email').value;
        const password = document.getElementById('login-password').value;
        await this.loginAdmin({ email, password });
      });
    } else {
      container.innerHTML = `
        <div class="admin-dashboard">
          <div class="admin-header">
            <h2>Admin Dashboard</h2>
            <span>Welcome, ${this.admin.email}</span>
            <button id="logout-btn">Logout</button>
          </div>
          <div class="admin-setup">
            <h3>Create New Admin</h3>
            <form id="admin-form">
              <input type="email" id="admin-email" placeholder="Email" required>
              <input type="text" id="admin-firstname" placeholder="First Name" required>
              <input type="text" id="admin-lastname" placeholder="Last Name" required>
              <select id="admin-role">
                <option value="admin">Admin</option>
                <option value="super_admin">Super Admin</option>
                <option value="moderator">Moderator</option>
              </select>
              <button type="submit">Create Admin</button>
            </form>
          </div>
          ${this.error ? `<div class="error">${this.error}</div>` : ''}
        </div>
      `;

      document.getElementById('logout-btn').addEventListener('click', () => {
        this.logoutAdmin();
      });

      document.getElementById('admin-form').addEventListener('submit', async (e) => {
        e.preventDefault();
        const adminData = {
          email: document.getElementById('admin-email').value,
          firstName: document.getElementById('admin-firstname').value,
          lastName: document.getElementById('admin-lastname').value,
          role: document.getElementById('admin-role').value
        };

        try {
          await this.createAdmin(adminData);
          document.getElementById('admin-form').reset();
        } catch (error) {
          // Error already handled in createAdmin method
        }
      });
    }
  }

  updateUI() {
    if (this.loading) {
      const container = document.getElementById('admin-container');
      container.innerHTML = '<div class="loading">Loading...</div>';
    } else {
      this.setupUI();
    }
  }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  new AdminAuthManager();
});
```

---

*Framework Support: React, Vue, Angular, Vanilla JS*
*Last Updated: 2025-07-11*
*Admin Features: Account Creation, Shared Credentials, RBAC Integration*
