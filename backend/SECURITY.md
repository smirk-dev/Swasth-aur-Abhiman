# Security Best Practices

## Overview

This document outlines security measures implemented in the Swastha Aur Abhiman backend.

## Authentication & Authorization

### JWT Security
- **Secret Key**: Minimum 32 characters, stored in environment variables
- **Token Expiration**: 7 days default, configurable
- **Refresh Token**: Implement refresh token rotation (TODO)
- **Token Validation**: Verified on every protected route

### Password Security
- **Hashing**: bcrypt with salt rounds = 10
- **Requirements**: 
  - Minimum 8 characters
  - Must contain uppercase, lowercase, number, special character
- **Storage**: Never stored in plain text

### Role-Based Access Control (RBAC)
- **Roles**: USER, DOCTOR, TEACHER, ADMIN
- **Guards**: `@Roles()` decorator enforces access control
- **Principle of Least Privilege**: Users only get necessary permissions

## Input Validation & Sanitization

### Class Validator
```typescript
@IsEmail()
@IsNotEmpty()
@MinLength(8)
@Matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]/)
```

### Request Validation Pipe
- **Whitelist**: Strip unknown properties
- **ForbidNonWhitelisted**: Reject requests with extra properties
- **Transform**: Auto-transform payloads to DTO instances

## Rate Limiting

### Throttler Configuration
```typescript
ThrottlerModule.forRoot([
  { name: 'short', ttl: 1000, limit: 10 },    // 10 req/sec
  { name: 'medium', ttl: 10000, limit: 100 }, // 100 req/10sec
  { name: 'long', ttl: 60000, limit: 500 },   // 500 req/min
])
```

### Endpoint-Specific Limits
- **Login**: 5 attempts per 15 minutes
- **Registration**: 3 attempts per hour
- **File Upload**: 10 uploads per minute
- **API calls**: 100 requests per minute per user

## Security Headers (Helmet)

### Content Security Policy
```javascript
helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", 'data:', 'https:'],
    },
  },
})
```

### Other Headers
- **X-Frame-Options**: DENY (prevents clickjacking)
- **X-Content-Type-Options**: nosniff
- **Strict-Transport-Security**: max-age=31536000
- **X-XSS-Protection**: 1; mode=block

## CORS Configuration

### Allowed Origins
```typescript
origin: (origin, callback) => {
  const allowedOrigins = process.env.CORS_ORIGINS?.split(',') || [];
  if (allowedOrigins.includes(origin)) {
    return callback(null, true);
  }
  callback(new Error('Not allowed by CORS'));
}
```

### Credentials & Methods
- **Credentials**: true (allows cookies)
- **Methods**: GET, POST, PUT, PATCH, DELETE, OPTIONS
- **Headers**: Content-Type, Authorization, Accept

## Database Security

### SQL Injection Prevention
- **TypeORM**: Uses parameterized queries
- **Query Builder**: Safe from SQL injection
- **Raw Queries**: Avoided, use prepared statements if needed

### Connection Security
```typescript
extra: {
  ssl: process.env.NODE_ENV === 'production' ? {
    rejectUnauthorized: false
  } : false,
}
```

### Password Storage
- **Encryption at Rest**: RDS encryption enabled
- **SSL/TLS**: Required for production connections

## File Upload Security

### Validation
- **File Type**: Whitelist (images, PDFs only)
- **File Size**: 10MB maximum
- **Filename Sanitization**: UUID-based filenames
- **Path Traversal**: Prevented by using absolute paths

### Storage
- **Local**: Restricted directory permissions (755)
- **Cloud (S3)**: Private buckets, signed URLs for access
- **Virus Scanning**: TODO - integrate ClamAV

## Encryption

### Data in Transit
- **HTTPS**: Required in production
- **TLS 1.2+**: Minimum version
- **Certificate**: Valid SSL/TLS certificate

### Data at Rest
- **Database**: RDS encryption enabled
- **S3 Buckets**: Server-side encryption (AES-256)
- **Secrets**: AWS Secrets Manager or encrypted .env

## Logging & Monitoring

### Security Event Logging
```typescript
logger.logAuth('login', userId, success);
logger.error('Unauthorized access attempt', trace, 'Security');
```

### Monitored Events
- Failed login attempts
- Unauthorized access attempts
- File upload operations
- Admin actions
- Database errors
- Rate limit violations

### Log Protection
- **Sensitive Data**: Never log passwords, tokens
- **Log Rotation**: Daily rotation, 14-day retention
- **Access Control**: Restricted to authorized personnel

## Error Handling

### Production Error Responses
```typescript
{
  statusCode: 500,
  timestamp: '2026-01-03T...',
  path: '/api/...',
  message: 'Internal server error'
  // No stack traces in production
}
```

### Development vs Production
- **Development**: Full error details, stack traces
- **Production**: Generic error messages only

## API Security

### Authentication Required
- All endpoints except `/auth/login` and `/auth/register`
- JWT token in Authorization header: `Bearer <token>`

### Input Validation
- All DTOs validated with class-validator
- Type checking with TypeScript
- Request size limits (100kb default)

## Dependency Security

### npm audit
```bash
npm audit
npm audit fix
```

### Regular Updates
- Weekly security updates
- Monthly dependency updates
- Automated vulnerability scanning (Dependabot)

## Environment Variables

### Secrets Management
- **Never commit**: .env files in .gitignore
- **Production**: Use AWS Secrets Manager
- **Development**: .env.example as template

### Required Security Variables
```env
JWT_SECRET=<minimum-32-characters>
DB_PASSWORD=<strong-password>
AWS_SECRET_ACCESS_KEY=<aws-secret>
REDIS_PASSWORD=<redis-password>
```

## Incident Response

### Security Breach Protocol
1. **Detect**: Monitor logs and alerts
2. **Contain**: Disable compromised accounts
3. **Investigate**: Analyze logs and traces
4. **Recover**: Restore from backups if needed
5. **Document**: Record incident details
6. **Improve**: Update security measures

### Contact
- **Security Team**: security@yourcompany.com
- **On-Call**: Available 24/7

## Compliance

### Data Protection
- **GDPR**: User data deletion on request
- **Data Minimization**: Collect only necessary data
- **Right to Access**: Users can export their data

### Audit Trail
- All admin actions logged
- User activity tracked
- Changes to sensitive data recorded

## Security Checklist

- [x] JWT authentication implemented
- [x] Password hashing with bcrypt
- [x] Rate limiting configured
- [x] Helmet security headers
- [x] CORS properly configured
- [x] Input validation on all endpoints
- [x] SQL injection prevention (TypeORM)
- [x] File upload validation
- [x] Error handling (no sensitive data leak)
- [x] Logging & monitoring
- [ ] Refresh token rotation
- [ ] Two-factor authentication (2FA)
- [ ] Virus scanning for uploads
- [ ] Automated security testing
- [ ] Penetration testing
- [ ] Security awareness training

## Regular Security Tasks

### Daily
- Monitor error logs
- Check failed login attempts
- Review system alerts

### Weekly
- Run `npm audit`
- Review access logs
- Check rate limit violations

### Monthly
- Update dependencies
- Review user permissions
- Security patches
- Backup testing

### Quarterly
- Full security audit
- Penetration testing
- Security training
- Policy review
