import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from './../src/app.module';
import { UserRole } from '../src/common/enums/user.enum';

describe('AuthController (e2e)', () => {
  let app: INestApplication;
  let authToken: string;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('/auth/register (POST)', () => {
    it('should register a new user', () => {
      return request(app.getHttpServer())
        .post('/auth/register')
        .send({
          email: `test-${Date.now()}@example.com`,
          password: 'TestPassword123!',
          fullName: 'Test User',
          phone: '1234567890',
          role: UserRole.USER,
        })
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('accessToken');
          expect(res.body).toHaveProperty('user');
          expect(res.body.user.email).toBeDefined();
        });
    });

    it('should fail with invalid email', () => {
      return request(app.getHttpServer())
        .post('/auth/register')
        .send({
          email: 'invalid-email',
          password: 'TestPassword123!',
          fullName: 'Test User',
        })
        .expect(400);
    });

    it('should fail with weak password', () => {
      return request(app.getHttpServer())
        .post('/auth/register')
        .send({
          email: 'test@example.com',
          password: '123',
          fullName: 'Test User',
        })
        .expect(400);
    });
  });

  describe('/auth/login (POST)', () => {
    const testUser = {
      email: `login-test-${Date.now()}@example.com`,
      password: 'TestPassword123!',
      fullName: 'Login Test User',
      phone: '9876543210',
      role: UserRole.USER,
    };

    beforeAll(async () => {
      // Create test user
      await request(app.getHttpServer())
        .post('/auth/register')
        .send(testUser);
    });

    it('should login with valid credentials', () => {
      return request(app.getHttpServer())
        .post('/auth/login')
        .send({
          email: testUser.email,
          password: testUser.password,
        })
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('accessToken');
          authToken = res.body.accessToken;
        });
    });

    it('should fail with invalid password', () => {
      return request(app.getHttpServer())
        .post('/auth/login')
        .send({
          email: testUser.email,
          password: 'WrongPassword123!',
        })
        .expect(401);
    });

    it('should fail with non-existent email', () => {
      return request(app.getHttpServer())
        .post('/auth/login')
        .send({
          email: 'nonexistent@example.com',
          password: 'TestPassword123!',
        })
        .expect(401);
    });
  });

  describe('/auth/profile (GET)', () => {
    let userToken: string;
    const profileUser = {
      email: `profile-test-${Date.now()}@example.com`,
      password: 'TestPassword123!',
      fullName: 'Profile Test User',
      phone: '5555555555',
      role: UserRole.USER,
    };

    beforeAll(async () => {
      const response = await request(app.getHttpServer())
        .post('/auth/register')
        .send(profileUser);
      userToken = response.body.accessToken;
    });

    it('should get user profile with valid token', () => {
      return request(app.getHttpServer())
        .get('/auth/profile')
        .set('Authorization', `Bearer ${userToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body.email).toBe(profileUser.email);
          expect(res.body.fullName).toBe(profileUser.fullName);
        });
    });

    it('should fail without auth token', () => {
      return request(app.getHttpServer())
        .get('/auth/profile')
        .expect(401);
    });

    it('should fail with invalid token', () => {
      return request(app.getHttpServer())
        .get('/auth/profile')
        .set('Authorization', 'Bearer invalid-token')
        .expect(401);
    });
  });
});
