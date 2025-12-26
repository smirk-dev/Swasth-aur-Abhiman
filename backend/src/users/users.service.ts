import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { UserProfile } from './entities/user-profile.entity';
import { DoctorProfile } from './entities/doctor-profile.entity';
import { UserRole } from '../common/enums/user.enum';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
    @InjectRepository(UserProfile)
    private userProfileRepository: Repository<UserProfile>,
    @InjectRepository(DoctorProfile)
    private doctorProfileRepository: Repository<DoctorProfile>,
  ) {}

  async getUserProfile(userId: string) {
    const user = await this.userRepository.findOne({
      where: { id: userId },
      relations: ['userProfile', 'doctorProfile'],
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    const { password, ...userWithoutPassword } = user;
    return userWithoutPassword;
  }

  async getAllUsers() {
    const users = await this.userRepository.find({
      relations: ['userProfile', 'doctorProfile'],
    });

    return users.map(user => {
      const { password, ...userWithoutPassword } = user;
      return userWithoutPassword;
    });
  }

  async getUsersByRole(role: UserRole) {
    const users = await this.userRepository.find({
      where: { role, isActive: true },
      relations: ['userProfile', 'doctorProfile'],
    });

    return users.map(user => {
      const { password, ...userWithoutPassword } = user;
      return userWithoutPassword;
    });
  }

  async updateHealthMetrics(userId: string, healthMetrics: any) {
    const userProfile = await this.userProfileRepository.findOne({
      where: { user: { id: userId } },
    });

    if (!userProfile) {
      throw new NotFoundException('User profile not found');
    }

    userProfile.healthMetrics = healthMetrics;
    return this.userProfileRepository.save(userProfile);
  }
}
