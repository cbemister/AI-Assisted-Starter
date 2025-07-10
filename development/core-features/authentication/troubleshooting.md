# Authentication Troubleshooting Guide

Common authentication issues and their resolution strategies across different frameworks and implementation patterns.

## JWT Token Issues

### Problem: "Invalid Token" Errors

**Symptoms:**
- 401 Unauthorized responses
- "jwt malformed" errors
- Token verification failures

**Common Causes:**
1. **Incorrect Secret**: Token signed with different secret than verification
2. **Token Corruption**: Malformed token during transmission
3. **Algorithm Mismatch**: Different signing/verification algorithms
4. **Expired Tokens**: Token past expiration time

**Solutions:**
```javascript
// Debug token issues
function debugToken(token) {
    try {
        // Decode without verification to inspect payload
        const decoded = jwt.decode(token, { complete: true });
        console.log('Token Header:', decoded.header);
        console.log('Token Payload:', decoded.payload);
        console.log('Token Signature:', decoded.signature);
        
        // Check expiration
        const now = Math.floor(Date.now() / 1000);
        if (decoded.payload.exp < now) {
            console.log('Token expired:', new Date(decoded.payload.exp * 1000));
        }
    } catch (error) {
        console.log('Token decode error:', error.message);
    }
}

// Verify with proper error handling
function safeVerifyToken(token, secret) {
    try {
        return jwt.verify(token, secret);
    } catch (error) {
        if (error.name === 'TokenExpiredError') {
            throw new AuthError('Token expired', 'TOKEN_EXPIRED');
        } else if (error.name === 'JsonWebTokenError') {
            throw new AuthError('Invalid token', 'INVALID_TOKEN');
        } else {
            throw new AuthError('Token verification failed', 'VERIFICATION_FAILED');
        }
    }
}
```

### Problem: Token Refresh Issues

**Symptoms:**
- Infinite refresh loops
- 401 errors after token refresh
- Refresh token not working

**Solutions:**
```javascript
// Robust token refresh implementation
class TokenManager {
    constructor() {
        this.refreshPromise = null;
    }

    async refreshToken() {
        // Prevent multiple simultaneous refresh attempts
        if (this.refreshPromise) {
            return this.refreshPromise;
        }

        this.refreshPromise = this.performRefresh();
        
        try {
            const result = await this.refreshPromise;
            return result;
        } finally {
            this.refreshPromise = null;
        }
    }

    async performRefresh() {
        const refreshToken = localStorage.getItem('refreshToken');
        
        if (!refreshToken) {
            throw new Error('No refresh token available');
        }

        const response = await fetch('/auth/refresh', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ refreshToken })
        });

        if (!response.ok) {
            localStorage.removeItem('refreshToken');
            throw new Error('Refresh failed');
        }

        const data = await response.json();
        localStorage.setItem('accessToken', data.accessToken);
        
        return data.accessToken;
    }
}
```

## Session Management Issues

### Problem: Session Not Persisting

**Symptoms:**
- User logged out on page refresh
- Session data lost
- "Session not found" errors

**Common Causes:**
1. **Cookie Configuration**: Incorrect cookie settings
2. **Session Store Issues**: Database connection problems
3. **CORS Issues**: Cross-origin cookie problems
4. **HTTPS Requirements**: Secure cookies on HTTP

**Solutions:**
```javascript
// Proper session configuration
app.use(session({
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false,
    store: new MongoStore({
        mongoUrl: process.env.MONGODB_URI,
        touchAfter: 24 * 3600 // Lazy session update
    }),
    cookie: {
        secure: process.env.NODE_ENV === 'production',
        httpOnly: true,
        maxAge: 1000 * 60 * 60 * 24, // 24 hours
        sameSite: process.env.NODE_ENV === 'production' ? 'none' : 'lax'
    }
}));

// Debug session issues
app.use((req, res, next) => {
    console.log('Session ID:', req.sessionID);
    console.log('Session Data:', req.session);
    console.log('Cookie:', req.headers.cookie);
    next();
});
```

## CORS and Cross-Origin Issues

### Problem: Authentication Failing in Cross-Origin Requests

**Symptoms:**
- CORS errors in browser console
- Cookies not sent with requests
- Authentication headers missing

**Solutions:**
```javascript
// Proper CORS configuration for authentication
const cors = require('cors');

app.use(cors({
    origin: process.env.FRONTEND_URL,
    credentials: true, // Allow cookies
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));

// Frontend configuration
// Axios
axios.defaults.withCredentials = true;

// Fetch API
fetch('/api/protected', {
    credentials: 'include',
    headers: {
        'Authorization': `Bearer ${token}`
    }
});
```

## OAuth Integration Issues

### Problem: OAuth Callback Errors

**Symptoms:**
- "Invalid redirect URI" errors
- State parameter mismatch
- Authorization code exchange failures

**Solutions:**
```javascript
// Secure OAuth implementation
app.get('/auth/google', (req, res) => {
    const state = crypto.randomBytes(32).toString('hex');
    req.session.oauthState = state;
    
    const authUrl = `https://accounts.google.com/oauth/authorize?${new URLSearchParams({
        client_id: process.env.GOOGLE_CLIENT_ID,
        redirect_uri: process.env.GOOGLE_REDIRECT_URI,
        scope: 'openid email profile',
        response_type: 'code',
        state: state
    })}`;
    
    res.redirect(authUrl);
});

app.get('/auth/google/callback', async (req, res) => {
    const { code, state } = req.query;
    
    // Verify state parameter
    if (state !== req.session.oauthState) {
        return res.status(400).json({ error: 'Invalid state parameter' });
    }
    
    try {
        // Exchange code for tokens
        const tokenResponse = await exchangeCodeForTokens(code);
        const userProfile = await getUserProfile(tokenResponse.access_token);
        
        // Create or update user
        const user = await findOrCreateUser(userProfile);
        
        // Create session or JWT
        req.session.userId = user.id;
        res.redirect('/dashboard');
    } catch (error) {
        console.error('OAuth callback error:', error);
        res.redirect('/login?error=oauth_failed');
    }
});
```

## Frontend Authentication Issues

### Problem: React Authentication State Not Updating

**Symptoms:**
- UI not reflecting authentication state
- Protected routes not working
- User data not available

**Solutions:**
```javascript
// Proper React authentication context
export function AuthProvider({ children }) {
    const [state, dispatch] = useReducer(authReducer, initialState);

    // Check authentication status on mount
    useEffect(() => {
        const token = localStorage.getItem('token');
        if (token) {
            // Verify token is still valid
            verifyToken(token)
                .then(user => {
                    dispatch({ type: 'LOGIN_SUCCESS', payload: { user, token } });
                })
                .catch(() => {
                    localStorage.removeItem('token');
                    dispatch({ type: 'LOGOUT' });
                });
        }
    }, []);

    // Axios interceptor for automatic token refresh
    useEffect(() => {
        const interceptor = axios.interceptors.response.use(
            response => response,
            async error => {
                if (error.response?.status === 401 && state.token) {
                    try {
                        const newToken = await refreshToken();
                        error.config.headers.Authorization = `Bearer ${newToken}`;
                        return axios.request(error.config);
                    } catch (refreshError) {
                        dispatch({ type: 'LOGOUT' });
                        return Promise.reject(refreshError);
                    }
                }
                return Promise.reject(error);
            }
        );

        return () => axios.interceptors.response.eject(interceptor);
    }, [state.token]);

    return (
        <AuthContext.Provider value={{ ...state, login, logout }}>
            {children}
        </AuthContext.Provider>
    );
}
```

### Problem: Vue Router Navigation Guards Not Working

**Symptoms:**
- Protected routes accessible without authentication
- Navigation guards not triggering
- Route protection bypassed

**Solutions:**
```javascript
// Proper Vue Router guards
router.beforeEach(async (to, from, next) => {
    const requiresAuth = to.matched.some(record => record.meta.requiresAuth);
    const requiredRoles = to.meta.roles || [];
    
    if (requiresAuth) {
        const { isAuthenticated, user, checkAuth } = useAuth();
        
        // Ensure authentication state is current
        if (!isAuthenticated.value) {
            await checkAuth();
        }
        
        if (!isAuthenticated.value) {
            next({ name: 'Login', query: { redirect: to.fullPath } });
            return;
        }
        
        // Check role requirements
        if (requiredRoles.length > 0) {
            const userRoles = user.value?.roles || [];
            const hasRole = requiredRoles.some(role => userRoles.includes(role));
            
            if (!hasRole) {
                next({ name: 'Unauthorized' });
                return;
            }
        }
    }
    
    next();
});
```

## Performance Issues

### Problem: Slow Authentication Responses

**Symptoms:**
- Long login times
- Database query timeouts
- High server load

**Solutions:**
```javascript
// Optimize authentication queries
// Add database indexes
db.users.createIndex({ email: 1 }, { unique: true });
db.sessions.createIndex({ sessionId: 1 });
db.sessions.createIndex({ expires: 1 }, { expireAfterSeconds: 0 });

// Use connection pooling
const mongoose = require('mongoose');
mongoose.connect(process.env.MONGODB_URI, {
    maxPoolSize: 10,
    serverSelectionTimeoutMS: 5000,
    socketTimeoutMS: 45000,
});

// Cache user data
const NodeCache = require('node-cache');
const userCache = new NodeCache({ stdTTL: 600 }); // 10 minutes

async function getUserById(userId) {
    const cacheKey = `user:${userId}`;
    let user = userCache.get(cacheKey);
    
    if (!user) {
        user = await User.findById(userId).lean();
        if (user) {
            userCache.set(cacheKey, user);
        }
    }
    
    return user;
}
```

## Security Issues

### Problem: Brute Force Attacks

**Symptoms:**
- Multiple failed login attempts
- High authentication endpoint traffic
- Account lockouts

**Solutions:**
```javascript
// Implement rate limiting and account lockout
const rateLimit = require('express-rate-limit');
const slowDown = require('express-slow-down');

// Rate limiting
const authLimiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 5, // 5 attempts per window
    message: 'Too many login attempts',
    standardHeaders: true,
    legacyHeaders: false,
});

// Progressive delay
const speedLimiter = slowDown({
    windowMs: 15 * 60 * 1000,
    delayAfter: 2,
    delayMs: 500
});

// Account lockout
class AccountLockout {
    constructor() {
        this.attempts = new Map();
    }

    recordFailedAttempt(email) {
        const key = email.toLowerCase();
        const attempts = this.attempts.get(key) || { count: 0, lockedUntil: null };
        
        attempts.count++;
        
        if (attempts.count >= 5) {
            attempts.lockedUntil = Date.now() + (30 * 60 * 1000); // 30 minutes
        }
        
        this.attempts.set(key, attempts);
    }

    isLocked(email) {
        const key = email.toLowerCase();
        const attempts = this.attempts.get(key);
        
        if (!attempts || !attempts.lockedUntil) {
            return false;
        }
        
        if (Date.now() > attempts.lockedUntil) {
            this.attempts.delete(key);
            return false;
        }
        
        return true;
    }

    clearAttempts(email) {
        this.attempts.delete(email.toLowerCase());
    }
}
```

## Debugging Tools

### Authentication Debug Middleware
```javascript
// Debug authentication issues
function debugAuth(req, res, next) {
    console.log('=== Authentication Debug ===');
    console.log('Headers:', req.headers);
    console.log('Session:', req.session);
    console.log('User:', req.user);
    console.log('Cookies:', req.cookies);
    console.log('============================');
    next();
}

// Use in development only
if (process.env.NODE_ENV === 'development') {
    app.use('/api', debugAuth);
}
```

## Integration with Troubleshooting System

When encountering authentication issues:

1. **Create Blocker File**: Use format `YYYY-MM-DD_blocker_auth_[framework].md`
2. **Document Symptoms**: Include error messages, browser console logs, network requests
3. **Record Attempted Solutions**: List all troubleshooting steps tried
4. **Cross-Reference**: Link to relevant sections in this troubleshooting guide
5. **Update Knowledge Base**: Add new patterns to prevention strategies

### Example Blocker File Template
```markdown
# Authentication Blocker - JWT Token Issues

**Date**: 2025-07-10
**Framework**: React
**Impact**: Critical - Users cannot log in

## Problem Description
JWT tokens are being rejected with "invalid signature" error.

## Symptoms
- 401 responses on protected routes
- Console error: "jwt signature verification failed"
- Users redirected to login after successful authentication

## Attempted Solutions
1. Verified JWT secret configuration
2. Checked token format and structure
3. Tested with different browsers

## Current Status
Investigating algorithm mismatch between signing and verification.

## Next Steps
1. Compare JWT configuration between frontend and backend
2. Test with hardcoded secret to isolate issue
3. Review recent changes to authentication middleware

## Related Documentation
- [JWT Implementation Guide](./jwt-implementation.md)
- [Common Patterns](./common-patterns.md#jwt-authentication-patterns)
```

---

*Last Updated: 2025-07-10*
*Framework Support: React, Vue, Angular, Vanilla JS*
