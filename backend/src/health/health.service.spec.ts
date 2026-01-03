import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { HealthService } from './health.service';
import { HealthMetric, HealthMetricSession } from './entities/health-metric.entity';
import { User } from '../users/entities/user.entity';
import { UserRole } from '../common/enums/user.enum';

describe('HealthService', () => {
  let service: HealthService;

  const mockHealthMetricRepository = {
    create: jest.fn(),
    save: jest.fn(),
    find: jest.fn(),
    findOne: jest.fn(),
    createQueryBuilder: jest.fn(),
  };

  const mockHealthSessionRepository = {
    create: jest.fn(),
    save: jest.fn(),
    find: jest.fn(),
    findOne: jest.fn(),
  };

  const mockUser: User = {
    id: '1',
    email: 'test@example.com',
    fullName: 'Test User',
    role: UserRole.USER,
    isActive: true,
  } as User;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        HealthService,
        {
          provide: getRepositoryToken(HealthMetric),
          useValue: mockHealthMetricRepository,
        },
        {
          provide: getRepositoryToken(HealthMetricSession),
          useValue: mockHealthSessionRepository,
        },
      ],
    }).compile();

    service = module.get<HealthService>(HealthService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('recordMetric', () => {
    it('should successfully record a health metric', async () => {
      const createDto = {
        metricType: 'BLOOD_SUGAR',
        value: 110,
        unit: 'mg/dL',
        notes: 'After breakfast',
      };

      const savedMetric = {
        id: '1',
        user: mockUser,
        ...createDto,
        condition: 'elevated',
        recordedAt: new Date(),
      };

      mockHealthMetricRepository.create.mockReturnValue(savedMetric);
      mockHealthMetricRepository.save.mockResolvedValue(savedMetric);

      const result = await service.recordMetric(mockUser, createDto);

      expect(result).toEqual(savedMetric);
      expect(mockHealthMetricRepository.create).toHaveBeenCalled();
      expect(mockHealthMetricRepository.save).toHaveBeenCalled();
    });

    it('should evaluate BP condition correctly', () => {
      expect(service.evaluateBPCondition(120, 80)).toBe('normal');
      expect(service.evaluateBPCondition(130, 85)).toBe('elevated');
      expect(service.evaluateBPCondition(140, 90)).toBe('high');
      expect(service.evaluateBPCondition(180, 110)).toBe('critical');
      expect(service.evaluateBPCondition(85, 55)).toBe('low');
    });

    it('should evaluate blood sugar condition correctly', () => {
      expect(service.evaluateBloodSugarCondition(90)).toBe('normal');
      expect(service.evaluateBloodSugarCondition(110)).toBe('elevated');
      expect(service.evaluateBloodSugarCondition(150)).toBe('high');
      expect(service.evaluateBloodSugarCondition(250)).toBe('critical');
      expect(service.evaluateBloodSugarCondition(65)).toBe('low');
    });

    it('should evaluate BMI condition correctly', () => {
      expect(service.evaluateBMICondition(22)).toBe('normal');
      expect(service.evaluateBMICondition(17)).toBe('underweight');
      expect(service.evaluateBMICondition(27)).toBe('overweight');
      expect(service.evaluateBMICondition(32)).toBe('obese');
    });
  });

  describe('getMetrics', () => {
    it('should return paginated health metrics', async () => {
      const metrics = [
        {
          id: '1',
          metricType: 'BLOOD_SUGAR',
          value: 110,
          user: mockUser,
        },
        {
          id: '2',
          metricType: 'BP_SYSTOLIC',
          value: 120,
          user: mockUser,
        },
      ];

      const queryBuilder = {
        where: jest.fn().mockReturnThis(),
        andWhere: jest.fn().mockReturnThis(),
        orderBy: jest.fn().mockReturnThis(),
        take: jest.fn().mockReturnThis(),
        skip: jest.fn().mockReturnThis(),
        getManyAndCount: jest.fn().mockResolvedValue([metrics, 2]),
      };

      mockHealthMetricRepository.createQueryBuilder.mockReturnValue(queryBuilder);

      const result = await service.getMetrics(mockUser, {});

      expect(result.data).toEqual(metrics);
      expect(result.total).toBe(2);
    });
  });

  describe('getHealthSummary', () => {
    it('should return health summary with trends', async () => {
      const recentMetrics = [
        {
          metricType: 'BLOOD_SUGAR',
          value: 110,
          recordedAt: new Date(),
        },
        {
          metricType: 'BLOOD_SUGAR',
          value: 100,
          recordedAt: new Date(Date.now() - 86400000),
        },
      ];

      mockHealthMetricRepository.findOne.mockResolvedValue(recentMetrics[0]);
      mockHealthMetricRepository.find.mockResolvedValue(recentMetrics);

      const result = await service.getHealthSummary(mockUser);

      expect(result).toHaveProperty('latestMetrics');
      expect(result).toHaveProperty('trends');
      expect(result).toHaveProperty('averages');
    });
  });

  describe('recordSession', () => {
    it('should successfully record a health session', async () => {
      const createSessionDto = {
        date: '2026-01-03',
        bpSystolic: 120,
        bpDiastolic: 80,
        bloodSugar: 95,
        weight: 70,
      };

      const savedSession = {
        id: '1',
        user: mockUser,
        ...createSessionDto,
      };

      mockHealthSessionRepository.create.mockReturnValue(savedSession);
      mockHealthSessionRepository.save.mockResolvedValue(savedSession);

      const result = await service.recordSession(mockUser, createSessionDto);

      expect(result).toEqual(savedSession);
      expect(mockHealthSessionRepository.create).toHaveBeenCalled();
    });
  });

  describe('getHealthRecommendations', () => {
    it('should provide health recommendations based on metrics', async () => {
      const latestMetrics = {
        BP_SYSTOLIC: { value: 145, condition: 'high' },
        BLOOD_SUGAR: { value: 90, condition: 'normal' },
      };

      jest.spyOn(service, 'getHealthSummary').mockResolvedValue({
        latestMetrics,
        trends: {},
        averages: {},
      } as any);

      const recommendations = await service.getHealthRecommendations(mockUser);

      expect(recommendations).toBeInstanceOf(Array);
      expect(recommendations.length).toBeGreaterThan(0);
      expect(recommendations.some(r => r.includes('blood pressure'))).toBe(true);
    });
  });
});
