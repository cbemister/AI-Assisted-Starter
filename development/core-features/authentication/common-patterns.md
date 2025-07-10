# Authentication Common Patterns

Reusable code patterns and templates for implementing authentication across different frameworks and scenarios.

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

---

*Framework Support: React, Vue, Angular, Vanilla JS*
*Last Updated: 2025-07-10*
