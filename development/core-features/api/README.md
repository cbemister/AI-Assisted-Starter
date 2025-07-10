# API Layer Documentation

Comprehensive guidelines for designing, implementing, and maintaining robust APIs including RESTful services, GraphQL implementations, and API management strategies.

## Overview

This directory provides standardized patterns for building scalable, maintainable APIs with proper error handling, authentication, rate limiting, caching, and documentation. Supports both REST and GraphQL architectures across different frameworks.

## Quick Reference

### API Architectures
- **REST**: Resource-based HTTP APIs with standard methods
- **GraphQL**: Query language for flexible data fetching
- **RPC**: Remote procedure call patterns
- **WebSocket**: Real-time bidirectional communication

### Key Features
- **Authentication & Authorization**: Secure API access
- **Rate Limiting**: Prevent abuse and ensure fair usage
- **Caching**: Improve performance and reduce load
- **Error Handling**: Consistent error responses
- **Documentation**: OpenAPI/Swagger specifications

## Methodology Approaches

### MVP/Rapid (2-4 weeks)
- Basic REST endpoints with CRUD operations
- Simple authentication (API keys or JWT)
- Basic error handling and validation
- Essential rate limiting

### Balanced/Standard (4-8 weeks)
- Comprehensive REST API with advanced features
- GraphQL implementation for complex queries
- Advanced authentication and authorization
- Caching strategies and performance optimization

### Comprehensive/Enterprise (8-12 weeks)
- Multi-version API support
- Advanced GraphQL with subscriptions
- Comprehensive monitoring and analytics
- Enterprise-grade security and compliance

## File Structure

```
api/
├── README.md                    # This overview file
├── best-practices.md           # API design and implementation guidelines
├── common-patterns.md          # Reusable API patterns and code templates
├── troubleshooting.md          # Common API issues and solutions
├── rest-design.md              # RESTful API design principles
├── graphql-implementation.md   # GraphQL setup and patterns
├── error-handling.md           # API error handling standards
├── rate-limiting.md            # Rate limiting strategies
├── caching-strategies.md       # API caching implementation
├── documentation-standards.md  # OpenAPI/Swagger documentation
├── security-guidelines.md      # API security best practices
└── framework-guides/
    ├── express-api.md          # Express.js API implementation
    ├── fastify-api.md          # Fastify API patterns
    ├── nextjs-api.md           # Next.js API routes
    └── graphql-servers.md      # GraphQL server implementations
```

## REST API Design Principles

### Resource-Based URLs
```
GET    /api/v1/users              # Get all users
GET    /api/v1/users/{id}         # Get specific user
POST   /api/v1/users              # Create new user
PUT    /api/v1/users/{id}         # Update user (full)
PATCH  /api/v1/users/{id}         # Update user (partial)
DELETE /api/v1/users/{id}         # Delete user

# Nested resources
GET    /api/v1/users/{id}/orders  # Get user's orders
POST   /api/v1/users/{id}/orders  # Create order for user
```

### HTTP Status Codes
- **200 OK**: Successful GET, PUT, PATCH
- **201 Created**: Successful POST
- **204 No Content**: Successful DELETE
- **400 Bad Request**: Invalid request data
- **401 Unauthorized**: Authentication required
- **403 Forbidden**: Insufficient permissions
- **404 Not Found**: Resource not found
- **429 Too Many Requests**: Rate limit exceeded
- **500 Internal Server Error**: Server error

## GraphQL Implementation

### Schema Design
```graphql
type User {
  id: ID!
  email: String!
  profile: UserProfile
  orders: [Order!]!
  createdAt: DateTime!
}

type UserProfile {
  firstName: String
  lastName: String
  bio: String
  avatarUrl: String
}

type Order {
  id: ID!
  user: User!
  items: [OrderItem!]!
  totalAmount: Float!
  status: OrderStatus!
  createdAt: DateTime!
}

enum OrderStatus {
  PENDING
  PROCESSING
  SHIPPED
  DELIVERED
  CANCELLED
}

type Query {
  user(id: ID!): User
  users(first: Int, after: String): UserConnection!
  orders(status: OrderStatus, first: Int): [Order!]!
}

type Mutation {
  createUser(input: CreateUserInput!): User!
  updateUser(id: ID!, input: UpdateUserInput!): User!
  deleteUser(id: ID!): Boolean!
}

type Subscription {
  orderStatusChanged(userId: ID!): Order!
  userUpdated(id: ID!): User!
}
```

## Authentication & Authorization

### API Key Authentication
```javascript
// Simple API key middleware
function apiKeyAuth(req, res, next) {
  const apiKey = req.headers['x-api-key'];
  
  if (!apiKey) {
    return res.status(401).json({ error: 'API key required' });
  }
  
  // Validate API key
  if (!isValidApiKey(apiKey)) {
    return res.status(401).json({ error: 'Invalid API key' });
  }
  
  req.apiKey = apiKey;
  next();
}
```

### JWT Authentication
```javascript
// JWT middleware for API routes
function jwtAuth(req, res, next) {
  const token = req.headers.authorization?.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ error: 'Access token required' });
  }
  
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid token' });
  }
}
```

## Rate Limiting

### Basic Rate Limiting
```javascript
const rateLimit = require('express-rate-limit');

// General API rate limiting
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // 100 requests per window
  message: {
    error: 'Too many requests',
    retryAfter: '15 minutes'
  },
  standardHeaders: true,
  legacyHeaders: false,
});

// Stricter limits for authentication endpoints
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,
  message: {
    error: 'Too many authentication attempts',
    retryAfter: '15 minutes'
  }
});

app.use('/api', apiLimiter);
app.use('/api/auth', authLimiter);
```

## Caching Strategies

### Response Caching
```javascript
const NodeCache = require('node-cache');
const cache = new NodeCache({ stdTTL: 600 }); // 10 minutes default

// Cache middleware
function cacheMiddleware(duration = 600) {
  return (req, res, next) => {
    const key = req.originalUrl;
    const cached = cache.get(key);
    
    if (cached) {
      return res.json(cached);
    }
    
    // Override res.json to cache response
    const originalJson = res.json;
    res.json = function(data) {
      cache.set(key, data, duration);
      originalJson.call(this, data);
    };
    
    next();
  };
}

// Usage
app.get('/api/users', cacheMiddleware(300), getUsersHandler);
```

## Error Handling

### Standardized Error Responses
```javascript
class APIError extends Error {
  constructor(message, statusCode = 500, code = 'INTERNAL_ERROR') {
    super(message);
    this.statusCode = statusCode;
    this.code = code;
    this.name = 'APIError';
  }
}

// Error handling middleware
function errorHandler(error, req, res, next) {
  let statusCode = 500;
  let code = 'INTERNAL_ERROR';
  let message = 'Internal server error';
  
  if (error instanceof APIError) {
    statusCode = error.statusCode;
    code = error.code;
    message = error.message;
  } else if (error.name === 'ValidationError') {
    statusCode = 400;
    code = 'VALIDATION_ERROR';
    message = error.message;
  }
  
  // Log error for monitoring
  console.error('API Error:', {
    error: error.message,
    stack: error.stack,
    url: req.url,
    method: req.method,
    ip: req.ip,
    userAgent: req.get('User-Agent')
  });
  
  res.status(statusCode).json({
    error: {
      message,
      code,
      timestamp: new Date().toISOString(),
      path: req.path
    }
  });
}
```

## API Documentation

### OpenAPI/Swagger Configuration
```javascript
const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'My API',
      version: '1.0.0',
      description: 'A comprehensive API for my application',
    },
    servers: [
      {
        url: 'http://localhost:3000/api/v1',
        description: 'Development server',
      },
      {
        url: 'https://api.myapp.com/v1',
        description: 'Production server',
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
        apiKey: {
          type: 'apiKey',
          in: 'header',
          name: 'X-API-Key',
        },
      },
    },
  },
  apis: ['./routes/*.js'], // Path to the API docs
};

const specs = swaggerJsdoc(options);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(specs));
```

## Performance Optimization

### Response Compression
```javascript
const compression = require('compression');

// Enable gzip compression
app.use(compression({
  filter: (req, res) => {
    if (req.headers['x-no-compression']) {
      return false;
    }
    return compression.filter(req, res);
  },
  threshold: 1024, // Only compress responses > 1KB
}));
```

### Database Query Optimization
```javascript
// Efficient data fetching with pagination
async function getUsers(req, res) {
  const { page = 1, limit = 10, search } = req.query;
  const offset = (page - 1) * limit;
  
  const where = search ? {
    OR: [
      { email: { contains: search, mode: 'insensitive' } },
      { profile: { firstName: { contains: search, mode: 'insensitive' } } },
      { profile: { lastName: { contains: search, mode: 'insensitive' } } }
    ]
  } : {};
  
  const [users, total] = await Promise.all([
    prisma.user.findMany({
      where,
      skip: offset,
      take: parseInt(limit),
      include: {
        profile: {
          select: {
            firstName: true,
            lastName: true,
            avatarUrl: true
          }
        }
      },
      orderBy: { createdAt: 'desc' }
    }),
    prisma.user.count({ where })
  ]);
  
  res.json({
    data: users,
    pagination: {
      page: parseInt(page),
      limit: parseInt(limit),
      total,
      pages: Math.ceil(total / limit)
    }
  });
}
```

## Testing Strategies

### API Testing with Jest
```javascript
// API endpoint testing
describe('Users API', () => {
  beforeEach(async () => {
    await setupTestDatabase();
  });
  
  afterEach(async () => {
    await cleanupTestDatabase();
  });
  
  describe('GET /api/users', () => {
    it('should return paginated users', async () => {
      const response = await request(app)
        .get('/api/users?page=1&limit=5')
        .expect(200);
      
      expect(response.body).toHaveProperty('data');
      expect(response.body).toHaveProperty('pagination');
      expect(response.body.data).toHaveLength(5);
    });
    
    it('should require authentication', async () => {
      await request(app)
        .get('/api/users')
        .expect(401);
    });
  });
  
  describe('POST /api/users', () => {
    it('should create a new user', async () => {
      const userData = {
        email: 'test@example.com',
        password: 'securePassword123'
      };
      
      const response = await request(app)
        .post('/api/users')
        .send(userData)
        .expect(201);
      
      expect(response.body).toHaveProperty('id');
      expect(response.body.email).toBe(userData.email);
    });
  });
});
```

## Related Documentation

- [Authentication](../authentication/README.md) - API authentication patterns
- [Database Layer](../database/README.md) - Database integration
- [State Management](../state-management/README.md) - API state management
- [Error Handling](../error-handling/README.md) - Error handling strategies

## Troubleshooting Integration

When encountering API issues:
1. Check [troubleshooting.md](./troubleshooting.md) for common solutions
2. Create blocker files in `docs/development/troubleshooting/active-blockers/`
3. Use format: `YYYY-MM-DD_blocker_api_[framework].md`
4. Reference framework-specific guides for detailed implementation help

---

*Last Updated: 2025-07-10*
*API Standards: REST, GraphQL, OpenAPI 3.0*
*Framework Support: Express, Fastify, Next.js*
