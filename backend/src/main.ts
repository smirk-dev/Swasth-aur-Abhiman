import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { NestExpressApplication } from '@nestjs/platform-express';
import * as path from 'path';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  const configService = app.get(ConfigService);

  // Serve static files from uploads directory
  app.useStaticAssets(path.join(process.cwd(), 'uploads'), {
    prefix: '/uploads',
  });

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // Enable CORS
  app.enableCors({
    origin: (origin, callback) => {
      // Allow requests with no origin (like mobile apps or curl requests)
      if (!origin) return callback(null, true);
      
      // Allow localhost origins on any port
      if (origin.startsWith('http://localhost:') || origin.startsWith('http://127.0.0.1:')) {
        return callback(null, true);
      }
      
      // Check configured origins
      const corsOrigins = configService.get<string>('CORS_ORIGINS')?.split(',') || [];
      if (corsOrigins.includes(origin)) {
        return callback(null, true);
      }
      
      callback(new Error('Not allowed by CORS'));
    },
    credentials: true,
  });

  // Global prefix for API routes
  app.setGlobalPrefix('api');

  const port = configService.get<number>('PORT') || 3000;
  await app.listen(port);
  
  console.log(`🚀 Swastha Aur Abhiman Backend running on: http://localhost:${port}/api`);
}

bootstrap();
