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

## Neon PostgreSQL Integration Best Practices

### Neon-Specific Configuration
```javascript
// Optimized Neon PostgreSQL connection
import { Pool } from 'pg';

const neonPool = new Pool({
  connectionString: process.env.NEON_DATABASE_URL,
  ssl: {
    rejectUnauthorized: false
  },
  // Neon-optimized settings
  max: 20,                      // Neon supports up to 100 concurrent connections
  min: 5,                       // Maintain minimum connections for performance
  idleTimeoutMillis: 30000,     // Close idle connections after 30s
  connectionTimeoutMillis: 2000, // Quick timeout for failed connections
  statement_timeout: 30000,     // 30s query timeout
  query_timeout: 30000,         // 30s query timeout
  application_name: 'myapp_production'
});

// Neon connection health monitoring
neonPool.on('connect', (client) => {
  console.log('New Neon client connected');

  // Set session-level optimizations
  client.query(`
    SET statement_timeout = '30s';
    SET lock_timeout = '10s';
    SET idle_in_transaction_session_timeout = '60s';
  `);
});

neonPool.on('error', (err, client) => {
  console.error('Neon client error:', err);
});
```

### Neon Performance Optimization
```sql
-- Neon-specific performance settings
-- Enable parallel query execution
SET max_parallel_workers_per_gather = 4;
SET max_parallel_workers = 8;

-- Optimize for Neon's storage layer
SET random_page_cost = 1.1;  -- Neon has fast random access
SET seq_page_cost = 1.0;     -- Sequential reads are also fast

-- Connection-level optimizations
SET shared_preload_libraries = 'pg_stat_statements';
SET track_activity_query_size = 2048;
SET log_min_duration_statement = 1000; -- Log slow queries
```

### Neon Branching Integration
```javascript
// Neon database branching for development
class NeonBranchManager {
  constructor(apiKey, projectId) {
    this.apiKey = apiKey;
    this.projectId = projectId;
    this.baseUrl = 'https://console.neon.tech/api/v2';
  }

  async createBranch(branchName, parentBranch = 'main') {
    const response = await fetch(`${this.baseUrl}/projects/${this.projectId}/branches`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.apiKey}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        branch: {
          name: branchName,
          parent_id: parentBranch
        }
      })
    });

    if (!response.ok) {
      throw new Error(`Failed to create branch: ${response.statusText}`);
    }

    return await response.json();
  }

  async getBranchConnectionString(branchId) {
    const response = await fetch(`${this.baseUrl}/projects/${this.projectId}/branches/${branchId}`, {
      headers: {
        'Authorization': `Bearer ${this.apiKey}`
      }
    });

    const branch = await response.json();
    return branch.connection_uris[0].connection_uri;
  }
}

// Usage in development workflow
const branchManager = new NeonBranchManager(
  process.env.NEON_API_KEY,
  process.env.NEON_PROJECT_ID
);

// Create feature branch for development
const featureBranch = await branchManager.createBranch('feature-user-auth');
const featureDbUrl = await branchManager.getBranchConnectionString(featureBranch.branch.id);
```

## SQLite Integration Best Practices

### SQLite Development Configuration
```javascript
// Optimized SQLite setup for development
import Database from 'better-sqlite3';
import path from 'path';
import fs from 'fs';

class SQLiteManager {
  constructor(dbPath = './data/development.sqlite') {
    // Ensure data directory exists
    const dir = path.dirname(dbPath);
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }

    this.db = new Database(dbPath, {
      verbose: process.env.NODE_ENV === 'development' ? console.log : null,
      fileMustExist: false
    });

    this.configureSQLite();
  }

  configureSQLite() {
    // Performance optimizations
    this.db.pragma('journal_mode = WAL');
    this.db.pragma('synchronous = NORMAL');
    this.db.pragma('cache_size = 1000000');
    this.db.pragma('temp_store = memory');
    this.db.pragma('mmap_size = 268435456'); // 256MB

    // Enable foreign keys
    this.db.pragma('foreign_keys = ON');

    // Set busy timeout
    this.db.pragma('busy_timeout = 30000');
  }

  // Transaction wrapper
  transaction(fn) {
    return this.db.transaction(fn);
  }

  // Prepared statement caching
  prepare(sql) {
    if (!this.statements) {
      this.statements = new Map();
    }

    if (!this.statements.has(sql)) {
      this.statements.set(sql, this.db.prepare(sql));
    }

    return this.statements.get(sql);
  }

  close() {
    if (this.statements) {
      this.statements.clear();
    }
    this.db.close();
  }
}
```

### SQLite to PostgreSQL Migration Pattern
```javascript
// Database migration utility for moving from SQLite to PostgreSQL
class DatabaseMigrator {
  constructor(sqliteDb, postgresPool) {
    this.sqlite = sqliteDb;
    this.postgres = postgresPool;
  }

  async migrateTables() {
    const tables = ['users', 'user_profiles', 'sessions'];

    for (const table of tables) {
      console.log(`Migrating table: ${table}`);
      await this.migrateTable(table);
    }
  }

  async migrateTable(tableName) {
    // Get SQLite data
    const data = this.sqlite.prepare(`SELECT * FROM ${tableName}`).all();

    if (data.length === 0) {
      console.log(`No data to migrate for ${tableName}`);
      return;
    }

    // Prepare PostgreSQL insert
    const columns = Object.keys(data[0]);
    const placeholders = columns.map((_, i) => `$${i + 1}`).join(', ');
    const insertSQL = `
      INSERT INTO ${tableName} (${columns.join(', ')})
      VALUES (${placeholders})
      ON CONFLICT DO NOTHING
    `;

    const client = await this.postgres.connect();
    try {
      await client.query('BEGIN');

      for (const row of data) {
        const values = columns.map(col => row[col]);
        await client.query(insertSQL, values);
      }

      await client.query('COMMIT');
      console.log(`Migrated ${data.length} rows for ${tableName}`);
    } catch (error) {
      await client.query('ROLLBACK');
      console.error(`Migration failed for ${tableName}:`, error);
      throw error;
    } finally {
      client.release();
    }
  }
}
```

## Database Technology Decision Matrix

### When to Use Neon PostgreSQL
**✅ Recommended for:**
- Production applications requiring scalability
- Applications with complex queries and relationships
- Multi-user applications with concurrent access
- Applications requiring ACID compliance
- Cloud-native applications
- Applications with advanced data types (JSON, arrays, etc.)
- Applications requiring read replicas or high availability

**Configuration Example:**
```javascript
// Production Neon configuration
const productionConfig = {
  connectionString: process.env.NEON_DATABASE_URL,
  ssl: { rejectUnauthorized: false },
  max: 20,
  min: 5,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000
};
```

### When to Use SQLite
**✅ Recommended for:**
- Local development and testing
- Prototyping and MVP development
- Single-user applications
- Desktop applications
- Applications with simple data requirements
- Embedded applications
- Applications requiring zero-configuration setup

**Configuration Example:**
```javascript
// Development SQLite configuration
const developmentConfig = {
  filename: './data/development.sqlite',
  options: {
    verbose: console.log,
    fileMustExist: false
  },
  pragmas: {
    journal_mode: 'WAL',
    synchronous: 'NORMAL',
    foreign_keys: 'ON'
  }
};
```

### Migration Strategy: SQLite → Neon PostgreSQL
```javascript
// Environment-based database selection
function getDatabaseConfig() {
  const environment = process.env.NODE_ENV || 'development';

  switch (environment) {
    case 'development':
    case 'test':
      return {
        type: 'sqlite',
        config: {
          filename: `./data/${environment}.sqlite`,
          options: { verbose: console.log }
        }
      };

    case 'staging':
    case 'production':
      return {
        type: 'postgresql',
        config: {
          connectionString: process.env.NEON_DATABASE_URL,
          ssl: { rejectUnauthorized: false }
        }
      };

    default:
      throw new Error(`Unknown environment: ${environment}`);
  }
}
```

## Methodology-Specific Guidelines

### MVP/Rapid Implementation (2-4 weeks)
- **Database Choice**: SQLite for development, Neon PostgreSQL for production
- **ORM**: Prisma with basic configuration
- **Indexes**: Primary keys and foreign keys only
- **Backup**: Neon automatic backups
- **Monitoring**: Basic application logging

### Balanced/Standard Implementation (4-8 weeks)
- **Database Choice**: Neon PostgreSQL with branching for feature development
- **ORM**: Prisma with optimized connection pooling
- **Indexes**: Strategic indexing based on query patterns
- **Backup**: Automated backups with point-in-time recovery
- **Monitoring**: Query performance monitoring and alerting

### Comprehensive/Enterprise Implementation (8-12 weeks)
- **Database Choice**: Neon PostgreSQL with read replicas
- **ORM**: Advanced Prisma configuration with custom middleware
- **Indexes**: Comprehensive indexing strategy with performance analysis
- **Backup**: Multi-region backup strategy with disaster recovery
- **Monitoring**: Full observability stack with custom metrics

---

*Last Updated: 2025-07-11*
*Database Support: Neon PostgreSQL, SQLite, PostgreSQL, MySQL, MongoDB, Redis*
*Integration: Neon Branching, SQLite Development, Migration Strategies*
