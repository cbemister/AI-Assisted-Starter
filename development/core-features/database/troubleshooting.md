# Database Troubleshooting Guide

Common database issues, diagnostic procedures, and resolution strategies for Neon PostgreSQL, SQLite, and ORM-related problems.

## Connection Issues

### Neon PostgreSQL Connection Problems

#### Issue: Connection Timeout or Refused
```bash
Error: connect ETIMEDOUT
Error: connect ECONNREFUSED
```

**Diagnosis:**
```javascript
// Test connection with detailed logging
const { Pool } = require('pg');

async function testNeonConnection() {
  const pool = new Pool({
    connectionString: process.env.NEON_DATABASE_URL,
    ssl: { rejectUnauthorized: false },
    connectionTimeoutMillis: 5000,
  });

  try {
    const client = await pool.connect();
    console.log('✅ Neon connection successful');
    
    const result = await client.query('SELECT NOW()');
    console.log('✅ Query execution successful:', result.rows[0]);
    
    client.release();
  } catch (error) {
    console.error('❌ Neon connection failed:', error.message);
    console.error('Connection string format:', process.env.NEON_DATABASE_URL?.replace(/:[^:@]*@/, ':***@'));
  } finally {
    await pool.end();
  }
}
```

**Solutions:**
1. **Check Connection String Format:**
   ```bash
   # Correct Neon format
   NEON_DATABASE_URL="postgresql://username:password@ep-xxx.us-east-1.aws.neon.tech/dbname?sslmode=require"
   ```

2. **Verify SSL Configuration:**
   ```javascript
   const pool = new Pool({
     connectionString: process.env.NEON_DATABASE_URL,
     ssl: {
       rejectUnauthorized: false,
       ca: process.env.NEON_CA_CERT // If using custom CA
     }
   });
   ```

3. **Check Network and Firewall:**
   ```bash
   # Test connectivity
   telnet ep-xxx.us-east-1.aws.neon.tech 5432
   ```

#### Issue: SSL Certificate Verification Failed
```bash
Error: self signed certificate in certificate chain
```

**Solution:**
```javascript
// Disable SSL verification for development (not recommended for production)
const pool = new Pool({
  connectionString: process.env.NEON_DATABASE_URL,
  ssl: process.env.NODE_ENV === 'production' 
    ? { rejectUnauthorized: true }
    : { rejectUnauthorized: false }
});
```

### SQLite Connection Problems

#### Issue: Database Locked
```bash
Error: SQLITE_BUSY: database is locked
```

**Diagnosis:**
```javascript
// Check for long-running transactions
const Database = require('better-sqlite3');

function diagnoseSQLiteLock(dbPath) {
  try {
    const db = new Database(dbPath, { readonly: true });
    
    // Check WAL mode
    const walMode = db.pragma('journal_mode');
    console.log('Journal mode:', walMode);
    
    // Check for active connections
    const busyTimeout = db.pragma('busy_timeout');
    console.log('Busy timeout:', busyTimeout);
    
    db.close();
  } catch (error) {
    console.error('SQLite diagnosis failed:', error.message);
  }
}
```

**Solutions:**
1. **Enable WAL Mode:**
   ```javascript
   const db = new Database('database.sqlite');
   db.pragma('journal_mode = WAL');
   db.pragma('busy_timeout = 30000'); // 30 second timeout
   ```

2. **Proper Connection Management:**
   ```javascript
   class SQLiteManager {
     constructor(dbPath) {
       this.db = new Database(dbPath);
       this.db.pragma('journal_mode = WAL');
       
       // Ensure proper cleanup
       process.on('exit', () => this.close());
       process.on('SIGINT', () => this.close());
     }
     
     close() {
       if (this.db) {
         this.db.close();
         this.db = null;
       }
     }
   }
   ```

## Query Performance Issues

### Slow Query Diagnosis

#### PostgreSQL Query Analysis
```sql
-- Enable query logging
SET log_statement = 'all';
SET log_min_duration_statement = 1000; -- Log queries > 1 second

-- Analyze specific query
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON) 
SELECT u.email, p.first_name 
FROM users u 
JOIN user_profiles p ON u.id = p.user_id 
WHERE u.is_active = true;

-- Check for missing indexes
SELECT schemaname, tablename, attname, n_distinct, correlation
FROM pg_stats
WHERE tablename IN ('users', 'user_profiles')
ORDER BY tablename, attname;
```

#### SQLite Query Analysis
```sql
-- Enable query plan output
.eqp on

-- Analyze query performance
EXPLAIN QUERY PLAN 
SELECT u.email, p.first_name 
FROM users u 
JOIN user_profiles p ON u.id = p.user_id 
WHERE u.is_active = 1;

-- Check index usage
.schema users
PRAGMA index_list('users');
PRAGMA index_info('idx_users_email');
```

### Common Performance Solutions

#### Missing Index Resolution
```sql
-- Add missing indexes based on query patterns
CREATE INDEX idx_users_active_email ON users(is_active, email);
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX idx_sessions_token_expires ON sessions(token, expires_at);

-- For JSON/JSONB queries (PostgreSQL)
CREATE INDEX idx_users_metadata_gin ON users USING GIN(metadata);

-- For SQLite JSON queries
CREATE INDEX idx_users_metadata_role ON users(json_extract(metadata, '$.role'));
```

## Migration Issues

### Migration Failures

#### Issue: Migration Rollback Required
```bash
Error: Migration failed at step 3/5
```

**Diagnosis Script:**
```javascript
// Check migration status
async function checkMigrationStatus(db) {
  try {
    const result = await db.query(`
      SELECT version, applied_at, success 
      FROM schema_migrations 
      ORDER BY version DESC 
      LIMIT 10
    `);
    
    console.log('Recent migrations:', result.rows);
    
    // Check for failed migrations
    const failed = result.rows.filter(m => !m.success);
    if (failed.length > 0) {
      console.error('Failed migrations found:', failed);
    }
  } catch (error) {
    console.error('Migration status check failed:', error.message);
  }
}
```

**Recovery Steps:**
1. **Manual Rollback:**
   ```sql
   -- Rollback specific migration
   BEGIN;
   -- Reverse migration changes manually
   DELETE FROM schema_migrations WHERE version = '20240101_add_user_roles';
   COMMIT;
   ```

2. **Prisma Migration Reset:**
   ```bash
   # Reset and regenerate migrations
   npx prisma migrate reset
   npx prisma db push
   npx prisma generate
   ```

### Data Migration Issues

#### Issue: Data Type Conversion Errors
```bash
Error: invalid input syntax for type integer: "string_value"
```

**Solution Pattern:**
```sql
-- Safe data type migration
ALTER TABLE users ADD COLUMN new_age INTEGER;

UPDATE users 
SET new_age = CASE 
  WHEN age ~ '^[0-9]+$' THEN CAST(age AS INTEGER)
  ELSE NULL 
END;

-- Verify conversion
SELECT COUNT(*) as total, 
       COUNT(new_age) as converted,
       COUNT(*) - COUNT(new_age) as failed
FROM users;

-- After verification, drop old column
ALTER TABLE users DROP COLUMN age;
ALTER TABLE users RENAME COLUMN new_age TO age;
```

## ORM-Specific Issues

### Prisma Troubleshooting

#### Issue: Schema Drift Detection
```bash
Error: Schema drift detected
```

**Diagnosis:**
```bash
# Check current database state
npx prisma db pull
npx prisma format

# Compare with current schema
npx prisma migrate diff \
  --from-schema-datamodel prisma/schema.prisma \
  --to-schema-datasource prisma/schema.prisma
```

**Resolution:**
```bash
# Generate migration for drift
npx prisma migrate dev --name fix_schema_drift

# Or reset if safe
npx prisma migrate reset
```

#### Issue: Client Generation Errors
```bash
Error: Prisma Client could not be generated
```

**Solutions:**
```bash
# Clear generated client
rm -rf node_modules/.prisma
rm -rf node_modules/@prisma/client

# Regenerate
npm install
npx prisma generate
```

## Environment-Specific Issues

### Development vs Production Differences

#### Issue: Works in Development, Fails in Production
**Common Causes:**
1. **Environment Variables:**
   ```javascript
   // Validate environment configuration
   function validateDatabaseConfig() {
     const required = ['DATABASE_URL'];
     const missing = required.filter(key => !process.env[key]);
     
     if (missing.length > 0) {
       throw new Error(`Missing environment variables: ${missing.join(', ')}`);
     }
     
     // Validate URL format
     try {
       new URL(process.env.DATABASE_URL);
     } catch (error) {
       throw new Error('Invalid DATABASE_URL format');
     }
   }
   ```

2. **SSL Configuration:**
   ```javascript
   // Environment-specific SSL config
   const sslConfig = process.env.NODE_ENV === 'production'
     ? { rejectUnauthorized: true }
     : { rejectUnauthorized: false };
   ```

3. **Connection Limits:**
   ```javascript
   // Adjust pool size for environment
   const poolConfig = {
     max: process.env.NODE_ENV === 'production' ? 20 : 5,
     min: process.env.NODE_ENV === 'production' ? 5 : 1,
   };
   ```

## Monitoring and Alerting

### Health Check Implementation
```javascript
// Database health monitoring
class DatabaseHealthMonitor {
  static async performHealthCheck() {
    const checks = {
      connection: false,
      queryPerformance: false,
      diskSpace: false,
      connectionPool: false
    };

    try {
      // Test basic connectivity
      const start = Date.now();
      await db.query('SELECT 1');
      const queryTime = Date.now() - start;
      
      checks.connection = true;
      checks.queryPerformance = queryTime < 1000; // < 1 second
      
      // Check connection pool
      const poolStats = await this.getPoolStats();
      checks.connectionPool = poolStats.active < poolStats.max * 0.8;
      
      return {
        healthy: Object.values(checks).every(Boolean),
        checks,
        timestamp: new Date()
      };
    } catch (error) {
      return {
        healthy: false,
        checks,
        error: error.message,
        timestamp: new Date()
      };
    }
  }
}
```

## Emergency Procedures

### Database Recovery Checklist
1. **Immediate Assessment:**
   - [ ] Check database connectivity
   - [ ] Verify recent backups
   - [ ] Assess data integrity
   - [ ] Check error logs

2. **Recovery Actions:**
   - [ ] Stop application traffic
   - [ ] Restore from backup if needed
   - [ ] Run integrity checks
   - [ ] Test critical queries

3. **Post-Recovery:**
   - [ ] Monitor performance
   - [ ] Update monitoring alerts
   - [ ] Document incident
   - [ ] Review prevention strategies

## Related Documentation

- [Database Best Practices](./best-practices.md) - Prevention strategies
- [Database Common Patterns](./common-patterns.md) - Implementation patterns
- [Active Blockers](../../../templates/troubleshooting/active-blockers/README.md) - Current issues

---

*Last Updated: 2025-07-11*
*Database Support: Neon PostgreSQL, SQLite*
*Troubleshooting Level: Beginner to Advanced*
