# Testing Strategies Documentation

Comprehensive guidelines for implementing testing strategies across all application layers, including unit testing, integration testing, end-to-end testing, and test data management.

## Overview

This directory provides standardized patterns for building robust testing suites that ensure code quality, prevent regressions, and support confident deployments. Covers testing strategies for frontend, backend, API, database, and full-stack applications.

## Quick Reference

### Testing Types
- **Unit Tests**: Individual function and component testing
- **Integration Tests**: Module and service interaction testing
- **End-to-End Tests**: Complete user workflow testing
- **Performance Tests**: Load and stress testing
- **Security Tests**: Vulnerability and penetration testing

### Testing Tools
- **JavaScript**: Jest, Vitest, Cypress, Playwright, Testing Library
- **Python**: pytest, unittest, Selenium
- **Java**: JUnit, TestNG, Mockito
- **C#**: xUnit, NUnit, MSTest

## Methodology Approaches

### MVP/Rapid (2-4 weeks)
- Essential unit tests for critical functions
- Basic integration tests for API endpoints
- Simple end-to-end tests for core user flows
- Manual testing for edge cases

### Balanced/Standard (4-8 weeks)
- Comprehensive unit test coverage (80%+)
- Integration tests for all major components
- Automated end-to-end test suite
- Performance testing for critical paths

### Comprehensive/Enterprise (8-12 weeks)
- Full test coverage with mutation testing
- Comprehensive integration and contract testing
- Advanced end-to-end testing with visual regression
- Continuous performance and security testing

## File Structure

```
testing/
├── README.md                    # This overview file
├── best-practices.md           # Testing guidelines and standards
├── common-patterns.md          # Reusable testing patterns
├── troubleshooting.md          # Testing issues and solutions
├── unit-testing.md             # Unit testing strategies
├── integration-testing.md      # Integration testing approaches
├── e2e-testing.md              # End-to-end testing patterns
├── performance-testing.md      # Performance testing strategies
├── test-data-management.md     # Test data and fixtures
├── ci-cd-integration.md        # Continuous testing integration
└── framework-guides/
    ├── jest-testing.md         # Jest testing patterns
    ├── cypress-testing.md      # Cypress E2E testing
    ├── playwright-testing.md   # Playwright testing
    ├── react-testing.md        # React component testing
    ├── vue-testing.md          # Vue component testing
    └── api-testing.md          # API testing strategies
```

## Unit Testing Strategies

### React Component Testing
```javascript
// __tests__/UserProfile.test.jsx
import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { jest } from '@jest/globals';
import UserProfile from '../components/UserProfile';
import { AuthProvider } from '../contexts/AuthContext';
import { userAPI } from '../services/api';

// Mock API calls
jest.mock('../services/api');

// Test utilities
const renderWithAuth = (component, authValue = {}) => {
  const defaultAuth = {
    user: { id: 1, name: 'Test User', email: 'test@example.com' },
    isAuthenticated: true,
    login: jest.fn(),
    logout: jest.fn()
  };

  return render(
    <AuthProvider value={{ ...defaultAuth, ...authValue }}>
      {component}
    </AuthProvider>
  );
};

describe('UserProfile Component', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('Rendering', () => {
    it('should render user information when authenticated', () => {
      const user = { id: 1, name: 'John Doe', email: 'john@example.com' };
      
      renderWithAuth(<UserProfile />, { user });
      
      expect(screen.getByText('John Doe')).toBeInTheDocument();
      expect(screen.getByText('john@example.com')).toBeInTheDocument();
    });

    it('should render login prompt when not authenticated', () => {
      renderWithAuth(<UserProfile />, { 
        user: null, 
        isAuthenticated: false 
      });
      
      expect(screen.getByText(/please log in/i)).toBeInTheDocument();
      expect(screen.getByRole('button', { name: /log in/i })).toBeInTheDocument();
    });
  });

  describe('User Interactions', () => {
    it('should handle profile update', async () => {
      const mockUpdateUser = jest.fn().mockResolvedValue({
        id: 1,
        name: 'Updated Name',
        email: 'updated@example.com'
      });
      
      userAPI.updateUser.mockImplementation(mockUpdateUser);
      
      renderWithAuth(<UserProfile />);
      
      // Click edit button
      fireEvent.click(screen.getByRole('button', { name: /edit/i }));
      
      // Update name field
      const nameInput = screen.getByLabelText(/name/i);
      fireEvent.change(nameInput, { target: { value: 'Updated Name' } });
      
      // Submit form
      fireEvent.click(screen.getByRole('button', { name: /save/i }));
      
      // Wait for API call and UI update
      await waitFor(() => {
        expect(mockUpdateUser).toHaveBeenCalledWith(1, {
          name: 'Updated Name'
        });
      });
      
      expect(screen.getByText('Updated Name')).toBeInTheDocument();
    });

    it('should handle update errors gracefully', async () => {
      const mockError = new Error('Update failed');
      userAPI.updateUser.mockRejectedValue(mockError);
      
      renderWithAuth(<UserProfile />);
      
      fireEvent.click(screen.getByRole('button', { name: /edit/i }));
      fireEvent.click(screen.getByRole('button', { name: /save/i }));
      
      await waitFor(() => {
        expect(screen.getByText(/update failed/i)).toBeInTheDocument();
      });
    });
  });

  describe('Loading States', () => {
    it('should show loading spinner during update', async () => {
      let resolveUpdate;
      const updatePromise = new Promise(resolve => {
        resolveUpdate = resolve;
      });
      
      userAPI.updateUser.mockReturnValue(updatePromise);
      
      renderWithAuth(<UserProfile />);
      
      fireEvent.click(screen.getByRole('button', { name: /edit/i }));
      fireEvent.click(screen.getByRole('button', { name: /save/i }));
      
      expect(screen.getByTestId('loading-spinner')).toBeInTheDocument();
      
      resolveUpdate({ id: 1, name: 'Test User' });
      
      await waitFor(() => {
        expect(screen.queryByTestId('loading-spinner')).not.toBeInTheDocument();
      });
    });
  });
});
```

### API Service Testing
```javascript
// __tests__/userAPI.test.js
import { userAPI } from '../services/userAPI';
import { apiClient } from '../services/apiClient';

// Mock the API client
jest.mock('../services/apiClient');

describe('User API Service', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('getUsers', () => {
    it('should fetch users with default parameters', async () => {
      const mockUsers = {
        data: [
          { id: 1, name: 'User 1', email: 'user1@example.com' },
          { id: 2, name: 'User 2', email: 'user2@example.com' }
        ],
        pagination: { page: 1, limit: 10, total: 2 }
      };

      apiClient.get.mockResolvedValue({ data: mockUsers });

      const result = await userAPI.getUsers();

      expect(apiClient.get).toHaveBeenCalledWith('/users', {
        params: { page: 1, limit: 10 }
      });
      expect(result).toEqual(mockUsers);
    });

    it('should handle API errors', async () => {
      const mockError = new Error('Network error');
      apiClient.get.mockRejectedValue(mockError);

      await expect(userAPI.getUsers()).rejects.toThrow('Network error');
    });
  });

  describe('createUser', () => {
    it('should create a new user', async () => {
      const userData = { name: 'New User', email: 'new@example.com' };
      const mockResponse = { id: 3, ...userData };

      apiClient.post.mockResolvedValue({ data: mockResponse });

      const result = await userAPI.createUser(userData);

      expect(apiClient.post).toHaveBeenCalledWith('/users', userData);
      expect(result).toEqual(mockResponse);
    });

    it('should handle validation errors', async () => {
      const userData = { name: '', email: 'invalid-email' };
      const mockError = {
        response: {
          status: 400,
          data: {
            error: {
              code: 'VALIDATION_ERROR',
              details: [
                { field: 'name', message: 'Name is required' },
                { field: 'email', message: 'Invalid email format' }
              ]
            }
          }
        }
      };

      apiClient.post.mockRejectedValue(mockError);

      await expect(userAPI.createUser(userData)).rejects.toMatchObject({
        response: {
          status: 400,
          data: {
            error: {
              code: 'VALIDATION_ERROR'
            }
          }
        }
      });
    });
  });
});
```

## Integration Testing

### API Integration Tests
```javascript
// __tests__/integration/userRoutes.test.js
import request from 'supertest';
import app from '../../app';
import { setupTestDB, cleanupTestDB } from '../helpers/database';
import { createTestUser, getAuthToken } from '../helpers/auth';

describe('User Routes Integration', () => {
  beforeAll(async () => {
    await setupTestDB();
  });

  afterAll(async () => {
    await cleanupTestDB();
  });

  beforeEach(async () => {
    await cleanupTestDB();
  });

  describe('GET /api/users', () => {
    it('should return paginated users for authenticated requests', async () => {
      // Create test users
      const users = await Promise.all([
        createTestUser({ name: 'User 1', email: 'user1@test.com' }),
        createTestUser({ name: 'User 2', email: 'user2@test.com' }),
        createTestUser({ name: 'User 3', email: 'user3@test.com' })
      ]);

      const token = await getAuthToken(users[0]);

      const response = await request(app)
        .get('/api/users')
        .set('Authorization', `Bearer ${token}`)
        .query({ page: 1, limit: 2 })
        .expect(200);

      expect(response.body).toHaveProperty('data');
      expect(response.body).toHaveProperty('pagination');
      expect(response.body.data).toHaveLength(2);
      expect(response.body.pagination).toMatchObject({
        page: 1,
        limit: 2,
        total: 3
      });
    });

    it('should require authentication', async () => {
      await request(app)
        .get('/api/users')
        .expect(401);
    });

    it('should handle search queries', async () => {
      await createTestUser({ name: 'John Doe', email: 'john@test.com' });
      await createTestUser({ name: 'Jane Smith', email: 'jane@test.com' });
      
      const user = await createTestUser({ name: 'Admin', email: 'admin@test.com' });
      const token = await getAuthToken(user);

      const response = await request(app)
        .get('/api/users')
        .set('Authorization', `Bearer ${token}`)
        .query({ search: 'john' })
        .expect(200);

      expect(response.body.data).toHaveLength(1);
      expect(response.body.data[0].name).toBe('John Doe');
    });
  });

  describe('POST /api/users', () => {
    it('should create a new user with valid data', async () => {
      const userData = {
        name: 'New User',
        email: 'newuser@test.com',
        password: 'securePassword123'
      };

      const response = await request(app)
        .post('/api/users')
        .send(userData)
        .expect(201);

      expect(response.body).toHaveProperty('id');
      expect(response.body.name).toBe(userData.name);
      expect(response.body.email).toBe(userData.email);
      expect(response.body).not.toHaveProperty('password');
    });

    it('should validate required fields', async () => {
      const invalidData = {
        name: '',
        email: 'invalid-email'
      };

      const response = await request(app)
        .post('/api/users')
        .send(invalidData)
        .expect(400);

      expect(response.body.error.code).toBe('VALIDATION_ERROR');
      expect(response.body.error.details).toEqual(
        expect.arrayContaining([
          expect.objectContaining({ field: 'name' }),
          expect.objectContaining({ field: 'email' }),
          expect.objectContaining({ field: 'password' })
        ])
      );
    });

    it('should prevent duplicate email addresses', async () => {
      const userData = {
        name: 'Test User',
        email: 'duplicate@test.com',
        password: 'password123'
      };

      // Create first user
      await request(app)
        .post('/api/users')
        .send(userData)
        .expect(201);

      // Attempt to create duplicate
      const response = await request(app)
        .post('/api/users')
        .send({ ...userData, name: 'Different Name' })
        .expect(409);

      expect(response.body.error.code).toBe('DUPLICATE_ERROR');
    });
  });
});
```

## End-to-End Testing

### Cypress E2E Tests
```javascript
// cypress/e2e/userManagement.cy.js
describe('User Management Flow', () => {
  beforeEach(() => {
    // Reset database and seed test data
    cy.task('db:seed');
    
    // Login as admin user
    cy.login('admin@test.com', 'password123');
  });

  it('should complete full user management workflow', () => {
    // Navigate to users page
    cy.visit('/admin/users');
    cy.url().should('include', '/admin/users');

    // Verify users list loads
    cy.get('[data-testid="users-table"]').should('be.visible');
    cy.get('[data-testid="user-row"]').should('have.length.at.least', 1);

    // Create new user
    cy.get('[data-testid="add-user-button"]').click();
    cy.get('[data-testid="user-form-modal"]').should('be.visible');

    // Fill out user form
    cy.get('[data-testid="name-input"]').type('Test User');
    cy.get('[data-testid="email-input"]').type('testuser@example.com');
    cy.get('[data-testid="password-input"]').type('securePassword123');
    cy.get('[data-testid="role-select"]').select('user');

    // Submit form
    cy.get('[data-testid="submit-button"]').click();

    // Verify user was created
    cy.get('[data-testid="user-form-modal"]').should('not.exist');
    cy.get('[data-testid="success-message"]').should('contain', 'User created successfully');
    cy.get('[data-testid="users-table"]').should('contain', 'testuser@example.com');

    // Edit user
    cy.get('[data-testid="user-row"]')
      .contains('testuser@example.com')
      .parent()
      .find('[data-testid="edit-button"]')
      .click();

    cy.get('[data-testid="user-form-modal"]').should('be.visible');
    cy.get('[data-testid="name-input"]').clear().type('Updated Test User');
    cy.get('[data-testid="submit-button"]').click();

    // Verify user was updated
    cy.get('[data-testid="success-message"]').should('contain', 'User updated successfully');
    cy.get('[data-testid="users-table"]').should('contain', 'Updated Test User');

    // Delete user
    cy.get('[data-testid="user-row"]')
      .contains('testuser@example.com')
      .parent()
      .find('[data-testid="delete-button"]')
      .click();

    cy.get('[data-testid="confirm-dialog"]').should('be.visible');
    cy.get('[data-testid="confirm-delete-button"]').click();

    // Verify user was deleted
    cy.get('[data-testid="success-message"]').should('contain', 'User deleted successfully');
    cy.get('[data-testid="users-table"]').should('not.contain', 'testuser@example.com');
  });

  it('should handle form validation errors', () => {
    cy.visit('/admin/users');
    cy.get('[data-testid="add-user-button"]').click();

    // Submit empty form
    cy.get('[data-testid="submit-button"]').click();

    // Verify validation errors
    cy.get('[data-testid="name-error"]').should('contain', 'Name is required');
    cy.get('[data-testid="email-error"]').should('contain', 'Email is required');
    cy.get('[data-testid="password-error"]').should('contain', 'Password is required');

    // Test invalid email
    cy.get('[data-testid="email-input"]').type('invalid-email');
    cy.get('[data-testid="submit-button"]').click();
    cy.get('[data-testid="email-error"]').should('contain', 'Invalid email format');

    // Test weak password
    cy.get('[data-testid="password-input"]').type('123');
    cy.get('[data-testid="submit-button"]').click();
    cy.get('[data-testid="password-error"]').should('contain', 'Password must be at least 8 characters');
  });

  it('should handle network errors gracefully', () => {
    // Intercept API call and simulate error
    cy.intercept('POST', '/api/users', { statusCode: 500 }).as('createUserError');

    cy.visit('/admin/users');
    cy.get('[data-testid="add-user-button"]').click();

    // Fill valid form
    cy.get('[data-testid="name-input"]').type('Test User');
    cy.get('[data-testid="email-input"]').type('test@example.com');
    cy.get('[data-testid="password-input"]').type('password123');

    cy.get('[data-testid="submit-button"]').click();

    // Wait for API call
    cy.wait('@createUserError');

    // Verify error message
    cy.get('[data-testid="error-message"]').should('contain', 'Failed to create user');
    cy.get('[data-testid="user-form-modal"]').should('be.visible'); // Form should remain open
  });
});
```

## Test Data Management

### Test Database Setup
```javascript
// tests/helpers/database.js
import { PrismaClient } from '@prisma/client';
import { execSync } from 'child_process';

const prisma = new PrismaClient({
  datasources: {
    db: {
      url: process.env.TEST_DATABASE_URL
    }
  }
});

export async function setupTestDB() {
  // Run migrations
  execSync('npx prisma migrate deploy', {
    env: { ...process.env, DATABASE_URL: process.env.TEST_DATABASE_URL }
  });

  // Seed basic test data
  await seedTestData();
}

export async function cleanupTestDB() {
  // Clean up in reverse order of dependencies
  await prisma.orderItem.deleteMany();
  await prisma.order.deleteMany();
  await prisma.userProfile.deleteMany();
  await prisma.user.deleteMany();
  await prisma.product.deleteMany();
}

export async function seedTestData() {
  // Create test users
  const adminUser = await prisma.user.create({
    data: {
      email: 'admin@test.com',
      password: await hashPassword('password123'),
      roles: ['admin'],
      profile: {
        create: {
          firstName: 'Admin',
          lastName: 'User'
        }
      }
    }
  });

  const regularUser = await prisma.user.create({
    data: {
      email: 'user@test.com',
      password: await hashPassword('password123'),
      roles: ['user'],
      profile: {
        create: {
          firstName: 'Regular',
          lastName: 'User'
        }
      }
    }
  });

  // Create test products
  const products = await Promise.all([
    prisma.product.create({
      data: {
        name: 'Test Product 1',
        description: 'A test product',
        price: 29.99,
        stockQuantity: 100
      }
    }),
    prisma.product.create({
      data: {
        name: 'Test Product 2',
        description: 'Another test product',
        price: 49.99,
        stockQuantity: 50
      }
    })
  ]);

  return { adminUser, regularUser, products };
}

// Test data factories
export class TestDataFactory {
  static async createUser(overrides = {}) {
    const defaultData = {
      email: `user${Date.now()}@test.com`,
      password: await hashPassword('password123'),
      roles: ['user']
    };

    return await prisma.user.create({
      data: { ...defaultData, ...overrides }
    });
  }

  static async createUserWithProfile(userOverrides = {}, profileOverrides = {}) {
    const defaultUserData = {
      email: `user${Date.now()}@test.com`,
      password: await hashPassword('password123'),
      roles: ['user']
    };

    const defaultProfileData = {
      firstName: 'Test',
      lastName: 'User'
    };

    return await prisma.user.create({
      data: {
        ...defaultUserData,
        ...userOverrides,
        profile: {
          create: {
            ...defaultProfileData,
            ...profileOverrides
          }
        }
      },
      include: {
        profile: true
      }
    });
  }

  static async createProduct(overrides = {}) {
    const defaultData = {
      name: `Test Product ${Date.now()}`,
      description: 'A test product',
      price: 29.99,
      stockQuantity: 100
    };

    return await prisma.product.create({
      data: { ...defaultData, ...overrides }
    });
  }

  static async createOrder(userId, items = [], overrides = {}) {
    const defaultData = {
      userId,
      status: 'pending',
      totalAmount: 0
    };

    const order = await prisma.order.create({
      data: { ...defaultData, ...overrides }
    });

    if (items.length > 0) {
      await Promise.all(
        items.map(item =>
          prisma.orderItem.create({
            data: {
              orderId: order.id,
              productId: item.productId,
              quantity: item.quantity,
              price: item.price
            }
          })
        )
      );

      // Update total amount
      const totalAmount = items.reduce((sum, item) => sum + (item.price * item.quantity), 0);
      await prisma.order.update({
        where: { id: order.id },
        data: { totalAmount }
      });
    }

    return await prisma.order.findUnique({
      where: { id: order.id },
      include: {
        items: {
          include: {
            product: true
          }
        }
      }
    });
  }
}

async function hashPassword(password) {
  const bcrypt = await import('bcrypt');
  return bcrypt.hash(password, 10);
}

export { prisma };
```

## Related Documentation

- [Authentication](../authentication/README.md) - Authentication testing
- [API Layer](../api/README.md) - API testing strategies
- [Database Layer](../database/README.md) - Database testing
- [State Management](../state-management/README.md) - State testing patterns

## Troubleshooting Integration

When encountering testing issues:
1. Check [troubleshooting.md](./troubleshooting.md) for common solutions
2. Create blocker files in `docs/development/troubleshooting/active-blockers/`
3. Use format: `YYYY-MM-DD_blocker_testing_[framework].md`
4. Reference framework-specific guides for detailed implementation help

---

*Last Updated: 2025-07-10*
*Testing Tools: Jest, Vitest, Cypress, Playwright, Testing Library*
*Framework Support: React, Vue, Angular, Express, Next.js*
