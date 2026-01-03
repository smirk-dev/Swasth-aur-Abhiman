import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from './../src/app.module';
import { UserRole } from '../src/common/enums/user.enum';

describe('HealthController (e2e)', () => {
  let app: INestApplication;
  let authToken: string;
  let userId: string;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));
    await app.init();

    // Create and login test user
    const registerResponse = await request(app.getHttpServer())
      .post('/auth/register')
      .send({
        email: `health-test-${Date.now()}@example.com`,
        password: 'TestPassword123!',
        fullName: 'Health Test User',
        phone: '1234567890',
        role: UserRole.USER,
      });
    
    authToken = registerResponse.body.accessToken;
    userId = registerResponse.body.user.id;
  });

  afterAll(async () => {
    await app.close();
  });

  describe('/health/metrics (POST)', () => {
    it('should record blood sugar metric', () => {
      return request(app.getHttpServer())
        .post('/health/metrics')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          metricType: 'BLOOD_SUGAR',
          value: 110,
          unit: 'mg/dL',
          notes: 'After breakfast',
        })
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('id');
          expect(res.body.metricType).toBe('BLOOD_SUGAR');
          expect(res.body.value).toBe(110);
        });
    });

    it('should record blood pressure metric', () => {
      return request(app.getHttpServer())
        .post('/health/metrics')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          metricType: 'BP_SYSTOLIC',
          value: 120,
          unit: 'mmHg',
        })
        .expect(201);
    });

    it('should fail without authentication', () => {
      return request(app.getHttpServer())
        .post('/health/metrics')
        .send({
          metricType: 'BLOOD_SUGAR',
          value: 110,
          unit: 'mg/dL',
        })
        .expect(401);
    });

    it('should fail with invalid metric type', () => {
      return request(app.getHttpServer())
        .post('/health/metrics')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          metricType: 'INVALID_TYPE',
          value: 110,
          unit: 'mg/dL',
        })
        .expect(400);
    });
  });

  describe('/health/metrics (GET)', () => {
    beforeAll(async () => {
      // Create multiple metrics
      await request(app.getHttpServer())
        .post('/health/metrics')
        .set('Authorization', `Bearer ${authToken}`)
        .send({ metricType: 'BLOOD_SUGAR', value: 95, unit: 'mg/dL' });
      
      await request(app.getHttpServer())
        .post('/health/metrics')
        .set('Authorization', `Bearer ${authToken}`)
        .send({ metricType: 'BP_SYSTOLIC', value: 125, unit: 'mmHg' });
    });

    it('should get all metrics for user', () => {
      return request(app.getHttpServer())
        .get('/health/metrics')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('data');
          expect(Array.isArray(res.body.data)).toBe(true);
          expect(res.body.data.length).toBeGreaterThan(0);
        });
    });

    it('should filter metrics by type', () => {
      return request(app.getHttpServer())
        .get('/health/metrics?metricType=BLOOD_SUGAR')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body.data.every(m => m.metricType === 'BLOOD_SUGAR')).toBe(true);
        });
    });

    it('should paginate metrics', () => {
      return request(app.getHttpServer())
        .get('/health/metrics?page=1&limit=5')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('page', 1);
          expect(res.body).toHaveProperty('limit', 5);
          expect(res.body).toHaveProperty('total');
        });
    });
  });

  describe('/health/summary (GET)', () => {
    it('should get health summary', () => {
      return request(app.getHttpServer())
        .get('/health/summary')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('latestMetrics');
          expect(res.body).toHaveProperty('trends');
          expect(res.body).toHaveProperty('averages');
        });
    });

    it('should fail without authentication', () => {
      return request(app.getHttpServer())
        .get('/health/summary')
        .expect(401);
    });
  });

  describe('/health/sessions (POST)', () => {
    it('should record health session', () => {
      return request(app.getHttpServer())
        .post('/health/sessions')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          date: '2026-01-03',
          bpSystolic: 120,
          bpDiastolic: 80,
          bloodSugar: 95,
          weight: 70,
        })
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('id');
          expect(res.body.bpSystolic).toBe(120);
          expect(res.body.bloodSugar).toBe(95);
        });
    });
  });

  describe('/health/recommendations (GET)', () => {
    it('should get personalized health recommendations', () => {
      return request(app.getHttpServer())
        .get('/health/recommendations')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200)
        .expect((res) => {
          expect(Array.isArray(res.body)).toBe(true);
        });
    });
  });
});
