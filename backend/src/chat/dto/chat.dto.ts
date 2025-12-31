import { IsString, IsOptional, IsArray, IsEnum, IsNumber } from 'class-validator';

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

  @IsEnum(['TEXT', 'IMAGE', 'AUDIO', 'FILE'])
  @IsOptional()
  type?: string;

  @IsString()
  @IsOptional()
  mediaUrl?: string;

  @IsNumber()
  @IsOptional()
  audioDuration?: number;
}
