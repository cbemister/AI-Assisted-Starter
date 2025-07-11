# Role-Based Access Control (RBAC) Patterns

Enterprise-grade role-based access control implementation patterns with admin privileges, hierarchical permissions, and dynamic role management.

## Core RBAC Architecture

### RBAC Database Schema
```sql
-- Comprehensive RBAC schema design
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    display_name VARCHAR(200) NOT NULL,
    description TEXT,
    level INTEGER DEFAULT 0, -- Hierarchy level (0 = lowest, 100 = highest)
    is_system_role BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE permissions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    display_name VARCHAR(200) NOT NULL,
    description TEXT,
    resource VARCHAR(100) NOT NULL,
    action VARCHAR(50) NOT NULL,
    scope VARCHAR(50) DEFAULT 'global', -- global, tenant, user
    is_system_permission BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE role_permissions (
    id SERIAL PRIMARY KEY,
    role_id INTEGER NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permission_id INTEGER NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    granted_by INTEGER REFERENCES users(id),
    UNIQUE(role_id, permission_id)
);

CREATE TABLE user_roles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id INTEGER NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assigned_by INTEGER REFERENCES users(id),
    expires_at TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    UNIQUE(user_id, role_id)
);

CREATE TABLE user_permissions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    permission_id INTEGER NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    granted_by INTEGER REFERENCES users(id),
    expires_at TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    UNIQUE(user_id, permission_id)
);

-- Role hierarchy for inheritance
CREATE TABLE role_hierarchy (
    id SERIAL PRIMARY KEY,
    parent_role_id INTEGER NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    child_role_id INTEGER NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(parent_role_id, child_role_id)
);

-- Indexes for performance
CREATE INDEX idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX idx_user_roles_active ON user_roles(user_id, is_active);
CREATE INDEX idx_role_permissions_role_id ON role_permissions(role_id);
CREATE INDEX idx_user_permissions_user_id ON user_permissions(user_id);
CREATE INDEX idx_permissions_resource_action ON permissions(resource, action);
```

### RBAC Service Implementation
```javascript
// rbac-service.js - Comprehensive RBAC service
class RBACService {
  constructor(database) {
    this.db = database;
    this.permissionCache = new Map();
    this.roleCache = new Map();
  }

  async createRole(roleData, createdBy) {
    const {
      name,
      displayName,
      description,
      level = 0,
      permissions = [],
      parentRoles = []
    } = roleData;

    return await this.db.transaction(async (tx) => {
      // Create role
      const role = await tx.role.create({
        data: {
          name,
          displayName,
          description,
          level,
          isSystemRole: false
        }
      });

      // Assign permissions
      if (permissions.length > 0) {
        await this.assignPermissionsToRole(tx, role.id, permissions, createdBy);
      }

      // Set up role hierarchy
      if (parentRoles.length > 0) {
        await this.setRoleParents(tx, role.id, parentRoles);
      }

      // Clear cache
      this.clearRoleCache();

      return role;
    });
  }

  async assignPermissionsToRole(tx, roleId, permissionIds, grantedBy) {
    const assignments = permissionIds.map(permissionId => ({
      roleId,
      permissionId,
      grantedBy
    }));

    await tx.rolePermission.createMany({
      data: assignments,
      skipDuplicates: true
    });
  }

  async assignRoleToUser(userId, roleId, assignedBy, expiresAt = null) {
    // Check if user already has role
    const existingAssignment = await this.db.userRole.findFirst({
      where: { userId, roleId, isActive: true }
    });

    if (existingAssignment) {
      throw new Error('User already has this role');
    }

    // Check role level permissions
    await this.validateRoleAssignment(userId, roleId, assignedBy);

    const assignment = await this.db.userRole.create({
      data: {
        userId,
        roleId,
        assignedBy,
        expiresAt,
        isActive: true
      }
    });

    // Clear user permission cache
    this.clearUserPermissionCache(userId);

    return assignment;
  }

  async validateRoleAssignment(userId, roleId, assignedBy) {
    const role = await this.db.role.findUnique({ where: { id: roleId } });
    const assignerRoles = await this.getUserRoles(assignedBy);
    
    // Check if assigner has sufficient privileges
    const maxAssignerLevel = Math.max(...assignerRoles.map(r => r.level));
    
    if (role.level >= maxAssignerLevel && assignedBy !== userId) {
      throw new Error('Insufficient privileges to assign this role');
    }
  }

  async getUserPermissions(userId, includeExpired = false) {
    const cacheKey = `user_permissions_${userId}_${includeExpired}`;
    
    if (this.permissionCache.has(cacheKey)) {
      return this.permissionCache.get(cacheKey);
    }

    const permissions = await this.db.user.findUnique({
      where: { id: userId },
      include: {
        userRoles: {
          where: includeExpired ? {} : {
            isActive: true,
            OR: [
              { expiresAt: null },
              { expiresAt: { gt: new Date() } }
            ]
          },
          include: {
            role: {
              include: {
                rolePermissions: {
                  include: { permission: true }
                }
              }
            }
          }
        },
        userPermissions: {
          where: includeExpired ? {} : {
            isActive: true,
            OR: [
              { expiresAt: null },
              { expiresAt: { gt: new Date() } }
            ]
          },
          include: { permission: true }
        }
      }
    });

    if (!permissions) {
      return [];
    }

    // Collect all permissions from roles and direct assignments
    const allPermissions = new Map();

    // Add role-based permissions
    for (const userRole of permissions.userRoles) {
      for (const rolePermission of userRole.role.rolePermissions) {
        const perm = rolePermission.permission;
        allPermissions.set(perm.id, perm);
      }
    }

    // Add direct user permissions
    for (const userPermission of permissions.userPermissions) {
      const perm = userPermission.permission;
      allPermissions.set(perm.id, perm);
    }

    const result = Array.from(allPermissions.values());
    
    // Cache for 5 minutes
    this.permissionCache.set(cacheKey, result);
    setTimeout(() => this.permissionCache.delete(cacheKey), 5 * 60 * 1000);

    return result;
  }

  async checkPermission(userId, resource, action, scope = 'global') {
    const permissions = await this.getUserPermissions(userId);
    
    return permissions.some(permission => {
      // Check exact match
      if (permission.resource === resource && 
          permission.action === action && 
          permission.scope === scope) {
        return true;
      }

      // Check wildcard permissions
      if (permission.resource === '*' || permission.action === '*') {
        return true;
      }

      // Check resource wildcards
      if (permission.resource === resource && permission.action === '*') {
        return true;
      }

      return false;
    });
  }

  async getUserRoles(userId) {
    const user = await this.db.user.findUnique({
      where: { id: userId },
      include: {
        userRoles: {
          where: {
            isActive: true,
            OR: [
              { expiresAt: null },
              { expiresAt: { gt: new Date() } }
            ]
          },
          include: { role: true }
        }
      }
    });

    return user?.userRoles.map(ur => ur.role) || [];
  }

  clearUserPermissionCache(userId) {
    for (const key of this.permissionCache.keys()) {
      if (key.startsWith(`user_permissions_${userId}_`)) {
        this.permissionCache.delete(key);
      }
    }
  }

  clearRoleCache() {
    this.roleCache.clear();
  }
}

export default RBACService;
```

## Admin Role Patterns

### Admin Role Hierarchy
```javascript
// admin-roles.js - Predefined admin role hierarchy
export const AdminRoleHierarchy = {
  // Super Admin - Highest level
  SUPER_ADMIN: {
    name: 'super_admin',
    displayName: 'Super Administrator',
    description: 'Complete system access with all privileges',
    level: 100,
    permissions: ['*:*'], // All permissions
    isSystemRole: true,
    canAssignRoles: ['*'], // Can assign any role
    restrictions: [] // No restrictions
  },

  // System Admin - High level system management
  SYSTEM_ADMIN: {
    name: 'system_admin',
    displayName: 'System Administrator',
    description: 'System configuration and user management',
    level: 90,
    permissions: [
      'users:*', 'roles:*', 'permissions:read',
      'system:configure', 'system:monitor', 'system:backup',
      'audit:read', 'audit:export'
    ],
    isSystemRole: true,
    canAssignRoles: ['admin', 'moderator', 'user'],
    restrictions: ['cannot_modify_super_admin']
  },

  // Admin - Standard administrative access
  ADMIN: {
    name: 'admin',
    displayName: 'Administrator',
    description: 'Standard administrative privileges',
    level: 80,
    permissions: [
      'users:read', 'users:update', 'users:create',
      'content:*', 'reports:*',
      'system:monitor'
    ],
    isSystemRole: false,
    canAssignRoles: ['moderator', 'user'],
    restrictions: ['cannot_modify_system_roles']
  },

  // Content Admin - Content-focused administration
  CONTENT_ADMIN: {
    name: 'content_admin',
    displayName: 'Content Administrator',
    description: 'Content management and moderation',
    level: 70,
    permissions: [
      'content:*', 'media:*', 'comments:*',
      'users:read', 'reports:read'
    ],
    isSystemRole: false,
    canAssignRoles: ['moderator'],
    restrictions: ['content_scope_only']
  },

  // Moderator - Limited administrative access
  MODERATOR: {
    name: 'moderator',
    displayName: 'Moderator',
    description: 'Content moderation and basic user management',
    level: 60,
    permissions: [
      'content:read', 'content:update', 'content:moderate',
      'comments:*', 'users:read',
      'reports:read', 'reports:update'
    ],
    isSystemRole: false,
    canAssignRoles: [],
    restrictions: ['moderation_scope_only']
  }
};

// Admin role setup service
class AdminRoleSetupService {
  constructor(rbacService) {
    this.rbacService = rbacService;
  }

  async setupAdminRoles() {
    console.log('Setting up admin role hierarchy...');
    
    const results = {};
    
    // Create roles in order of hierarchy (lowest to highest)
    const roleOrder = ['MODERATOR', 'CONTENT_ADMIN', 'ADMIN', 'SYSTEM_ADMIN', 'SUPER_ADMIN'];
    
    for (const roleKey of roleOrder) {
      try {
        const roleConfig = AdminRoleHierarchy[roleKey];
        const role = await this.createAdminRole(roleConfig);
        results[roleKey] = { success: true, role };
        console.log(`✅ Created role: ${roleConfig.displayName}`);
      } catch (error) {
        results[roleKey] = { success: false, error: error.message };
        console.error(`❌ Failed to create role ${roleKey}:`, error.message);
      }
    }

    return results;
  }

  async createAdminRole(roleConfig) {
    // Check if role already exists
    const existingRole = await this.rbacService.db.role.findUnique({
      where: { name: roleConfig.name }
    });

    if (existingRole) {
      return existingRole;
    }

    // Create permissions first
    const permissionIds = await this.createRolePermissions(roleConfig.permissions);

    // Create role
    return await this.rbacService.createRole({
      name: roleConfig.name,
      displayName: roleConfig.displayName,
      description: roleConfig.description,
      level: roleConfig.level,
      permissions: permissionIds
    }, null); // System created
  }

  async createRolePermissions(permissionStrings) {
    const permissionIds = [];

    for (const permString of permissionStrings) {
      if (permString === '*:*') {
        // Grant all existing permissions
        const allPermissions = await this.rbacService.db.permission.findMany();
        permissionIds.push(...allPermissions.map(p => p.id));
        continue;
      }

      const [resource, action] = permString.split(':');
      
      if (action === '*') {
        // Grant all actions for resource
        const resourcePermissions = await this.rbacService.db.permission.findMany({
          where: { resource }
        });
        permissionIds.push(...resourcePermissions.map(p => p.id));
      } else {
        // Grant specific permission
        let permission = await this.rbacService.db.permission.findUnique({
          where: { name: permString }
        });

        if (!permission) {
          permission = await this.rbacService.db.permission.create({
            data: {
              name: permString,
              displayName: this.generateDisplayName(permString),
              description: `Permission to ${action} ${resource}`,
              resource,
              action,
              isSystemPermission: true
            }
          });
        }

        permissionIds.push(permission.id);
      }
    }

    return [...new Set(permissionIds)]; // Remove duplicates
  }

  generateDisplayName(permissionString) {
    const [resource, action] = permissionString.split(':');
    return `${action.charAt(0).toUpperCase() + action.slice(1)} ${resource}`;
  }
}
```

## Permission Middleware

### Advanced Permission Middleware
```javascript
// permission-middleware.js - Advanced RBAC middleware
class PermissionMiddleware {
  constructor(rbacService) {
    this.rbacService = rbacService;
  }

  requirePermission(resource, action, options = {}) {
    return async (req, res, next) => {
      try {
        if (!req.user) {
          return res.status(401).json({ error: 'Authentication required' });
        }

        const {
          scope = 'global',
          allowOwner = false,
          ownerField = 'userId',
          resourceId = null
        } = options;

        // Check basic permission
        const hasPermission = await this.rbacService.checkPermission(
          req.user.id,
          resource,
          action,
          scope
        );

        if (hasPermission) {
          return next();
        }

        // Check owner permission if allowed
        if (allowOwner && resourceId) {
          const isOwner = await this.checkResourceOwnership(
            req.user.id,
            resource,
            resourceId,
            ownerField
          );

          if (isOwner) {
            return next();
          }
        }

        return res.status(403).json({
          error: 'Insufficient permissions',
          required: `${action}:${resource}`,
          scope
        });

      } catch (error) {
        console.error('Permission check error:', error);
        return res.status(500).json({ error: 'Permission check failed' });
      }
    };
  }

  requireRole(roleNames, options = {}) {
    const roles = Array.isArray(roleNames) ? roleNames : [roleNames];
    
    return async (req, res, next) => {
      try {
        if (!req.user) {
          return res.status(401).json({ error: 'Authentication required' });
        }

        const userRoles = await this.rbacService.getUserRoles(req.user.id);
        const userRoleNames = userRoles.map(role => role.name);

        const hasRole = roles.some(role => userRoleNames.includes(role));

        if (!hasRole) {
          return res.status(403).json({
            error: 'Insufficient role privileges',
            required: roles,
            current: userRoleNames
          });
        }

        next();
      } catch (error) {
        console.error('Role check error:', error);
        return res.status(500).json({ error: 'Role check failed' });
      }
    };
  }

  requireAdminLevel(minimumLevel) {
    return async (req, res, next) => {
      try {
        if (!req.user) {
          return res.status(401).json({ error: 'Authentication required' });
        }

        const userRoles = await this.rbacService.getUserRoles(req.user.id);
        const maxLevel = Math.max(...userRoles.map(role => role.level), 0);

        if (maxLevel < minimumLevel) {
          return res.status(403).json({
            error: 'Insufficient admin level',
            required: minimumLevel,
            current: maxLevel
          });
        }

        req.adminLevel = maxLevel;
        next();
      } catch (error) {
        console.error('Admin level check error:', error);
        return res.status(500).json({ error: 'Admin level check failed' });
      }
    };
  }

  async checkResourceOwnership(userId, resource, resourceId, ownerField) {
    try {
      const record = await this.rbacService.db[resource].findUnique({
        where: { id: resourceId }
      });

      return record && record[ownerField] === userId;
    } catch (error) {
      console.error('Ownership check error:', error);
      return false;
    }
  }
}

export default PermissionMiddleware;
```

## Related Documentation

- [Authentication Best Practices](./best-practices.md) - Security guidelines
- [Shared Admin Patterns](./shared-admin-patterns.md) - Cross-application admin
- [Authentication Common Patterns](./common-patterns.md) - General patterns

---

*Last Updated: 2025-07-11*
*RBAC Level: Enterprise*
*Admin Support: Multi-level hierarchy*
