# State Management Documentation

Comprehensive guidelines for implementing client-side and server state management patterns across different frameworks and application architectures.

## Overview

This directory provides standardized patterns for managing application state, including client-side state management, server state synchronization, caching strategies, and framework-specific implementations for React, Vue, Angular, and vanilla JavaScript.

## Quick Reference

### State Types
- **Client State**: UI state, form data, local preferences
- **Server State**: Data fetched from APIs, cached responses
- **Global State**: Application-wide shared state
- **Local State**: Component-specific state

### State Management Solutions
- **React**: Context API, Redux Toolkit, Zustand, TanStack Query
- **Vue**: Vuex, Pinia, Composition API
- **Angular**: NgRx, Akita, Services with RxJS
- **Vanilla JS**: Custom state managers, Observable patterns

## Methodology Approaches

### MVP/Rapid (2-4 weeks)
- Built-in framework state management (React Context, Vue reactive)
- Simple global state for authentication
- Basic API data fetching without caching
- Local storage for persistence

### Balanced/Standard (4-8 weeks)
- Dedicated state management library (Redux Toolkit, Pinia)
- Server state management with caching
- Optimistic updates and error handling
- State persistence and hydration

### Comprehensive/Enterprise (8-12 weeks)
- Advanced state management with middleware
- Complex server state synchronization
- Real-time updates with WebSockets
- State time-travel and debugging tools

## File Structure

```
state-management/
├── README.md                    # This overview file
├── best-practices.md           # State management guidelines
├── common-patterns.md          # Reusable state patterns
├── troubleshooting.md          # Common state issues and solutions
├── client-state.md             # Client-side state management
├── server-state.md             # Server state synchronization
├── caching-strategies.md       # State caching implementation
├── persistence.md              # State persistence patterns
└── framework-guides/
    ├── react-state.md          # React state management
    ├── vue-state.md            # Vue state management
    ├── angular-state.md        # Angular state management
    └── vanilla-state.md        # Vanilla JS state patterns
```

## Client State Management

### React State Patterns
```javascript
// Context API for global state
import { createContext, useContext, useReducer } from 'react';

const AppStateContext = createContext();

const initialState = {
  user: null,
  theme: 'light',
  notifications: [],
  ui: {
    sidebarOpen: false,
    loading: false
  }
};

function appStateReducer(state, action) {
  switch (action.type) {
    case 'SET_USER':
      return { ...state, user: action.payload };
    case 'SET_THEME':
      return { ...state, theme: action.payload };
    case 'ADD_NOTIFICATION':
      return {
        ...state,
        notifications: [...state.notifications, action.payload]
      };
    case 'REMOVE_NOTIFICATION':
      return {
        ...state,
        notifications: state.notifications.filter(n => n.id !== action.payload)
      };
    case 'TOGGLE_SIDEBAR':
      return {
        ...state,
        ui: { ...state.ui, sidebarOpen: !state.ui.sidebarOpen }
      };
    case 'SET_LOADING':
      return {
        ...state,
        ui: { ...state.ui, loading: action.payload }
      };
    default:
      return state;
  }
}

export function AppStateProvider({ children }) {
  const [state, dispatch] = useReducer(appStateReducer, initialState);

  const actions = {
    setUser: (user) => dispatch({ type: 'SET_USER', payload: user }),
    setTheme: (theme) => dispatch({ type: 'SET_THEME', payload: theme }),
    addNotification: (notification) => dispatch({
      type: 'ADD_NOTIFICATION',
      payload: { ...notification, id: Date.now() }
    }),
    removeNotification: (id) => dispatch({ type: 'REMOVE_NOTIFICATION', payload: id }),
    toggleSidebar: () => dispatch({ type: 'TOGGLE_SIDEBAR' }),
    setLoading: (loading) => dispatch({ type: 'SET_LOADING', payload: loading })
  };

  return (
    <AppStateContext.Provider value={{ state, actions }}>
      {children}
    </AppStateContext.Provider>
  );
}

export const useAppState = () => {
  const context = useContext(AppStateContext);
  if (!context) {
    throw new Error('useAppState must be used within AppStateProvider');
  }
  return context;
};
```

### Zustand for Lightweight State
```javascript
// stores/useAppStore.js - Zustand store
import { create } from 'zustand';
import { devtools, persist } from 'zustand/middleware';

const useAppStore = create()(
  devtools(
    persist(
      (set, get) => ({
        // State
        user: null,
        theme: 'light',
        notifications: [],
        ui: {
          sidebarOpen: false,
          loading: false
        },

        // Actions
        setUser: (user) => set({ user }, false, 'setUser'),
        
        setTheme: (theme) => set({ theme }, false, 'setTheme'),
        
        addNotification: (notification) => set(
          (state) => ({
            notifications: [
              ...state.notifications,
              { ...notification, id: Date.now() }
            ]
          }),
          false,
          'addNotification'
        ),
        
        removeNotification: (id) => set(
          (state) => ({
            notifications: state.notifications.filter(n => n.id !== id)
          }),
          false,
          'removeNotification'
        ),
        
        toggleSidebar: () => set(
          (state) => ({
            ui: { ...state.ui, sidebarOpen: !state.ui.sidebarOpen }
          }),
          false,
          'toggleSidebar'
        ),
        
        setLoading: (loading) => set(
          (state) => ({ ui: { ...state.ui, loading } }),
          false,
          'setLoading'
        ),

        // Computed values
        get isAuthenticated() {
          return !!get().user;
        },

        get notificationCount() {
          return get().notifications.length;
        }
      }),
      {
        name: 'app-store',
        partialize: (state) => ({
          user: state.user,
          theme: state.theme
        })
      }
    )
  )
);

export default useAppStore;
```

## Server State Management

### TanStack Query (React Query)
```javascript
// hooks/useUsers.js - Server state management
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { userAPI } from '../services/api';

export function useUsers(params = {}) {
  return useQuery({
    queryKey: ['users', params],
    queryFn: () => userAPI.getUsers(params),
    staleTime: 5 * 60 * 1000, // 5 minutes
    cacheTime: 10 * 60 * 1000, // 10 minutes
    refetchOnWindowFocus: false,
    retry: 3
  });
}

export function useUser(userId) {
  return useQuery({
    queryKey: ['users', userId],
    queryFn: () => userAPI.getUser(userId),
    enabled: !!userId,
    staleTime: 5 * 60 * 1000
  });
}

export function useCreateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: userAPI.createUser,
    onSuccess: (newUser) => {
      // Update users list cache
      queryClient.setQueryData(['users'], (oldData) => {
        if (!oldData) return { data: [newUser], pagination: {} };
        return {
          ...oldData,
          data: [newUser, ...oldData.data]
        };
      });

      // Add to individual user cache
      queryClient.setQueryData(['users', newUser.id], newUser);

      // Show success notification
      queryClient.invalidateQueries(['users']);
    },
    onError: (error) => {
      console.error('Failed to create user:', error);
    }
  });
}

export function useUpdateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, data }) => userAPI.updateUser(id, data),
    onMutate: async ({ id, data }) => {
      // Cancel outgoing refetches
      await queryClient.cancelQueries(['users', id]);

      // Snapshot previous value
      const previousUser = queryClient.getQueryData(['users', id]);

      // Optimistically update
      queryClient.setQueryData(['users', id], (old) => ({
        ...old,
        ...data
      }));

      return { previousUser, id };
    },
    onError: (err, variables, context) => {
      // Rollback on error
      if (context?.previousUser) {
        queryClient.setQueryData(['users', context.id], context.previousUser);
      }
    },
    onSettled: (data, error, variables) => {
      // Always refetch after error or success
      queryClient.invalidateQueries(['users', variables.id]);
    }
  });
}
```

### Vue Pinia Store
```javascript
// stores/users.js - Pinia store for Vue
import { defineStore } from 'pinia';
import { userAPI } from '../services/api';

export const useUsersStore = defineStore('users', {
  state: () => ({
    users: [],
    currentUser: null,
    loading: false,
    error: null,
    pagination: {
      page: 1,
      limit: 10,
      total: 0
    }
  }),

  getters: {
    getUserById: (state) => (id) => {
      return state.users.find(user => user.id === id);
    },

    totalPages: (state) => {
      return Math.ceil(state.pagination.total / state.pagination.limit);
    },

    hasNextPage: (state) => {
      return state.pagination.page < Math.ceil(state.pagination.total / state.pagination.limit);
    }
  },

  actions: {
    async fetchUsers(params = {}) {
      this.loading = true;
      this.error = null;

      try {
        const response = await userAPI.getUsers({
          page: this.pagination.page,
          limit: this.pagination.limit,
          ...params
        });

        this.users = response.data;
        this.pagination = {
          ...this.pagination,
          ...response.pagination
        };
      } catch (error) {
        this.error = error.message;
        console.error('Failed to fetch users:', error);
      } finally {
        this.loading = false;
      }
    },

    async fetchUser(id) {
      // Check if user is already in cache
      const cachedUser = this.getUserById(id);
      if (cachedUser) {
        this.currentUser = cachedUser;
        return cachedUser;
      }

      this.loading = true;
      this.error = null;

      try {
        const user = await userAPI.getUser(id);
        this.currentUser = user;

        // Add to users array if not present
        const existingIndex = this.users.findIndex(u => u.id === id);
        if (existingIndex === -1) {
          this.users.push(user);
        } else {
          this.users[existingIndex] = user;
        }

        return user;
      } catch (error) {
        this.error = error.message;
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async createUser(userData) {
      this.loading = true;
      this.error = null;

      try {
        const newUser = await userAPI.createUser(userData);
        
        // Add to beginning of users array
        this.users.unshift(newUser);
        this.pagination.total += 1;

        return newUser;
      } catch (error) {
        this.error = error.message;
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async updateUser(id, userData) {
      this.loading = true;
      this.error = null;

      // Optimistic update
      const userIndex = this.users.findIndex(u => u.id === id);
      const originalUser = userIndex !== -1 ? { ...this.users[userIndex] } : null;

      if (userIndex !== -1) {
        this.users[userIndex] = { ...this.users[userIndex], ...userData };
      }

      if (this.currentUser?.id === id) {
        this.currentUser = { ...this.currentUser, ...userData };
      }

      try {
        const updatedUser = await userAPI.updateUser(id, userData);
        
        // Update with server response
        if (userIndex !== -1) {
          this.users[userIndex] = updatedUser;
        }

        if (this.currentUser?.id === id) {
          this.currentUser = updatedUser;
        }

        return updatedUser;
      } catch (error) {
        // Rollback optimistic update
        if (originalUser && userIndex !== -1) {
          this.users[userIndex] = originalUser;
        }

        this.error = error.message;
        throw error;
      } finally {
        this.loading = false;
      }
    },

    async deleteUser(id) {
      this.loading = true;
      this.error = null;

      try {
        await userAPI.deleteUser(id);
        
        // Remove from users array
        this.users = this.users.filter(u => u.id !== id);
        this.pagination.total -= 1;

        // Clear current user if it was deleted
        if (this.currentUser?.id === id) {
          this.currentUser = null;
        }
      } catch (error) {
        this.error = error.message;
        throw error;
      } finally {
        this.loading = false;
      }
    },

    setPage(page) {
      this.pagination.page = page;
      this.fetchUsers();
    },

    setLimit(limit) {
      this.pagination.limit = limit;
      this.pagination.page = 1;
      this.fetchUsers();
    },

    clearError() {
      this.error = null;
    },

    reset() {
      this.users = [];
      this.currentUser = null;
      this.loading = false;
      this.error = null;
      this.pagination = {
        page: 1,
        limit: 10,
        total: 0
      };
    }
  }
});
```

## Caching Strategies

### Memory-Based Caching
```javascript
// utils/cache.js - Simple memory cache
class MemoryCache {
  constructor(defaultTTL = 300000) { // 5 minutes default
    this.cache = new Map();
    this.timers = new Map();
    this.defaultTTL = defaultTTL;
  }

  set(key, value, ttl = this.defaultTTL) {
    // Clear existing timer
    if (this.timers.has(key)) {
      clearTimeout(this.timers.get(key));
    }

    // Set value
    this.cache.set(key, {
      value,
      timestamp: Date.now(),
      ttl
    });

    // Set expiration timer
    const timer = setTimeout(() => {
      this.delete(key);
    }, ttl);

    this.timers.set(key, timer);
  }

  get(key) {
    const item = this.cache.get(key);
    
    if (!item) {
      return null;
    }

    // Check if expired
    if (Date.now() - item.timestamp > item.ttl) {
      this.delete(key);
      return null;
    }

    return item.value;
  }

  has(key) {
    return this.get(key) !== null;
  }

  delete(key) {
    if (this.timers.has(key)) {
      clearTimeout(this.timers.get(key));
      this.timers.delete(key);
    }
    
    return this.cache.delete(key);
  }

  clear() {
    // Clear all timers
    for (const timer of this.timers.values()) {
      clearTimeout(timer);
    }
    
    this.cache.clear();
    this.timers.clear();
  }

  size() {
    return this.cache.size;
  }

  keys() {
    return Array.from(this.cache.keys());
  }
}

export const apiCache = new MemoryCache();

// Usage with API calls
export async function getCachedData(key, fetchFn, ttl) {
  // Check cache first
  const cached = apiCache.get(key);
  if (cached) {
    return cached;
  }

  // Fetch and cache
  const data = await fetchFn();
  apiCache.set(key, data, ttl);
  
  return data;
}
```

## State Persistence

### Local Storage Persistence
```javascript
// utils/persistence.js - State persistence utilities
class StatePersistence {
  constructor(key, options = {}) {
    this.key = key;
    this.storage = options.storage || localStorage;
    this.serializer = options.serializer || JSON;
    this.version = options.version || 1;
  }

  save(state) {
    try {
      const data = {
        state,
        version: this.version,
        timestamp: Date.now()
      };
      
      const serialized = this.serializer.stringify(data);
      this.storage.setItem(this.key, serialized);
    } catch (error) {
      console.error('Failed to save state:', error);
    }
  }

  load() {
    try {
      const serialized = this.storage.getItem(this.key);
      
      if (!serialized) {
        return null;
      }

      const data = this.serializer.parse(serialized);
      
      // Check version compatibility
      if (data.version !== this.version) {
        console.warn('State version mismatch, clearing stored state');
        this.clear();
        return null;
      }

      return data.state;
    } catch (error) {
      console.error('Failed to load state:', error);
      this.clear();
      return null;
    }
  }

  clear() {
    try {
      this.storage.removeItem(this.key);
    } catch (error) {
      console.error('Failed to clear state:', error);
    }
  }

  migrate(oldVersion, newVersion, migrationFn) {
    try {
      const serialized = this.storage.getItem(this.key);
      
      if (!serialized) {
        return;
      }

      const data = this.serializer.parse(serialized);
      
      if (data.version === oldVersion) {
        const migratedState = migrationFn(data.state);
        this.version = newVersion;
        this.save(migratedState);
      }
    } catch (error) {
      console.error('Failed to migrate state:', error);
      this.clear();
    }
  }
}

// Usage with Zustand
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

const usePersistedStore = create()(
  persist(
    (set, get) => ({
      // Store implementation
    }),
    {
      name: 'app-store',
      version: 1,
      migrate: (persistedState, version) => {
        if (version === 0) {
          // Migration from version 0 to 1
          return {
            ...persistedState,
            newField: 'defaultValue'
          };
        }
        return persistedState;
      },
      partialize: (state) => ({
        // Only persist specific parts of state
        user: state.user,
        theme: state.theme,
        preferences: state.preferences
      })
    }
  )
);
```

## Related Documentation

- [Authentication](../authentication/README.md) - Authentication state management
- [API Layer](../api/README.md) - Server state integration
- [Database Layer](../database/README.md) - Data persistence
- [Error Handling](../error-handling/README.md) - State error management

## Troubleshooting Integration

When encountering state management issues:
1. Check [troubleshooting.md](./troubleshooting.md) for common solutions
2. Create blocker files in `docs/development/troubleshooting/active-blockers/`
3. Use format: `YYYY-MM-DD_blocker_state_[framework].md`
4. Reference framework-specific guides for detailed implementation help

---

*Last Updated: 2025-07-10*
*Framework Support: React, Vue, Angular, Vanilla JS*
*State Libraries: Redux Toolkit, Zustand, Pinia, TanStack Query*
