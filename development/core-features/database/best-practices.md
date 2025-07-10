# Database Best Practices

Comprehensive guidelines for database design, optimization, and maintenance across different database systems and development methodologies.

## Schema Design Best Practices

### Normalization Guidelines
```sql
-- Good: Normalized user and profile tables
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    bio TEXT,
    avatar_url VARCHAR(500),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for foreign key relationships
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);
```

### Data Type Selection
```sql
-- Use appropriate data types for efficiency
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,           -- Variable length for names
    description TEXT,                     -- TEXT for long content
    price DECIMAL(10,2) NOT NULL,        -- DECIMAL for currency
    stock_quantity INTEGER DEFAULT 0,     -- INTEGER for counts
    is_active BOOLEAN DEFAULT true,       -- BOOLEAN for flags
    created_at TIMESTAMP WITH TIME ZONE,  -- Include timezone
    metadata JSONB                        -- JSONB for flexible data
);

-- Indexes for common queries
CREATE INDEX idx_products_active ON products(is_active);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_metadata ON products USING GIN(metadata);
```

### Constraint Management
```sql
-- Comprehensive constraint examples
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')),
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    shipping_address JSONB NOT NULL,
    
    -- Composite constraints
    CONSTRAINT valid_order_amount CHECK (total_amount > 0 OR status = 'cancelled'),
    CONSTRAINT future_order_date CHECK (order_date <= CURRENT_TIMESTAMP + INTERVAL '1 hour')
);

-- Unique constraints for business rules
CREATE UNIQUE INDEX idx_orders_user_pending ON orders(user_id) 
WHERE status = 'pending';
```

## ORM/ODM Configuration Best Practices

### Prisma Configuration
```javascript
// prisma/schema.prisma - Comprehensive configuration
generator client {
  provider = "prisma-client-js"
  previewFeatures = ["fullTextSearch", "metrics"]
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        Int      @id @default(autoincrement())
  email     String   @unique @db.VarChar(255)
  password  String   @db.VarChar(255)
  createdAt DateTime @default(now()) @map("created_at")
  updatedAt DateTime @updatedAt @map("updated_at")
  
  profile   UserProfile?
  orders    Order[]
  
  @@map("users")
  @@index([email])
}

model UserProfile {
  id        Int      @id @default(autoincrement())
  userId    Int      @unique @map("user_id")
  firstName String?  @map("first_name") @db.VarChar(100)
  lastName  String?  @map("last_name") @db.VarChar(100)
  bio       String?  @db.Text
  avatarUrl String?  @map("avatar_url") @db.VarChar(500)
  updatedAt DateTime @updatedAt @map("updated_at")
  
  user      User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@map("user_profiles")
}
```

### Connection Pool Configuration
```javascript
// Database connection with optimized pooling
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient({
  datasources: {
    db: {
      url: process.env.DATABASE_URL,
    },
  },
  log: process.env.NODE_ENV === 'development' ? ['query', 'info', 'warn', 'error'] : ['error'],
});

// Connection pool configuration for production
const connectionString = new URL(process.env.DATABASE_URL);
connectionString.searchParams.set('connection_limit', '10');
connectionString.searchParams.set('pool_timeout', '20');
connectionString.searchParams.set('socket_timeout', '60');

// Graceful shutdown
process.on('beforeExit', async () => {
  await prisma.$disconnect();
});
```

### TypeORM Configuration
```javascript
// typeorm.config.js - Production-ready configuration
module.exports = {
  type: 'postgres',
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT),
  username: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  
  // Connection pool settings
  extra: {
    max: 20,                    // Maximum connections
    min: 5,                     // Minimum connections
    acquire: 30000,             // Maximum time to get connection
    idle: 10000,                // Maximum idle time
    evict: 60000,               // Eviction interval
    handleDisconnects: true,    // Reconnect on disconnect
  },
  
  // SSL configuration for production
  ssl: process.env.NODE_ENV === 'production' ? {
    rejectUnauthorized: false
  } : false,
  
  // Entity and migration paths
  entities: ['src/entities/**/*.ts'],
  migrations: ['src/migrations/**/*.ts'],
  subscribers: ['src/subscribers/**/*.ts'],
  
  // Development settings
  synchronize: process.env.NODE_ENV === 'development',
  logging: process.env.NODE_ENV === 'development' ? 'all' : ['error'],
  
  // Migration settings
  migrationsRun: process.env.NODE_ENV === 'production',
  migrationsTableName: 'migrations_history',
};
```

## Query Optimization Best Practices

### Efficient Query Patterns
```javascript
// Prisma query optimization
class UserService {
  // Good: Use select to limit fields
  async getUserProfile(userId) {
    return await prisma.user.findUnique({
      where: { id: userId },
      select: {
        id: true,
        email: true,
        profile: {
          select: {
            firstName: true,
            lastName: true,
            bio: true,
            avatarUrl: true
          }
        }
      }
    });
  }

  // Good: Use include with specific relations
  async getUserWithOrders(userId) {
    return await prisma.user.findUnique({
      where: { id: userId },
      include: {
        orders: {
          where: { status: { not: 'cancelled' } },
          orderBy: { createdAt: 'desc' },
          take: 10,
          select: {
            id: true,
            totalAmount: true,
            status: true,
            createdAt: true
          }
        }
      }
    });
  }

  // Good: Batch operations for multiple records
  async createMultipleUsers(userData) {
    return await prisma.user.createMany({
      data: userData,
      skipDuplicates: true
    });
  }

  // Good: Use transactions for related operations
  async createUserWithProfile(userData, profileData) {
    return await prisma.$transaction(async (tx) => {
      const user = await tx.user.create({
        data: userData
      });

      const profile = await tx.userProfile.create({
        data: {
          ...profileData,
          userId: user.id
        }
      });

      return { user, profile };
    });
  }
}
```

### Index Strategy
```sql
-- Strategic index placement
-- Single column indexes for frequent WHERE clauses
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);

-- Composite indexes for multi-column queries
CREATE INDEX idx_orders_user_status ON orders(user_id, status);
CREATE INDEX idx_orders_status_date ON orders(status, created_at);

-- Partial indexes for specific conditions
CREATE INDEX idx_orders_active ON orders(user_id, created_at) 
WHERE status IN ('pending', 'processing');

-- Functional indexes for computed values
CREATE INDEX idx_users_email_lower ON users(LOWER(email));

-- JSONB indexes for document queries
CREATE INDEX idx_products_metadata_gin ON products USING GIN(metadata);
CREATE INDEX idx_products_category ON products((metadata->>'category'));
```

## Performance Monitoring and Optimization

### Query Performance Analysis
```sql
-- PostgreSQL query analysis
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON) 
SELECT u.email, p.first_name, p.last_name
FROM users u
JOIN user_profiles p ON u.id = p.user_id
WHERE u.created_at > '2024-01-01'
ORDER BY u.created_at DESC
LIMIT 100;

-- Identify slow queries
SELECT query, mean_time, calls, total_time
FROM pg_stat_statements
WHERE mean_time > 100
ORDER BY mean_time DESC
LIMIT 10;
```

### Connection Pool Monitoring
```javascript
// Monitor connection pool health
class DatabaseMonitor {
  static async checkConnectionHealth() {
    try {
      const result = await prisma.$queryRaw`SELECT 1 as health_check`;
      return { status: 'healthy', timestamp: new Date() };
    } catch (error) {
      console.error('Database health check failed:', error);
      return { status: 'unhealthy', error: error.message, timestamp: new Date() };
    }
  }

  static async getConnectionStats() {
    const stats = await prisma.$queryRaw`
      SELECT 
        count(*) as total_connections,
        count(*) FILTER (WHERE state = 'active') as active_connections,
        count(*) FILTER (WHERE state = 'idle') as idle_connections
      FROM pg_stat_activity 
      WHERE datname = current_database()
    `;
    
    return stats[0];
  }

  static startMonitoring() {
    setInterval(async () => {
      const health = await this.checkConnectionHealth();
      const stats = await this.getConnectionStats();
      
      console.log('Database Health:', health);
      console.log('Connection Stats:', stats);
      
      // Alert if connections are high
      if (stats.total_connections > 15) {
        console.warn('High connection count detected:', stats.total_connections);
      }
    }, 30000); // Check every 30 seconds
  }
}
```

## Security Best Practices

### Access Control and Permissions
```sql
-- Create application-specific database users
CREATE USER app_read WITH PASSWORD 'secure_password';
CREATE USER app_write WITH PASSWORD 'secure_password';
CREATE USER app_admin WITH PASSWORD 'secure_password';

-- Grant minimal necessary permissions
GRANT CONNECT ON DATABASE myapp TO app_read;
GRANT USAGE ON SCHEMA public TO app_read;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_read;

GRANT CONNECT ON DATABASE myapp TO app_write;
GRANT USAGE ON SCHEMA public TO app_write;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_write;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO app_write;

-- Admin user for migrations
GRANT ALL PRIVILEGES ON DATABASE myapp TO app_admin;
```

### Data Encryption and Protection
```javascript
// Encrypt sensitive data before storage
const crypto = require('crypto');

class DataEncryption {
  constructor() {
    this.algorithm = 'aes-256-gcm';
    this.key = Buffer.from(process.env.ENCRYPTION_KEY, 'hex');
  }

  encrypt(text) {
    const iv = crypto.randomBytes(16);
    const cipher = crypto.createCipher(this.algorithm, this.key);
    cipher.setAAD(Buffer.from('additional-data'));
    
    let encrypted = cipher.update(text, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    
    const authTag = cipher.getAuthTag();
    
    return {
      encrypted,
      iv: iv.toString('hex'),
      authTag: authTag.toString('hex')
    };
  }

  decrypt(encryptedData) {
    const decipher = crypto.createDecipher(this.algorithm, this.key);
    decipher.setAAD(Buffer.from('additional-data'));
    decipher.setAuthTag(Buffer.from(encryptedData.authTag, 'hex'));
    
    let decrypted = decipher.update(encryptedData.encrypted, 'hex', 'utf8');
    decrypted += decipher.final('utf8');
    
    return decrypted;
  }
}

// Use encryption for sensitive fields
class UserService {
  constructor() {
    this.encryption = new DataEncryption();
  }

  async createUser(userData) {
    // Encrypt sensitive data
    if (userData.ssn) {
      userData.ssn = this.encryption.encrypt(userData.ssn);
    }

    return await prisma.user.create({ data: userData });
  }
}
```

## Backup and Recovery Strategies

### Automated Backup Configuration
```bash
#!/bin/bash
# backup-database.sh - Automated backup script

DB_NAME="myapp"
DB_USER="backup_user"
BACKUP_DIR="/backups/database"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_$DATE.sql"

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Create database backup
pg_dump -h localhost -U $DB_USER -d $DB_NAME \
  --verbose --clean --no-owner --no-privileges \
  --format=custom > $BACKUP_FILE

# Compress backup
gzip $BACKUP_FILE

# Remove backups older than 30 days
find $BACKUP_DIR -name "*.sql.gz" -mtime +30 -delete

# Upload to cloud storage (optional)
aws s3 cp $BACKUP_FILE.gz s3://my-backup-bucket/database/

echo "Backup completed: $BACKUP_FILE.gz"
```

### Point-in-Time Recovery Setup
```sql
-- Enable WAL archiving for point-in-time recovery
-- postgresql.conf settings:
-- wal_level = replica
-- archive_mode = on
-- archive_command = 'cp %p /archive/%f'
-- max_wal_senders = 3
-- wal_keep_segments = 32

-- Create base backup
SELECT pg_start_backup('base_backup');
-- Copy data directory
SELECT pg_stop_backup();
```

## Methodology-Specific Guidelines

### MVP/Rapid Implementation
- Use SQLite for development, PostgreSQL for production
- Basic ORM configuration with default settings
- Essential indexes on primary and foreign keys
- Simple backup strategy (daily dumps)
- Basic monitoring with application logs

### Balanced/Standard Implementation
- Normalized database design with performance considerations
- Optimized ORM configuration with connection pooling
- Strategic indexing based on query patterns
- Automated backup and recovery procedures
- Performance monitoring and alerting

### Comprehensive/Enterprise Implementation
- Multi-database architecture with read replicas
- Advanced query optimization and caching
- Comprehensive monitoring and alerting
- High availability and disaster recovery
- Security compliance and audit logging

---

*Last Updated: 2025-07-10*
*Database Support: PostgreSQL, MySQL, MongoDB, Redis, SQLite*
