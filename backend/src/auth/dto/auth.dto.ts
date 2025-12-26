import { IsEmail, IsString, IsEnum, MinLength, IsOptional } from 'class-validator';
import { UserRole, Gender, Block } from '../../common/enums/user.enum';

export class RegisterDto {
  @IsEmail()
  email: string;

  @IsString()
  @MinLength(6)
  password: string;

  @IsEnum(UserRole)
  role: UserRole;

  @IsString()
  fullName: string;

  @IsEnum(Gender)
  gender: Gender;

  @IsString()
  @IsOptional()
  phoneNumber?: string;

  // User-specific fields
  @IsEnum(Block)
  @IsOptional()
  block?: Block;

  @IsString()
  @IsOptional()
  address?: string;

  @IsOptional()
  age?: number;

  // Doctor-specific fields
  @IsString()
  @IsOptional()
  specialization?: string;

  @IsString()
  @IsOptional()
  licenseNumber?: string;

  @IsOptional()
  yearsOfExperience?: number;

  @IsString()
  @IsOptional()
  hospitalAffiliation?: string;
}

export class LoginDto {
  @IsEmail()
  email: string;

  @IsString()
  password: string;

  @IsEnum(UserRole)
  role: UserRole;
}

export class AuthResponseDto {
  accessToken: string;
  user: {
    id: string;
    email: string;
    fullName: string;
    role: UserRole;
  };
}
