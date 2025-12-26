import {
  Injectable,
  ConflictException,
  UnauthorizedException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { User } from '../users/entities/user.entity';
import { UserProfile } from '../users/entities/user-profile.entity';
import { DoctorProfile } from '../users/entities/doctor-profile.entity';
import { RegisterDto, LoginDto, AuthResponseDto } from './dto/auth.dto';
import { UserRole } from '../common/enums/user.enum';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
    @InjectRepository(UserProfile)
    private userProfileRepository: Repository<UserProfile>,
    @InjectRepository(DoctorProfile)
    private doctorProfileRepository: Repository<DoctorProfile>,
    private jwtService: JwtService,
  ) {}

  async register(registerDto: RegisterDto): Promise<AuthResponseDto> {
    const { email, password, role, fullName, gender, phoneNumber, ...profileData } = registerDto;

    // Check if user already exists
    const existingUser = await this.userRepository.findOne({ where: { email } });
    if (existingUser) {
      throw new ConflictException('User with this email already exists');
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user
    const user = this.userRepository.create({
      email,
      password: hashedPassword,
      role,
      fullName,
      gender,
      phoneNumber,
    });

    const savedUser = await this.userRepository.save(user);

    // Create role-specific profile
    if (role === UserRole.USER) {
      if (!profileData.block) {
        throw new BadRequestException('Block is required for USER role');
      }
      const userProfile = this.userProfileRepository.create({
        user: savedUser,
        block: profileData.block,
        address: profileData.address,
        age: profileData.age,
        healthMetrics: {},
      });
      await this.userProfileRepository.save(userProfile);
    } else if (role === UserRole.DOCTOR) {
      if (!profileData.specialization) {
        throw new BadRequestException('Specialization is required for DOCTOR role');
      }
      const doctorProfile = this.doctorProfileRepository.create({
        user: savedUser,
        specialization: profileData.specialization,
        licenseNumber: profileData.licenseNumber,
        yearsOfExperience: profileData.yearsOfExperience,
        hospitalAffiliation: profileData.hospitalAffiliation,
      });
      await this.doctorProfileRepository.save(doctorProfile);
    }

    // Generate JWT token
    const payload = { sub: savedUser.id, email: savedUser.email, role: savedUser.role };
    const accessToken = this.jwtService.sign(payload);

    return {
      accessToken,
      user: {
        id: savedUser.id,
        email: savedUser.email,
        fullName: savedUser.fullName,
        role: savedUser.role,
      },
    };
  }

  async login(loginDto: LoginDto): Promise<AuthResponseDto> {
    const { email, password, role } = loginDto;

    // Find user
    const user = await this.userRepository.findOne({ where: { email } });
    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }

    // Verify password
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    // Verify role
    if (user.role !== role) {
      throw new UnauthorizedException('Invalid role selected');
    }

    // Check if user is active
    if (!user.isActive) {
      throw new UnauthorizedException('Account is not active. Please contact admin.');
    }

    // Generate JWT token
    const payload = { sub: user.id, email: user.email, role: user.role };
    const accessToken = this.jwtService.sign(payload);

    return {
      accessToken,
      user: {
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        role: user.role,
      },
    };
  }

  async validateUser(userId: string): Promise<User> {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new UnauthorizedException('User not found');
    }
    return user;
  }
}
