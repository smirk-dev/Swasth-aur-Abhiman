import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { AdminService } from './admin.service';
import { User } from '../users/entities/user.entity';
import { UserRole } from '../common/enums/user.enum';

describe('AdminService', () => {
  let service: AdminService;

  const mockUserRepository = {
    find: jest.fn(),
    findOne: jest.fn(),
    update: jest.fn(),
    delete: jest.fn(),
    count: jest.fn(),
    createQueryBuilder: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AdminService,
        {
          provide: getRepositoryToken(User),
          useValue: mockUserRepository,
        },
      ],
    }).compile();

    service = module.get<AdminService>(AdminService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getAllUsers', () => {
    it('should return paginated users', async () => {
      const users = [
        { id: '1', email: 'user1@example.com', role: UserRole.USER },
        { id: '2', email: 'user2@example.com', role: UserRole.USER },
      ];

      const queryBuilder = {
        where: jest.fn().mockReturnThis(),
        skip: jest.fn().mockReturnThis(),
        take: jest.fn().mockReturnThis(),
        getManyAndCount: jest.fn().mockResolvedValue([users, 2]),
      };

      mockUserRepository.createQueryBuilder.mockReturnValue(queryBuilder);

      const result = await service.getAllUsers({ page: 1, limit: 10 });

      expect(result.data).toEqual(users);
      expect(result.total).toBe(2);
      expect(result.page).toBe(1);
    });

    it('should filter users by role', async () => {
      const queryBuilder = {
        where: jest.fn().mockReturnThis(),
        andWhere: jest.fn().mockReturnThis(),
        skip: jest.fn().mockReturnThis(),
        take: jest.fn().mockReturnThis(),
        getManyAndCount: jest.fn().mockResolvedValue([[], 0]),
      };

      mockUserRepository.createQueryBuilder.mockReturnValue(queryBuilder);

      await service.getAllUsers({ page: 1, limit: 10, role: UserRole.DOCTOR });

      expect(queryBuilder.andWhere).toHaveBeenCalledWith('user.role = :role', { role: UserRole.DOCTOR });
    });
  });

  describe('updateUserStatus', () => {
    it('should activate a user', async () => {
      const user = {
        id: '1',
        email: 'test@example.com',
        isActive: false,
      };

      mockUserRepository.findOne.mockResolvedValue(user);
      mockUserRepository.update.mockResolvedValue({ affected: 1 });

      const updatedUser = { ...user, isActive: true };
      mockUserRepository.findOne.mockResolvedValueOnce(user).mockResolvedValueOnce(updatedUser);

      const result = await service.updateUserStatus('1', true);

      expect(result.isActive).toBe(true);
      expect(mockUserRepository.update).toHaveBeenCalledWith('1', { isActive: true });
    });
  });

  describe('getUserStats', () => {
    it('should return user statistics', async () => {
      mockUserRepository.count.mockImplementation(({ where }) => {
        if (where.role === UserRole.USER) return Promise.resolve(100);
        if (where.role === UserRole.DOCTOR) return Promise.resolve(10);
        if (where.role === UserRole.TEACHER) return Promise.resolve(5);
        if (where.isActive === true) return Promise.resolve(105);
        if (where.isActive === false) return Promise.resolve(10);
        return Promise.resolve(115);
      });

      const stats = await service.getUserStats();

      expect(stats.totalUsers).toBe(115);
      expect(stats.activeUsers).toBe(105);
      expect(stats.usersByRole.USER).toBe(100);
      expect(stats.usersByRole.DOCTOR).toBe(10);
    });
  });

  describe('deleteUser', () => {
    it('should delete a user', async () => {
      mockUserRepository.findOne.mockResolvedValue({ id: '1' });
      mockUserRepository.delete.mockResolvedValue({ affected: 1 });

      await service.deleteUser('1');

      expect(mockUserRepository.delete).toHaveBeenCalledWith('1');
    });

    it('should throw error if user not found', async () => {
      mockUserRepository.findOne.mockResolvedValue(null);

      await expect(service.deleteUser('999')).rejects.toThrow();
    });
  });
});
