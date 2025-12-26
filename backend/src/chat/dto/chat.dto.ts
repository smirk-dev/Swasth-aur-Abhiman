import { IsString, IsOptional, IsArray, IsEnum } from 'class-validator';

export class CreateChatRoomDto {
  @IsArray()
  participantIds: string[];

  @IsString()
  @IsOptional()
  name?: string;
}

export class SendMessageDto {
  @IsString()
  roomId: string;

  @IsString()
  content: string;

  @IsEnum(['TEXT', 'IMAGE'])
  @IsOptional()
  type?: string;
}
