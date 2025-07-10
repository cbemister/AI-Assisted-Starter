# Error Handling & Logging Documentation

Comprehensive guidelines for implementing robust error handling, logging strategies, and monitoring systems across different application layers and frameworks.

## Overview

This directory provides standardized patterns for managing errors, implementing logging systems, integrating error tracking services, and creating user-friendly error experiences. Covers both client-side and server-side error handling strategies.

## Quick Reference

### Error Types
- **Application Errors**: Business logic and validation errors
- **System Errors**: Infrastructure and runtime errors
- **Network Errors**: API and connectivity issues
- **User Errors**: Input validation and permission errors

### Error Handling Strategies
- **Global Error Boundaries**: Catch-all error handling
- **Specific Error Handling**: Targeted error management
- **Error Recovery**: Graceful degradation and retry logic
- **User Feedback**: Meaningful error messages

## Methodology Approaches

### MVP/Rapid (2-4 weeks)
- Basic try-catch error handling
- Console logging for development
- Simple error messages for users
- Basic error boundaries in React

### Balanced/Standard (4-8 weeks)
- Structured error handling with custom error classes
- Comprehensive logging with levels
- Error tracking service integration
- User-friendly error UI components

### Comprehensive/Enterprise (8-12 weeks)
- Advanced error monitoring and alerting
- Distributed tracing and correlation
- Error analytics and reporting
- Automated error recovery systems

## File Structure

```
error-handling/
├── README.md                    # This overview file
├── best-practices.md           # Error handling guidelines
├── common-patterns.md          # Reusable error patterns
├── troubleshooting.md          # Error handling issues and solutions
├── global-error-handling.md    # Application-wide error management
├── logging-strategies.md       # Logging implementation patterns
├── error-tracking.md           # Error monitoring integration
├── user-experience.md          # User-friendly error messaging
└── framework-guides/
    ├── react-errors.md         # React error handling
    ├── vue-errors.md           # Vue error handling
    ├── angular-errors.md       # Angular error handling
    ├── express-errors.md       # Express.js error handling
    └── nextjs-errors.md        # Next.js error handling
```

## Global Error Handling

### React Error Boundaries
```javascript
// components/ErrorBoundary.jsx
import React from 'react';
import { logError } from '../services/errorLogger';

class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null, errorInfo: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true };
  }

  componentDidCatch(error, errorInfo) {
    this.setState({
      error,
      errorInfo
    });

    // Log error to monitoring service
    logError(error, {
      componentStack: errorInfo.componentStack,
      errorBoundary: this.constructor.name,
      props: this.props,
      timestamp: new Date().toISOString()
    });
  }

  handleRetry = () => {
    this.setState({ hasError: false, error: null, errorInfo: null });
  };

  render() {
    if (this.state.hasError) {
      if (this.props.fallback) {
        return this.props.fallback(this.state.error, this.handleRetry);
      }

      return (
        <div className="error-boundary">
          <h2>Something went wrong</h2>
          <p>We're sorry, but something unexpected happened.</p>
          
          {process.env.NODE_ENV === 'development' && (
            <details style={{ whiteSpace: 'pre-wrap', marginTop: '1rem' }}>
              <summary>Error Details (Development Only)</summary>
              <p><strong>Error:</strong> {this.state.error && this.state.error.toString()}</p>
              <p><strong>Component Stack:</strong></p>
              <code>{this.state.errorInfo.componentStack}</code>
            </details>
          )}
          
          <button onClick={this.handleRetry} className="retry-button">
            Try Again
          </button>
        </div>
      );
    }

    return this.props.children;
  }
}

// Higher-order component for error boundaries
export function withErrorBoundary(Component, errorFallback) {
  return function WrappedComponent(props) {
    return (
      <ErrorBoundary fallback={errorFallback}>
        <Component {...props} />
      </ErrorBoundary>
    );
  };
}

export default ErrorBoundary;
```

### Express.js Error Handling
```javascript
// middleware/errorHandler.js
const { logError } = require('../services/errorLogger');

class AppError extends Error {
  constructor(message, statusCode = 500, code = 'INTERNAL_ERROR', isOperational = true) {
    super(message);
    this.statusCode = statusCode;
    this.code = code;
    this.isOperational = isOperational;
    this.name = 'AppError';
    
    Error.captureStackTrace(this, this.constructor);
  }
}

class ValidationError extends AppError {
  constructor(message, field = null) {
    super(message, 400, 'VALIDATION_ERROR');
    this.field = field;
  }
}

class NotFoundError extends AppError {
  constructor(resource = 'Resource') {
    super(`${resource} not found`, 404, 'NOT_FOUND');
  }
}

class UnauthorizedError extends AppError {
  constructor(message = 'Unauthorized') {
    super(message, 401, 'UNAUTHORIZED');
  }
}

// Global error handling middleware
function errorHandler(error, req, res, next) {
  let statusCode = 500;
  let code = 'INTERNAL_ERROR';
  let message = 'Internal server error';
  let details = null;

  // Handle known error types
  if (error instanceof AppError) {
    statusCode = error.statusCode;
    code = error.code;
    message = error.message;
    
    if (error instanceof ValidationError && error.field) {
      details = { field: error.field };
    }
  } else if (error.name === 'ValidationError') {
    // Mongoose validation error
    statusCode = 400;
    code = 'VALIDATION_ERROR';
    message = 'Validation failed';
    details = Object.keys(error.errors).map(key => ({
      field: key,
      message: error.errors[key].message
    }));
  } else if (error.code === 11000) {
    // MongoDB duplicate key error
    statusCode = 409;
    code = 'DUPLICATE_ERROR';
    message = 'Resource already exists';
  } else if (error.name === 'CastError') {
    // MongoDB cast error
    statusCode = 400;
    code = 'INVALID_ID';
    message = 'Invalid ID format';
  }

  // Log error
  const errorLog = {
    error: {
      message: error.message,
      stack: error.stack,
      name: error.name,
      code: error.code
    },
    request: {
      method: req.method,
      url: req.url,
      headers: req.headers,
      body: req.body,
      params: req.params,
      query: req.query,
      ip: req.ip,
      userAgent: req.get('User-Agent')
    },
    user: req.user ? { id: req.user.id, email: req.user.email } : null,
    timestamp: new Date().toISOString()
  };

  // Log based on severity
  if (statusCode >= 500) {
    logError(error, errorLog);
  } else {
    console.warn('Client Error:', errorLog);
  }

  // Send error response
  const response = {
    error: {
      message,
      code,
      timestamp: new Date().toISOString(),
      path: req.path
    }
  };

  if (details) {
    response.error.details = details;
  }

  // Include stack trace in development
  if (process.env.NODE_ENV === 'development') {
    response.error.stack = error.stack;
  }

  res.status(statusCode).json(response);
}

// 404 handler
function notFoundHandler(req, res, next) {
  const error = new NotFoundError(`Route ${req.originalUrl} not found`);
  next(error);
}

module.exports = {
  AppError,
  ValidationError,
  NotFoundError,
  UnauthorizedError,
  errorHandler,
  notFoundHandler
};
```

## Logging Strategies

### Structured Logging Service
```javascript
// services/logger.js
const winston = require('winston');

// Custom log levels
const logLevels = {
  error: 0,
  warn: 1,
  info: 2,
  http: 3,
  debug: 4
};

const logColors = {
  error: 'red',
  warn: 'yellow',
  info: 'green',
  http: 'magenta',
  debug: 'blue'
};

winston.addColors(logColors);

// Create logger instance
const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  levels: logLevels,
  format: winston.format.combine(
    winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: {
    service: process.env.SERVICE_NAME || 'app',
    version: process.env.APP_VERSION || '1.0.0',
    environment: process.env.NODE_ENV || 'development'
  },
  transports: [
    // Error log file
    new winston.transports.File({
      filename: 'logs/error.log',
      level: 'error',
      maxsize: 5242880, // 5MB
      maxFiles: 5
    }),
    
    // Combined log file
    new winston.transports.File({
      filename: 'logs/combined.log',
      maxsize: 5242880,
      maxFiles: 5
    })
  ]
});

// Console transport for development
if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
    format: winston.format.combine(
      winston.format.colorize({ all: true }),
      winston.format.simple()
    )
  }));
}

// Production transports
if (process.env.NODE_ENV === 'production') {
  // Add cloud logging transport (e.g., CloudWatch, Stackdriver)
  if (process.env.CLOUDWATCH_LOG_GROUP) {
    const CloudWatchTransport = require('winston-cloudwatch');
    logger.add(new CloudWatchTransport({
      logGroupName: process.env.CLOUDWATCH_LOG_GROUP,
      logStreamName: `${process.env.SERVICE_NAME}-${new Date().toISOString().split('T')[0]}`,
      awsRegion: process.env.AWS_REGION
    }));
  }
}

// Logging utility functions
class Logger {
  static error(message, meta = {}) {
    logger.error(message, meta);
  }

  static warn(message, meta = {}) {
    logger.warn(message, meta);
  }

  static info(message, meta = {}) {
    logger.info(message, meta);
  }

  static http(message, meta = {}) {
    logger.http(message, meta);
  }

  static debug(message, meta = {}) {
    logger.debug(message, meta);
  }

  static logRequest(req, res, responseTime) {
    const logData = {
      method: req.method,
      url: req.url,
      statusCode: res.statusCode,
      responseTime: `${responseTime}ms`,
      userAgent: req.get('User-Agent'),
      ip: req.ip,
      userId: req.user?.id
    };

    if (res.statusCode >= 400) {
      this.warn('HTTP Request Error', logData);
    } else {
      this.http('HTTP Request', logData);
    }
  }

  static logError(error, context = {}) {
    const errorData = {
      message: error.message,
      stack: error.stack,
      name: error.name,
      code: error.code,
      ...context
    };

    this.error('Application Error', errorData);
  }

  static logUserAction(action, userId, details = {}) {
    this.info('User Action', {
      action,
      userId,
      timestamp: new Date().toISOString(),
      ...details
    });
  }

  static logPerformance(operation, duration, metadata = {}) {
    this.info('Performance Metric', {
      operation,
      duration: `${duration}ms`,
      timestamp: new Date().toISOString(),
      ...metadata
    });
  }
}

module.exports = Logger;
```

## Error Tracking Integration

### Sentry Integration
```javascript
// services/errorTracking.js
import * as Sentry from '@sentry/node';
import * as Tracing from '@sentry/tracing';

// Initialize Sentry
export function initializeErrorTracking() {
  Sentry.init({
    dsn: process.env.SENTRY_DSN,
    environment: process.env.NODE_ENV,
    release: process.env.APP_VERSION,
    
    // Performance monitoring
    tracesSampleRate: process.env.NODE_ENV === 'production' ? 0.1 : 1.0,
    
    // Error filtering
    beforeSend(event, hint) {
      // Filter out known non-critical errors
      const error = hint.originalException;
      
      if (error && error.message) {
        // Skip network errors in development
        if (process.env.NODE_ENV === 'development' && 
            error.message.includes('Network Error')) {
          return null;
        }
        
        // Skip specific error types
        const skipErrors = [
          'ResizeObserver loop limit exceeded',
          'Non-Error promise rejection captured'
        ];
        
        if (skipErrors.some(skip => error.message.includes(skip))) {
          return null;
        }
      }
      
      return event;
    },
    
    // Additional integrations
    integrations: [
      new Tracing.Integrations.Express({ app: require('../app') }),
      new Tracing.Integrations.Mysql(),
      new Tracing.Integrations.Postgres()
    ]
  });
}

// Error tracking utilities
export class ErrorTracker {
  static captureException(error, context = {}) {
    Sentry.withScope((scope) => {
      // Add context
      if (context.user) {
        scope.setUser(context.user);
      }
      
      if (context.tags) {
        Object.keys(context.tags).forEach(key => {
          scope.setTag(key, context.tags[key]);
        });
      }
      
      if (context.extra) {
        Object.keys(context.extra).forEach(key => {
          scope.setExtra(key, context.extra[key]);
        });
      }
      
      if (context.level) {
        scope.setLevel(context.level);
      }
      
      Sentry.captureException(error);
    });
  }

  static captureMessage(message, level = 'info', context = {}) {
    Sentry.withScope((scope) => {
      if (context.user) {
        scope.setUser(context.user);
      }
      
      if (context.tags) {
        Object.keys(context.tags).forEach(key => {
          scope.setTag(key, context.tags[key]);
        });
      }
      
      scope.setLevel(level);
      Sentry.captureMessage(message);
    });
  }

  static addBreadcrumb(message, category = 'default', level = 'info', data = {}) {
    Sentry.addBreadcrumb({
      message,
      category,
      level,
      data,
      timestamp: Date.now() / 1000
    });
  }

  static setUser(user) {
    Sentry.setUser({
      id: user.id,
      email: user.email,
      username: user.username
    });
  }

  static setTag(key, value) {
    Sentry.setTag(key, value);
  }

  static setContext(key, context) {
    Sentry.setContext(key, context);
  }

  static startTransaction(name, operation) {
    return Sentry.startTransaction({ name, op: operation });
  }
}

// Express middleware for Sentry
export const sentryRequestHandler = Sentry.Handlers.requestHandler();
export const sentryTracingHandler = Sentry.Handlers.tracingHandler();
export const sentryErrorHandler = Sentry.Handlers.errorHandler();
```

## User-Friendly Error Messages

### Error Message Components
```javascript
// components/ErrorMessage.jsx
import React from 'react';
import { AlertTriangle, RefreshCw, Home, Mail } from 'lucide-react';

const errorMessages = {
  NETWORK_ERROR: {
    title: 'Connection Problem',
    message: 'Please check your internet connection and try again.',
    icon: AlertTriangle,
    actions: ['retry']
  },
  VALIDATION_ERROR: {
    title: 'Invalid Information',
    message: 'Please check the information you entered and try again.',
    icon: AlertTriangle,
    actions: ['retry']
  },
  UNAUTHORIZED: {
    title: 'Access Denied',
    message: 'You need to sign in to access this feature.',
    icon: AlertTriangle,
    actions: ['login']
  },
  NOT_FOUND: {
    title: 'Page Not Found',
    message: 'The page you\'re looking for doesn\'t exist or has been moved.',
    icon: AlertTriangle,
    actions: ['home']
  },
  SERVER_ERROR: {
    title: 'Something Went Wrong',
    message: 'We\'re experiencing technical difficulties. Please try again later.',
    icon: AlertTriangle,
    actions: ['retry', 'contact']
  }
};

export function ErrorMessage({ 
  error, 
  onRetry, 
  onHome, 
  onLogin, 
  onContact,
  className = '' 
}) {
  const errorConfig = errorMessages[error?.code] || errorMessages.SERVER_ERROR;
  const Icon = errorConfig.icon;

  const handleAction = (action) => {
    switch (action) {
      case 'retry':
        onRetry?.();
        break;
      case 'home':
        onHome?.();
        break;
      case 'login':
        onLogin?.();
        break;
      case 'contact':
        onContact?.();
        break;
    }
  };

  return (
    <div className={`error-message ${className}`}>
      <div className="error-icon">
        <Icon size={48} />
      </div>
      
      <h3 className="error-title">{errorConfig.title}</h3>
      <p className="error-description">{errorConfig.message}</p>
      
      {error?.details && (
        <div className="error-details">
          <p className="error-details-text">{error.details}</p>
        </div>
      )}
      
      <div className="error-actions">
        {errorConfig.actions.includes('retry') && (
          <button 
            onClick={() => handleAction('retry')}
            className="error-action-button primary"
          >
            <RefreshCw size={16} />
            Try Again
          </button>
        )}
        
        {errorConfig.actions.includes('home') && (
          <button 
            onClick={() => handleAction('home')}
            className="error-action-button secondary"
          >
            <Home size={16} />
            Go Home
          </button>
        )}
        
        {errorConfig.actions.includes('login') && (
          <button 
            onClick={() => handleAction('login')}
            className="error-action-button primary"
          >
            Sign In
          </button>
        )}
        
        {errorConfig.actions.includes('contact') && (
          <button 
            onClick={() => handleAction('contact')}
            className="error-action-button secondary"
          >
            <Mail size={16} />
            Contact Support
          </button>
        )}
      </div>
    </div>
  );
}

// Error page component
export function ErrorPage({ error, onRetry }) {
  return (
    <div className="error-page">
      <div className="error-container">
        <ErrorMessage 
          error={error}
          onRetry={onRetry}
          onHome={() => window.location.href = '/'}
          onLogin={() => window.location.href = '/login'}
          onContact={() => window.location.href = '/contact'}
        />
      </div>
    </div>
  );
}
```

## Related Documentation

- [Authentication](../authentication/README.md) - Authentication error handling
- [API Layer](../api/README.md) - API error responses
- [Database Layer](../database/README.md) - Database error handling
- [State Management](../state-management/README.md) - State error management

## Troubleshooting Integration

When encountering error handling issues:
1. Check [troubleshooting.md](./troubleshooting.md) for common solutions
2. Create blocker files in `docs/development/troubleshooting/active-blockers/`
3. Use format: `YYYY-MM-DD_blocker_error_[framework].md`
4. Reference framework-specific guides for detailed implementation help

---

*Last Updated: 2025-07-10*
*Framework Support: React, Vue, Angular, Express, Next.js*
*Error Tracking: Sentry, LogRocket, Bugsnag*
