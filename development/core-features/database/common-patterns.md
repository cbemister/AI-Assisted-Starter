# Database Common Patterns

Reusable database patterns, schemas, and code templates for implementing robust database layers across different database systems and frameworks.

## Database Connection Patterns

### Neon PostgreSQL Connection Pattern
```javascript
// Neon PostgreSQL connection with optimized settings
import { Pool } from 'pg';

class NeonDatabaseConnection {
  constructor() {
    this.pool = new Pool({
      connectionString: process.env.NEON_DATABASE_URL,
      ssl: {
        rejectUnauthorized: false
      },
      max: 20,                    // Maximum connections
      min: 5,                     // Minimum connections
      idleTimeoutMillis: 30000,   // Close idle connections after 30s
      connectionTimeoutMillis: 2000, // Connection timeout
    });
  }

  async query(text, params) {
    const client = await this.pool.connect();
    try {
      const result = await client.query(text, params);
      return result;
    } finally {
      client.release();
    }
  }

  async transaction(callback) {
    const client = await this.pool.connect();
    try {
      await client.query('BEGIN');
      const result = await callback(client);
      await client.query('COMMIT');
      return result;
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }

  async close() {
    await this.pool.end();
  }
}

// Usage example
const db = new NeonDatabaseConnection();
export default db;
```

### SQLite Connection Pattern
```javascript
// SQLite connection for local development
import Database from 'better-sqlite3';
import path from 'path';

class SQLiteConnection {
  constructor(dbPath = 'database.sqlite') {
    this.dbPath = path.resolve(dbPath);
    this.db = new Database(this.dbPath, {
      verbose: process.env.NODE_ENV === 'development' ? console.log : null
    });
    
    // Enable WAL mode for better concurrency
    this.db.pragma('journal_mode = WAL');
    this.db.pragma('synchronous = NORMAL');
    this.db.pragma('cache_size = 1000000');
    this.db.pragma('temp_store = memory');
  }

  query(sql, params = []) {
    try {
      if (sql.trim().toLowerCase().startsWith('select')) {
        return this.db.prepare(sql).all(params);
      } else {
        return this.db.prepare(sql).run(params);
      }
    } catch (error) {
      console.error('SQLite Query Error:', error);
      throw error;
    }
  }

  transaction(callback) {
    const transaction = this.db.transaction(callback);
    return transaction();
  }

  close() {
    this.db.close();
  }
}

// Usage example
const db = new SQLiteConnection('./data/app.sqlite');
export default db;
```

## Schema Design Patterns

### User Management Schema
```sql
-- Universal user management schema (PostgreSQL/SQLite compatible)
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- SQLite
    -- id SERIAL PRIMARY KEY,              -- PostgreSQL
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'user' CHECK (role IN ('admin', 'user', 'moderator')),
    is_active BOOLEAN DEFAULT true,
    email_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    metadata TEXT -- JSON string for SQLite, JSONB for PostgreSQL
);

CREATE TABLE user_profiles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    bio TEXT,
    avatar_url VARCHAR(500),
    preferences TEXT, -- JSON string
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_active ON users(is_active);
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);
```

### Admin Account Setup Pattern
```sql
-- Admin account creation with secure defaults
INSERT INTO users (
    email, 
    password_hash, 
    role, 
    is_active, 
    email_verified,
    created_at
) VALUES (
    'admin@example.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/RK.PJ/...',
    'admin',
    true,
    true,
    CURRENT_TIMESTAMP
);

-- Create admin profile
INSERT INTO user_profiles (
    user_id,
    first_name,
    last_name,
    bio,
    preferences
) VALUES (
    (SELECT id FROM users WHERE email = 'admin@example.com'),
    'System',
    'Administrator',
    'Default system administrator account',
    '{"theme": "dark", "notifications": true, "language": "en"}'
);
```

## ORM Integration Patterns

### Prisma Schema Pattern
```prisma
// prisma/schema.prisma - Universal schema for Neon/SQLite
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql" // Change to "sqlite" for local development
  url      = env("DATABASE_URL")
}

model User {
  id            Int       @id @default(autoincrement())
  email         String    @unique @db.VarChar(255)
  passwordHash  String    @map("password_hash") @db.VarChar(255)
  role          Role      @default(USER)
  isActive      Boolean   @default(true) @map("is_active")
  emailVerified Boolean   @default(false) @map("email_verified")
  createdAt     DateTime  @default(now()) @map("created_at")
  updatedAt     DateTime  @updatedAt @map("updated_at")
  lastLogin     DateTime? @map("last_login")
  metadata      Json?

  profile UserProfile?
  sessions Session[]

  @@map("users")
  @@index([email])
  @@index([role])
  @@index([isActive])
}

model UserProfile {
  id          Int      @id @default(autoincrement())
  userId      Int      @unique @map("user_id")
  firstName   String?  @map("first_name") @db.VarChar(100)
  lastName    String?  @map("last_name") @db.VarChar(100)
  bio         String?  @db.Text
  avatarUrl   String?  @map("avatar_url") @db.VarChar(500)
  preferences Json?
  updatedAt   DateTime @updatedAt @map("updated_at")

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@map("user_profiles")
}

model Session {
  id        String   @id @default(cuid())
  userId    Int      @map("user_id")
  token     String   @unique @db.VarChar(500)
  expiresAt DateTime @map("expires_at")
  createdAt DateTime @default(now()) @map("created_at")

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@map("sessions")
  @@index([token])
  @@index([expiresAt])
}

enum Role {
  ADMIN
  USER
  MODERATOR
}
```

### Database Service Pattern
```javascript
// Universal database service pattern
class DatabaseService {
  constructor(connection) {
    this.db = connection;
  }

  // User management methods
  async createUser(userData) {
    const { email, password, role = 'user' } = userData;
    const passwordHash = await this.hashPassword(password);
    
    return await this.db.transaction(async (tx) => {
      const user = await tx.user.create({
        data: {
          email,
          passwordHash,
          role: role.toUpperCase(),
          profile: {
            create: {
              firstName: userData.firstName,
              lastName: userData.lastName,
              bio: userData.bio
            }
          }
        },
        include: { profile: true }
      });
      
      return user;
    });
  }

  async createAdminUser(adminData) {
    return await this.createUser({
      ...adminData,
      role: 'admin',
      emailVerified: true
    });
  }

  async findUserByEmail(email) {
    return await this.db.user.findUnique({
      where: { email },
      include: { profile: true }
    });
  }

  async updateUserLastLogin(userId) {
    return await this.db.user.update({
      where: { id: userId },
      data: { lastLogin: new Date() }
    });
  }

  // Session management
  async createSession(userId, token, expiresAt) {
    return await this.db.session.create({
      data: { userId, token, expiresAt }
    });
  }

  async findValidSession(token) {
    return await this.db.session.findFirst({
      where: {
        token,
        expiresAt: { gt: new Date() }
      },
      include: { user: { include: { profile: true } } }
    });
  }

  async deleteSession(token) {
    return await this.db.session.delete({
      where: { token }
    });
  }

  // Utility methods
  async hashPassword(password) {
    const bcrypt = require('bcrypt');
    return await bcrypt.hash(password, 12);
  }

  async verifyPassword(password, hash) {
    const bcrypt = require('bcrypt');
    return await bcrypt.compare(password, hash);
  }
}

export default DatabaseService;
```

## Migration Patterns

### Database-Agnostic Migration Pattern
```javascript
// migrations/001_initial_schema.js
class Migration001 {
  static async up(db, dbType) {
    const userTableSQL = dbType === 'sqlite' 
      ? `CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email VARCHAR(255) UNIQUE NOT NULL,
          password_hash VARCHAR(255) NOT NULL,
          role VARCHAR(50) DEFAULT 'user',
          is_active BOOLEAN DEFAULT true,
          email_verified BOOLEAN DEFAULT false,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          last_login TIMESTAMP,
          metadata TEXT
        )`
      : `CREATE TABLE users (
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
        )`;

    await db.query(userTableSQL);
    
    // Create indexes
    await db.query('CREATE INDEX idx_users_email ON users(email)');
    await db.query('CREATE INDEX idx_users_role ON users(role)');
    await db.query('CREATE INDEX idx_users_active ON users(is_active)');
  }

  static async down(db) {
    await db.query('DROP TABLE IF EXISTS users');
  }
}

export default Migration001;
```

## Framework-Specific Integration Examples

### React Integration with Database
```jsx
// React hook for database operations
import { useState, useEffect } from 'react';
import { DatabaseService } from '../services/database-service';

export function useDatabase() {
  const [db, setDb] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    async function initializeDatabase() {
      try {
        const dbService = new DatabaseService();
        await dbService.initialize();
        setDb(dbService);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    }

    initializeDatabase();
  }, []);

  const createUser = async (userData) => {
    try {
      return await db.createUser(userData);
    } catch (err) {
      setError(err.message);
      throw err;
    }
  };

  const createAdmin = async (adminData) => {
    try {
      return await db.createAdminUser(adminData);
    } catch (err) {
      setError(err.message);
      throw err;
    }
  };

  return { db, loading, error, createUser, createAdmin };
}

// React component for admin setup
function AdminSetupComponent() {
  const { createAdmin, loading, error } = useDatabase();
  const [adminData, setAdminData] = useState({
    email: '',
    firstName: '',
    lastName: '',
    role: 'admin'
  });

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const admin = await createAdmin(adminData);
      alert(`Admin created successfully! ID: ${admin.id}`);
    } catch (error) {
      alert(`Failed to create admin: ${error.message}`);
    }
  };

  if (loading) return <div>Initializing database...</div>;
  if (error) return <div>Database error: {error}</div>;

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="email"
        placeholder="Admin Email"
        value={adminData.email}
        onChange={(e) => setAdminData({...adminData, email: e.target.value})}
        required
      />
      <input
        type="text"
        placeholder="First Name"
        value={adminData.firstName}
        onChange={(e) => setAdminData({...adminData, firstName: e.target.value})}
        required
      />
      <input
        type="text"
        placeholder="Last Name"
        value={adminData.lastName}
        onChange={(e) => setAdminData({...adminData, lastName: e.target.value})}
        required
      />
      <button type="submit">Create Admin</button>
    </form>
  );
}
```

### Vue.js Integration with Database
```vue
<!-- Vue component for database operations -->
<template>
  <div class="database-manager">
    <div v-if="loading">Initializing database...</div>
    <div v-else-if="error" class="error">Database error: {{ error }}</div>
    <div v-else>
      <AdminSetupForm @admin-created="handleAdminCreated" />
      <UserList :users="users" @refresh="loadUsers" />
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { DatabaseService } from '../services/database-service';

export default {
  name: 'DatabaseManager',
  setup() {
    const db = ref(null);
    const loading = ref(true);
    const error = ref(null);
    const users = ref([]);

    const initializeDatabase = async () => {
      try {
        const dbService = new DatabaseService();
        await dbService.initialize();
        db.value = dbService;
        await loadUsers();
      } catch (err) {
        error.value = err.message;
      } finally {
        loading.value = false;
      }
    };

    const loadUsers = async () => {
      try {
        const userList = await db.value.getUsers();
        users.value = userList;
      } catch (err) {
        error.value = err.message;
      }
    };

    const handleAdminCreated = async (adminData) => {
      try {
        await db.value.createAdminUser(adminData);
        await loadUsers();
        alert('Admin created successfully!');
      } catch (err) {
        alert(`Failed to create admin: ${err.message}`);
      }
    };

    onMounted(initializeDatabase);

    return {
      loading,
      error,
      users,
      handleAdminCreated,
      loadUsers
    };
  }
};
</script>
```

### Angular Integration with Database
```typescript
// Angular service for database operations
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { DatabaseService } from '../services/database-service';

@Injectable({
  providedIn: 'root'
})
export class DatabaseManagerService {
  private dbService: DatabaseService | null = null;
  private loadingSubject = new BehaviorSubject<boolean>(true);
  private errorSubject = new BehaviorSubject<string | null>(null);

  public loading$ = this.loadingSubject.asObservable();
  public error$ = this.errorSubject.asObservable();

  constructor() {
    this.initializeDatabase();
  }

  private async initializeDatabase(): Promise<void> {
    try {
      this.dbService = new DatabaseService();
      await this.dbService.initialize();
      this.loadingSubject.next(false);
    } catch (error) {
      this.errorSubject.next(error.message);
      this.loadingSubject.next(false);
    }
  }

  async createAdmin(adminData: any): Promise<any> {
    if (!this.dbService) {
      throw new Error('Database not initialized');
    }

    try {
      return await this.dbService.createAdminUser(adminData);
    } catch (error) {
      this.errorSubject.next(error.message);
      throw error;
    }
  }

  async getUsers(): Promise<any[]> {
    if (!this.dbService) {
      throw new Error('Database not initialized');
    }

    return await this.dbService.getUsers();
  }
}

// Angular component
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { DatabaseManagerService } from '../services/database-manager.service';

@Component({
  selector: 'app-admin-setup',
  template: `
    <div class="admin-setup">
      <div *ngIf="loading$ | async">Initializing database...</div>
      <div *ngIf="error$ | async as error" class="error">
        Database error: {{ error }}
      </div>
      <form *ngIf="!(loading$ | async)" [formGroup]="adminForm" (ngSubmit)="onSubmit()">
        <input formControlName="email" type="email" placeholder="Admin Email" required>
        <input formControlName="firstName" type="text" placeholder="First Name" required>
        <input formControlName="lastName" type="text" placeholder="Last Name" required>
        <button type="submit" [disabled]="adminForm.invalid">Create Admin</button>
      </form>
    </div>
  `
})
export class AdminSetupComponent implements OnInit {
  adminForm: FormGroup;
  loading$ = this.dbManager.loading$;
  error$ = this.dbManager.error$;

  constructor(
    private fb: FormBuilder,
    private dbManager: DatabaseManagerService
  ) {
    this.adminForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      firstName: ['', Validators.required],
      lastName: ['', Validators.required]
    });
  }

  ngOnInit(): void {}

  async onSubmit(): Promise<void> {
    if (this.adminForm.valid) {
      try {
        const admin = await this.dbManager.createAdmin(this.adminForm.value);
        alert(`Admin created successfully! ID: ${admin.id}`);
        this.adminForm.reset();
      } catch (error) {
        alert(`Failed to create admin: ${error.message}`);
      }
    }
  }
}
```

### Vanilla JavaScript Integration
```javascript
// Vanilla JS database integration
class DatabaseUI {
  constructor() {
    this.db = null;
    this.loading = true;
    this.error = null;
    this.init();
  }

  async init() {
    try {
      this.showLoading();
      this.db = new DatabaseService();
      await this.db.initialize();
      this.hideLoading();
      this.setupUI();
    } catch (error) {
      this.showError(error.message);
    }
  }

  setupUI() {
    const container = document.getElementById('database-container');
    container.innerHTML = `
      <div class="admin-setup">
        <h2>Admin Setup</h2>
        <form id="admin-form">
          <input type="email" id="admin-email" placeholder="Admin Email" required>
          <input type="text" id="admin-firstname" placeholder="First Name" required>
          <input type="text" id="admin-lastname" placeholder="Last Name" required>
          <button type="submit">Create Admin</button>
        </form>
      </div>
      <div class="user-list">
        <h2>Users</h2>
        <button id="refresh-users">Refresh Users</button>
        <ul id="users-list"></ul>
      </div>
    `;

    this.attachEventListeners();
    this.loadUsers();
  }

  attachEventListeners() {
    const adminForm = document.getElementById('admin-form');
    const refreshButton = document.getElementById('refresh-users');

    adminForm.addEventListener('submit', async (e) => {
      e.preventDefault();
      await this.handleAdminCreation();
    });

    refreshButton.addEventListener('click', () => {
      this.loadUsers();
    });
  }

  async handleAdminCreation() {
    const email = document.getElementById('admin-email').value;
    const firstName = document.getElementById('admin-firstname').value;
    const lastName = document.getElementById('admin-lastname').value;

    try {
      const admin = await this.db.createAdminUser({
        email,
        firstName,
        lastName,
        role: 'admin'
      });

      alert(`Admin created successfully! ID: ${admin.id}`);
      document.getElementById('admin-form').reset();
      this.loadUsers();
    } catch (error) {
      alert(`Failed to create admin: ${error.message}`);
    }
  }

  async loadUsers() {
    try {
      const users = await this.db.getUsers();
      const usersList = document.getElementById('users-list');

      usersList.innerHTML = users.map(user => `
        <li>
          <strong>${user.email}</strong> - ${user.role}
          <span class="user-details">
            ${user.profile?.firstName} ${user.profile?.lastName}
          </span>
        </li>
      `).join('');
    } catch (error) {
      this.showError(`Failed to load users: ${error.message}`);
    }
  }

  showLoading() {
    const container = document.getElementById('database-container');
    container.innerHTML = '<div class="loading">Initializing database...</div>';
  }

  hideLoading() {
    const loadingEl = document.querySelector('.loading');
    if (loadingEl) loadingEl.remove();
  }

  showError(message) {
    const container = document.getElementById('database-container');
    container.innerHTML = `<div class="error">Database error: ${message}</div>`;
  }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  new DatabaseUI();
});
```

## Related Documentation

- [Database Best Practices](./best-practices.md) - Implementation guidelines and optimization
- [Database Troubleshooting](./troubleshooting.md) - Common issues and solutions
- [Authentication Patterns](../authentication/common-patterns.md) - User authentication integration

---

*Last Updated: 2025-07-11*
*Database Support: Neon PostgreSQL, SQLite*
*Framework Support: React, Vue, Angular, Vanilla JS, Prisma, TypeORM*
