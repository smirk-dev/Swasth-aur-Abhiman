# Testing Guide

## Overview

Comprehensive testing strategy for the Swastha Aur Abhiman backend API.

## Test Structure

```
backend/
├── src/
│   ├── auth/
│   │   └── auth.service.spec.ts          # Unit tests
│   ├── health/
│   │   └── health.service.spec.ts        # Unit tests
│   └── admin/
│       └── admin.service.spec.ts         # Unit tests
└── test/
    ├── jest-e2e.json                      # E2E test configuration
    ├── auth.e2e-spec.ts                   # Auth E2E tests
    └── health.e2e-spec.ts                 # Health E2E tests
```

## Running Tests

### Unit Tests
```bash
# Run all unit tests
npm test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:cov

# Run specific test file
npm test -- auth.service.spec.ts
```

### E2E Tests
```bash
# Run all E2E tests
npm run test:e2e

# Run specific E2E test
npm run test:e2e -- auth.e2e-spec.ts
```

### Load Tests
```bash
# Run load test
npm run load-test

# Run load test with report
npm run load-test:report
```

## Unit Testing

### AuthService Tests

#### Test Cases Covered:
- ✅ User registration with valid data
- ✅ Duplicate email rejection (ConflictException)
- ✅ Login with valid credentials
- ✅ Login with invalid credentials (UnauthorizedException)
- ✅ Inactive user login rejection
- ✅ User validation by ID

#### Example:
```typescript
describe('register', () => {
  it('should successfully register a new user', async () => {
    const registerDto = {
      email: 'test@example.com',
      password: 'password123',
      fullName: 'Test User',
      role: UserRole.USER,
    };
    
    const result = await service.register(registerDto);
    expect(result).toHaveProperty('accessToken');
  });
});
```

### HealthService Tests

#### Test Cases Covered:
- ✅ Recording health metrics
- ✅ Blood pressure condition evaluation
- ✅ Blood sugar condition evaluation
- ✅ BMI condition evaluation
- ✅ Paginated metrics retrieval
- ✅ Health summary generation with trends
- ✅ Health session recording
- ✅ Personalized recommendations

### AdminService Tests

#### Test Cases Covered:
- ✅ Paginated user listing
- ✅ User filtering by role
- ✅ User status updates (activate/deactivate)
- ✅ User statistics calculation
- ✅ User deletion
- ✅ Error handling for non-existent users

## E2E Testing

### AuthController E2E Tests

#### Test Suites:
1. **POST /auth/register**
   - ✅ Register new user successfully
   - ✅ Invalid email format rejection
   - ✅ Weak password rejection

2. **POST /auth/login**
   - ✅ Login with valid credentials
   - ✅ Invalid password rejection
   - ✅ Non-existent email rejection

3. **GET /auth/profile**
   - ✅ Get profile with valid token
   - ✅ Unauthorized without token
   - ✅ Invalid token rejection

### HealthController E2E Tests

#### Test Suites:
1. **POST /health/metrics**
   - ✅ Record blood sugar metric
   - ✅ Record blood pressure metric
   - ✅ Unauthorized without token
   - ✅ Invalid metric type rejection

2. **GET /health/metrics**
   - ✅ Get all user metrics
   - ✅ Filter by metric type
   - ✅ Pagination support

3. **GET /health/summary**
   - ✅ Get health summary with trends
   - ✅ Unauthorized without token

4. **POST /health/sessions**
   - ✅ Record complete health session

5. **GET /health/recommendations**
   - ✅ Get personalized recommendations

## Load Testing

### Artillery Configuration

#### Test Phases:
1. **Warm up** (60s): 10 requests/sec
2. **Ramp up** (120s): 50 requests/sec
3. **Sustained load** (180s): 100 requests/sec
4. **Spike test** (60s): 200 requests/sec

### Test Scenarios

#### 1. User Authentication Flow (30% weight)
```yaml
- Register new user
- Login
- Get profile
```

#### 2. Health Metrics Recording (25% weight)
```yaml
- Login
- Record blood sugar metric
- Get metrics list
- Get health summary
```

#### 3. Content Browsing (20% weight)
```yaml
- Browse education videos
- Browse training modules
- Browse nutrition recipes
```

#### 4. Doctor Consultation (15% weight)
```yaml
- Doctor login
- View appointments
- View patients
```

#### 5. Admin Operations (10% weight)
```yaml
- Admin login
- List users
- View analytics
```

### Performance Targets

| Metric | Target | Critical |
|--------|--------|----------|
| Response time (p50) | < 200ms | < 500ms |
| Response time (p95) | < 500ms | < 1000ms |
| Response time (p99) | < 1000ms | < 2000ms |
| Throughput | > 100 req/s | > 50 req/s |
| Error rate | < 0.1% | < 1% |
| CPU usage | < 70% | < 90% |
| Memory usage | < 80% | < 95% |

## Integration Testing

### Database Integration
```typescript
beforeAll(async () => {
  // Setup test database
  const module = await Test.createTestingModule({
    imports: [AppModule],
  }).compile();
  
  app = module.createNestApplication();
  await app.init();
});

afterAll(async () => {
  await app.close();
});
```

### WebSocket Integration
```typescript
describe('ChatGateway', () => {
  it('should connect and send messages', (done) => {
    const socket = io('http://localhost:3000');
    
    socket.on('connect', () => {
      socket.emit('sendMessage', { message: 'Hello' });
    });
    
    socket.on('message', (data) => {
      expect(data).toHaveProperty('message', 'Hello');
      socket.disconnect();
      done();
    });
  });
});
```

## Mocking

### Repository Mocking
```typescript
const mockRepository = {
  find: jest.fn(),
  findOne: jest.fn(),
  create: jest.fn(),
  save: jest.fn(),
  update: jest.fn(),
  delete: jest.fn(),
};
```

### Service Mocking
```typescript
const mockAuthService = {
  validateUser: jest.fn(),
  login: jest.fn(),
  register: jest.fn(),
};
```

## Code Coverage

### Coverage Targets
- **Statements**: > 80%
- **Branches**: > 75%
- **Functions**: > 80%
- **Lines**: > 80%

### Generate Coverage Report
```bash
npm run test:cov
```

Coverage report will be in `coverage/lcov-report/index.html`.

### CI Integration
Coverage is automatically uploaded to Codecov on every push.

## Test Data

### Factories
```typescript
const userFactory = {
  createUser: (override = {}) => ({
    email: 'test@example.com',
    password: 'TestPassword123!',
    fullName: 'Test User',
    role: UserRole.USER,
    ...override,
  }),
};
```

### Fixtures
```typescript
const fixtures = {
  validUser: {
    email: 'valid@example.com',
    password: 'ValidPassword123!',
    fullName: 'Valid User',
  },
  invalidUser: {
    email: 'invalid-email',
    password: '123',
  },
};
```

## Continuous Testing

### Pre-commit Hook
```bash
# Install husky
npm install --save-dev husky

# Add pre-commit hook
npx husky add .husky/pre-commit "npm test"
```

### CI Pipeline
```yaml
- name: Run unit tests
  run: npm test
  
- name: Run E2E tests
  run: npm run test:e2e
  
- name: Generate coverage
  run: npm run test:cov
```

## Debugging Tests

### VS Code Configuration
```json
{
  "type": "node",
  "request": "launch",
  "name": "Jest Debug",
  "program": "${workspaceFolder}/node_modules/.bin/jest",
  "args": ["--runInBand", "--no-cache"],
  "console": "integratedTerminal"
}
```

### Debug Specific Test
```bash
npm run test:debug -- auth.service.spec.ts
```

## Best Practices

### 1. Test Isolation
- Each test should be independent
- Use `beforeEach` to reset state
- Clean up after tests in `afterEach`

### 2. Descriptive Names
```typescript
describe('AuthService', () => {
  describe('register', () => {
    it('should successfully register a new user with valid data', ...);
    it('should throw ConflictException when email already exists', ...);
  });
});
```

### 3. Arrange-Act-Assert
```typescript
it('should login user', async () => {
  // Arrange
  const loginDto = { email: 'test@example.com', password: 'pass' };
  
  // Act
  const result = await service.login(loginDto);
  
  // Assert
  expect(result).toHaveProperty('accessToken');
});
```

### 4. Mock External Dependencies
- Mock HTTP calls
- Mock database queries
- Mock file system operations

### 5. Test Edge Cases
- Empty inputs
- Null/undefined values
- Invalid data types
- Boundary conditions
- Error scenarios

## Test Maintenance

### Regular Updates
- Update tests when features change
- Refactor duplicate test code
- Remove obsolete tests
- Keep test data current

### Code Review
- All PRs must include tests
- Maintain code coverage
- Review test quality
- Check for flaky tests

## Common Issues

### 1. Timeout Errors
```typescript
// Increase timeout for slow tests
jest.setTimeout(30000);
```

### 2. Database Connection
```typescript
// Ensure proper cleanup
afterAll(async () => {
  await connection.close();
});
```

### 3. Async Issues
```typescript
// Always await async operations
await expect(service.someMethod()).resolves.toBeTruthy();
```

## Performance Testing Checklist

- [ ] Run load tests before deployment
- [ ] Monitor response times
- [ ] Check error rates
- [ ] Verify database performance
- [ ] Test concurrent users
- [ ] Measure throughput
- [ ] Check memory leaks
- [ ] Test under sustained load
- [ ] Verify auto-scaling
- [ ] Document performance metrics

## Security Testing

### Authentication Tests
- [ ] Unauthorized access blocked
- [ ] Invalid tokens rejected
- [ ] Expired tokens handled
- [ ] Role-based access enforced

### Input Validation Tests
- [ ] SQL injection prevented
- [ ] XSS attacks blocked
- [ ] File upload validation
- [ ] Request size limits enforced

### Rate Limiting Tests
- [ ] Rate limits enforced
- [ ] Multiple accounts tested
- [ ] Burst traffic handled
- [ ] DDoS mitigation verified

## Resources

- [Jest Documentation](https://jestjs.io/docs/getting-started)
- [NestJS Testing](https://docs.nestjs.com/fundamentals/testing)
- [Artillery Documentation](https://www.artillery.io/docs)
- [Supertest Documentation](https://github.com/visionmedia/supertest)
