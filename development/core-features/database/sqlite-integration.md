# SQLite Integration Guide

Comprehensive guide for integrating SQLite in local development, testing, and lightweight production applications.

## SQLite Setup and Configuration

### Basic SQLite Configuration
```javascript
// sqlite-config.js - Production-ready SQLite setup
import Database from 'better-sqlite3';
import path from 'path';
import fs from 'fs';

class SQLiteDatabase {
  constructor(options = {}) {
    const {
      filename = './data/app.sqlite',
      readonly = false,
      verbose = process.env.NODE_ENV === 'development' ? console.log : null,
      timeout = 30000
    } = options;

    // Ensure database directory exists
    const dir = path.dirname(filename);
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }

    this.db = new Database(filename, {
      readonly,
      verbose,
      timeout
    });

    this.setupOptimizations();
    this.setupCleanup();
  }

  setupOptimizations() {
    // Enable WAL mode for better concurrency
    this.db.pragma('journal_mode = WAL');
    
    // Optimize for performance
    this.db.pragma('synchronous = NORMAL');
    this.db.pragma('cache_size = 1000000'); // 1GB cache
    this.db.pragma('temp_store = memory');
    this.db.pragma('mmap_size = 268435456'); // 256MB memory map
    
    // Enable foreign key constraints
    this.db.pragma('foreign_keys = ON');
    
    // Set busy timeout for concurrent access
    this.db.pragma('busy_timeout = 30000');
    
    // Optimize page size (default is usually good)
    this.db.pragma('page_size = 4096');
  }

  setupCleanup() {
    // Graceful shutdown handlers
    const cleanup = () => {
      if (this.db) {
        this.db.close();
      }
    };

    process.on('exit', cleanup);
    process.on('SIGINT', cleanup);
    process.on('SIGTERM', cleanup);
    process.on('uncaughtException', cleanup);
  }

  // Transaction wrapper
  transaction(fn) {
    return this.db.transaction(fn);
  }

  // Prepared statement with caching
  prepare(sql) {
    if (!this.statements) {
      this.statements = new Map();
    }

    if (!this.statements.has(sql)) {
      this.statements.set(sql, this.db.prepare(sql));
    }

    return this.statements.get(sql);
  }

  // Execute query with automatic statement preparation
  query(sql, params = []) {
    const stmt = this.prepare(sql);
    
    if (sql.trim().toLowerCase().startsWith('select')) {
      return Array.isArray(params) ? stmt.all(...params) : stmt.all(params);
    } else {
      return Array.isArray(params) ? stmt.run(...params) : stmt.run(params);
    }
  }

  close() {
    if (this.statements) {
      this.statements.clear();
    }
    if (this.db) {
      this.db.close();
    }
  }
}

export default SQLiteDatabase;
```

### Environment-Specific Configuration
```javascript
// database-factory.js - Environment-based database selection
import SQLiteDatabase from './sqlite-config.js';
import { Pool } from 'pg';

class DatabaseFactory {
  static create() {
    const env = process.env.NODE_ENV || 'development';
    
    switch (env) {
      case 'development':
        return new SQLiteDatabase({
          filename: './data/development.sqlite',
          verbose: console.log
        });
      
      case 'test':
        return new SQLiteDatabase({
          filename: ':memory:', // In-memory for tests
          verbose: null
        });
      
      case 'staging':
      case 'production':
        return new Pool({
          connectionString: process.env.NEON_DATABASE_URL,
          ssl: { rejectUnauthorized: false }
        });
      
      default:
        throw new Error(`Unknown environment: ${env}`);
    }
  }
}

export default DatabaseFactory;
```

## SQLite Schema Design

### Development Schema Pattern
```sql
-- SQLite-optimized schema design
-- Note: SQLite has dynamic typing, but we use type affinity for consistency

CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE NOT NULL COLLATE NOCASE,
    password_hash TEXT NOT NULL,
    role TEXT DEFAULT 'user' CHECK (role IN ('admin', 'user', 'moderator')),
    is_active INTEGER DEFAULT 1 CHECK (is_active IN (0, 1)),
    email_verified INTEGER DEFAULT 0 CHECK (email_verified IN (0, 1)),
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now')),
    last_login TEXT,
    metadata TEXT -- JSON string
);

CREATE TABLE user_profiles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    first_name TEXT,
    last_name TEXT,
    bio TEXT,
    avatar_url TEXT,
    preferences TEXT, -- JSON string
    updated_at TEXT DEFAULT (datetime('now'))
);

-- Indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_active ON users(is_active);
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);

-- Triggers for updated_at timestamps
CREATE TRIGGER update_users_timestamp 
    AFTER UPDATE ON users
    FOR EACH ROW
    WHEN NEW.updated_at = OLD.updated_at
BEGIN
    UPDATE users SET updated_at = datetime('now') WHERE id = NEW.id;
END;

CREATE TRIGGER update_profiles_timestamp 
    AFTER UPDATE ON user_profiles
    FOR EACH ROW
    WHEN NEW.updated_at = OLD.updated_at
BEGIN
    UPDATE user_profiles SET updated_at = datetime('now') WHERE id = NEW.id;
END;
```

### JSON Handling in SQLite
```javascript
// SQLite JSON utilities
class SQLiteJSONHelper {
  static setJSON(obj, path, value) {
    return `json_set('${JSON.stringify(obj)}', '${path}', '${JSON.stringify(value)}')`;
  }

  static getJSON(column, path) {
    return `json_extract(${column}, '${path}')`;
  }

  static queryByJSON(table, column, path, value) {
    return `SELECT * FROM ${table} WHERE json_extract(${column}, '${path}') = ?`;
  }
}

// Usage examples
const db = new SQLiteDatabase();

// Insert user with JSON metadata
const insertUser = db.prepare(`
  INSERT INTO users (email, password_hash, metadata)
  VALUES (?, ?, ?)
`);

insertUser.run('user@example.com', 'hash', JSON.stringify({
  theme: 'dark',
  language: 'en',
  notifications: true
}));

// Query by JSON field
const getUsersByTheme = db.prepare(`
  SELECT * FROM users 
  WHERE json_extract(metadata, '$.theme') = ?
`);

const darkThemeUsers = getUsersByTheme.all('dark');

// Update JSON field
const updateUserTheme = db.prepare(`
  UPDATE users 
  SET metadata = json_set(metadata, '$.theme', ?)
  WHERE id = ?
`);

updateUserTheme.run('light', 1);
```

## Migration Strategies

### SQLite to PostgreSQL Migration
```javascript
// migration-tool.js - Automated migration from SQLite to PostgreSQL
import SQLiteDatabase from './sqlite-config.js';
import { Pool } from 'pg';

class SQLiteToPostgresMigrator {
  constructor(sqliteDb, postgresPool) {
    this.sqlite = sqliteDb;
    this.postgres = postgresPool;
  }

  async migrate() {
    console.log('Starting SQLite to PostgreSQL migration...');
    
    try {
      await this.createPostgresSchema();
      await this.migrateData();
      await this.updateSequences();
      console.log('Migration completed successfully!');
    } catch (error) {
      console.error('Migration failed:', error);
      throw error;
    }
  }

  async createPostgresSchema() {
    const client = await this.postgres.connect();
    try {
      // Create PostgreSQL schema
      await client.query(`
        CREATE TABLE IF NOT EXISTS users (
          id SERIAL PRIMARY KEY,
          email VARCHAR(255) UNIQUE NOT NULL,
          password_hash VARCHAR(255) NOT NULL,
          role VARCHAR(50) DEFAULT 'user' CHECK (role IN ('admin', 'user', 'moderator')),
          is_active BOOLEAN DEFAULT true,
          email_verified BOOLEAN DEFAULT false,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          last_login TIMESTAMP,
          metadata JSONB
        );

        CREATE TABLE IF NOT EXISTS user_profiles (
          id SERIAL PRIMARY KEY,
          user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
          first_name VARCHAR(100),
          last_name VARCHAR(100),
          bio TEXT,
          avatar_url VARCHAR(500),
          preferences JSONB,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      `);
    } finally {
      client.release();
    }
  }

  async migrateData() {
    const tables = ['users', 'user_profiles'];
    
    for (const table of tables) {
      await this.migrateTable(table);
    }
  }

  async migrateTable(tableName) {
    console.log(`Migrating table: ${tableName}`);
    
    // Get SQLite data
    const data = this.sqlite.query(`SELECT * FROM ${tableName}`);
    
    if (data.length === 0) {
      console.log(`No data to migrate for ${tableName}`);
      return;
    }

    const client = await this.postgres.connect();
    try {
      await client.query('BEGIN');
      
      for (const row of data) {
        await this.insertRow(client, tableName, row);
      }
      
      await client.query('COMMIT');
      console.log(`Migrated ${data.length} rows for ${tableName}`);
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }

  async insertRow(client, tableName, row) {
    const columns = Object.keys(row);
    const values = Object.values(row);
    
    // Convert SQLite types to PostgreSQL
    const convertedValues = values.map((value, index) => {
      const column = columns[index];
      
      // Convert JSON strings to objects
      if (['metadata', 'preferences'].includes(column) && typeof value === 'string') {
        try {
          return JSON.parse(value);
        } catch {
          return value;
        }
      }
      
      // Convert SQLite boolean integers to PostgreSQL booleans
      if (['is_active', 'email_verified'].includes(column)) {
        return value === 1;
      }
      
      return value;
    });

    const placeholders = columns.map((_, i) => `$${i + 1}`).join(', ');
    const sql = `
      INSERT INTO ${tableName} (${columns.join(', ')})
      VALUES (${placeholders})
      ON CONFLICT DO NOTHING
    `;

    await client.query(sql, convertedValues);
  }

  async updateSequences() {
    const client = await this.postgres.connect();
    try {
      // Update PostgreSQL sequences to match migrated data
      await client.query(`
        SELECT setval('users_id_seq', COALESCE((SELECT MAX(id) FROM users), 1));
        SELECT setval('user_profiles_id_seq', COALESCE((SELECT MAX(id) FROM user_profiles), 1));
      `);
    } finally {
      client.release();
    }
  }
}

// Usage
async function runMigration() {
  const sqlite = new SQLiteDatabase({ filename: './data/production.sqlite' });
  const postgres = new Pool({
    connectionString: process.env.NEON_DATABASE_URL,
    ssl: { rejectUnauthorized: false }
  });

  const migrator = new SQLiteToPostgresMigrator(sqlite, postgres);
  await migrator.migrate();
  
  sqlite.close();
  await postgres.end();
}
```

## Testing with SQLite

### Test Database Setup
```javascript
// test-database.js - SQLite test database utilities
import SQLiteDatabase from './sqlite-config.js';

class TestDatabase {
  constructor() {
    // Use in-memory database for tests
    this.db = new SQLiteDatabase({
      filename: ':memory:',
      verbose: null
    });
    
    this.setupSchema();
  }

  setupSchema() {
    // Create test schema
    this.db.query(`
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        role TEXT DEFAULT 'user',
        is_active INTEGER DEFAULT 1,
        created_at TEXT DEFAULT (datetime('now'))
      );
    `);
  }

  seed() {
    // Insert test data
    const users = [
      { email: 'admin@test.com', password_hash: 'hash1', role: 'admin' },
      { email: 'user@test.com', password_hash: 'hash2', role: 'user' }
    ];

    const insertUser = this.db.prepare(`
      INSERT INTO users (email, password_hash, role)
      VALUES (?, ?, ?)
    `);

    for (const user of users) {
      insertUser.run(user.email, user.password_hash, user.role);
    }
  }

  cleanup() {
    this.db.close();
  }
}

// Test example
describe('User Service', () => {
  let testDb;

  beforeEach(() => {
    testDb = new TestDatabase();
    testDb.seed();
  });

  afterEach(() => {
    testDb.cleanup();
  });

  test('should create user', () => {
    const result = testDb.db.query(
      'INSERT INTO users (email, password_hash) VALUES (?, ?)',
      ['new@test.com', 'newhash']
    );
    
    expect(result.changes).toBe(1);
    expect(result.lastInsertRowid).toBeGreaterThan(0);
  });
});
```

## Performance Optimization

### SQLite Performance Best Practices
```javascript
// performance-monitor.js - SQLite performance monitoring
class SQLitePerformanceMonitor {
  constructor(db) {
    this.db = db;
  }

  analyzeQuery(sql) {
    // Get query plan
    const plan = this.db.prepare(`EXPLAIN QUERY PLAN ${sql}`).all();
    console.log('Query Plan:', plan);
    
    // Check if indexes are being used
    const usesIndex = plan.some(step => 
      step.detail.includes('USING INDEX') || 
      step.detail.includes('PRIMARY KEY')
    );
    
    if (!usesIndex) {
      console.warn('Query may benefit from an index:', sql);
    }
    
    return { plan, usesIndex };
  }

  getTableStats() {
    const stats = this.db.prepare(`
      SELECT 
        name,
        (SELECT COUNT(*) FROM pragma_table_info(name)) as column_count,
        (SELECT COUNT(*) FROM sqlite_master WHERE type='index' AND tbl_name=name) as index_count
      FROM sqlite_master 
      WHERE type='table' AND name NOT LIKE 'sqlite_%'
    `).all();
    
    return stats;
  }

  vacuum() {
    console.log('Running VACUUM to optimize database...');
    this.db.exec('VACUUM');
    console.log('VACUUM completed');
  }

  analyze() {
    console.log('Running ANALYZE to update statistics...');
    this.db.exec('ANALYZE');
    console.log('ANALYZE completed');
  }
}
```

## Related Documentation

- [Database Best Practices](./best-practices.md) - General database guidelines
- [Database Common Patterns](./common-patterns.md) - Reusable patterns
- [Database Troubleshooting](./troubleshooting.md) - Issue resolution

---

*Last Updated: 2025-07-11*
*SQLite Version: 3.40+*
*Framework Support: better-sqlite3, Prisma, TypeORM*
