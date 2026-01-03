import { Test, TestingModule } from '@nestjs/testing';
import { JwtService } from '@nestjs/jwt';
import { getRepositoryToken } from '@nestjs/typeorm';
import { AuthService } from './auth.service';
import { User } from '../users/entities/user.entity';
import { UserRole } from '../common/enums/user.enum';
import { UnauthorizedException, ConflictException } from '@nestjs/common';
import * as bcrypt from 'bcrypt';

describe('AuthService', () => {
  let service: AuthService;
  let jwtService: JwtService;

  const mockUserRepository = {
    findOne: jest.fn(),
    create: jest.fn(),
    save: jest.fn(),
  };

  const mockJwtService = {
    sign: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: getRepositoryToken(User),
          useValue: mockUserRepository,
        },
        {
          provide: JwtService,
          useValue: mockJwtService,
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
    jwtService = module.get<JwtService>(JwtService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('register', () => {
    it('should successfully register a new user', async () => {
      const registerDto = {
        email: 'test@example.com',
        password: 'password123',
        fullName: 'Test User',
        phone: '1234567890',
        role: UserRole.USER,
      };

      mockUserRepository.findOne.mockResolvedValue(null);
      mockUserRepository.create.mockReturnValue(registerDto);
      mockUserRepository.save.mockResolvedValue({ ...registerDto, id: '1' });
      mockJwtService.sign.mockReturnValue('jwt-token');

      const result = await service.register(registerDto);

      expect(result).toHaveProperty('accessToken');
      expect(mockUserRepository.findOne).toHaveBeenCalled();
      expect(mockUserRepository.save).toHaveBeenCalled();
    });

    it('should throw ConflictException if user already exists', async () => {
      const registerDto = {
        email: 'existing@example.com',
        password: 'password123',
        fullName: 'Test User',
        phone: '1234567890',
        role: UserRole.USER,
      };

      mockUserRepository.findOne.mockResolvedValue({ id: '1', ...registerDto });

      await expect(service.register(registerDto)).rejects.toThrow(ConflictException);
    });
  });

  describe('login', () => {
    it('should return access token for valid credentials', async () => {
      const loginDto = {
        email: 'test@example.com',
        password: 'password123',
      };

      const hashedPassword = await bcrypt.hash(loginDto.password, 10);
      const user = {
        id: '1',
        email: loginDto.email,
        password: hashedPassword,
        role: UserRole.USER,
        isActive: true,
      };

      mockUserRepository.findOne.mockResolvedValue(user);
      mockJwtService.sign.mockReturnValue('jwt-token');

      const result = await service.login(loginDto);

      expect(result).toHaveProperty('accessToken');
      expect(result.accessToken).toBe('jwt-token');
    });

    it('should throw UnauthorizedException for invalid credentials', async () => {
      const loginDto = {
        email: 'test@example.com',
        password: 'wrongpassword',
      };

      mockUserRepository.findOne.mockResolvedValue(null);

      await expect(service.login(loginDto)).rejects.toThrow(UnauthorizedException);
    });

    it('should throw UnauthorizedException for inactive user', async () => {
      const loginDto = {
        email: 'test@example.com',
        password: 'password123',
      };

      const hashedPassword = await bcrypt.hash(loginDto.password, 10);
      const user = {
        id: '1',
        email: loginDto.email,
        password: hashedPassword,
        role: UserRole.USER,
        isActive: false,
      };

      mockUserRepository.findOne.mockResolvedValue(user);

      await expect(service.login(loginDto)).rejects.toThrow(UnauthorizedException);
    });
  });

  describe('validateUser', () => {
    it('should return user if validation succeeds', async () => {
      const user = {
        id: '1',
        email: 'test@example.com',
        role: UserRole.USER,
        isActive: true,
      };

      mockUserRepository.findOne.mockResolvedValue(user);

      const result = await service.validateUser('1');

      expect(result).toEqual(user);
    });

    it('should return null if user not found', async () => {
      mockUserRepository.findOne.mockResolvedValue(null);

      const result = await service.validateUser('999');

      expect(result).toBeNull();
    });
  });
});
