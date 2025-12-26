import { Controller, Get, UseGuards } from '@nestjs/common';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../common/guards/jwt-auth.guard';
import { RolesGuard } from '../common/guards/roles.guard';
import { Roles } from '../common/decorators/roles.decorator';
import { GetUser } from '../common/decorators/get-user.decorator';
import { UserRole } from '../common/enums/user.enum';
import { User } from './entities/user.entity';

@Controller('users')
@UseGuards(JwtAuthGuard, RolesGuard)
export class UsersController {
  constructor(private usersService: UsersService) {}

  @Get('profile')
  async getProfile(@GetUser() user: User) {
    return this.usersService.getUserProfile(user.id);
  }

  @Get('all')
  @Roles(UserRole.ADMIN)
  async getAllUsers() {
    return this.usersService.getAllUsers();
  }

  @Get('doctors')
  async getAllDoctors() {
    return this.usersService.getUsersByRole(UserRole.DOCTOR);
  }

  @Get('teachers')
  async getAllTeachers() {
    return this.usersService.getUsersByRole(UserRole.TEACHER);
  }

  @Get('trainers')
  async getAllTrainers() {
    return this.usersService.getUsersByRole(UserRole.TRAINER);
  }
}
