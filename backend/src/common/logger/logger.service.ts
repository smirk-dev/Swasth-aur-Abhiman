import { Injectable, LoggerService as NestLoggerService } from '@nestjs/common';
import * as winston from 'winston';
import * as DailyRotateFile from 'winston-daily-rotate-file';

@Injectable()
export class LoggerService implements NestLoggerService {
  private logger: winston.Logger;

  constructor() {
    this.logger = winston.createLogger({
      level: process.env.LOG_LEVEL || 'info',
      format: winston.format.combine(
        winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
        winston.format.errors({ stack: true }),
        winston.format.splat(),
        winston.format.json(),
      ),
      defaultMeta: { service: 'swasth-aur-abhiman' },
      transports: [
        // Console transport
        new winston.transports.Console({
          format: winston.format.combine(
            winston.format.colorize(),
            winston.format.printf(({ level, message, timestamp, context, trace }) => {
              return `${timestamp} [${context || 'Application'}] ${level}: ${message}${trace ? `\n${trace}` : ''}`;
            }),
          ),
        }),
        // Error log file
        new DailyRotateFile({
          filename: 'logs/error-%DATE%.log',
          datePattern: 'YYYY-MM-DD',
          level: 'error',
          maxSize: '20m',
          maxFiles: '14d',
          format: winston.format.combine(
            winston.format.timestamp(),
            winston.format.json(),
          ),
        }),
        // Combined log file
        new DailyRotateFile({
          filename: 'logs/combined-%DATE%.log',
          datePattern: 'YYYY-MM-DD',
          maxSize: '20m',
          maxFiles: '14d',
          format: winston.format.combine(
            winston.format.timestamp(),
            winston.format.json(),
          ),
        }),
      ],
    });
  }

  log(message: string, context?: string) {
    this.logger.info(message, { context });
  }

  error(message: string, trace?: string, context?: string) {
    this.logger.error(message, { context, trace });
  }

  warn(message: string, context?: string) {
    this.logger.warn(message, { context });
  }

  debug(message: string, context?: string) {
    this.logger.debug(message, { context });
  }

  verbose(message: string, context?: string) {
    this.logger.verbose(message, { context });
  }

  // Custom methods for structured logging
  logRequest(method: string, url: string, statusCode: number, responseTime: number, userId?: string) {
    this.logger.info('HTTP Request', {
      method,
      url,
      statusCode,
      responseTime,
      userId,
      type: 'http',
    });
  }

  logError(error: Error, context?: string) {
    this.logger.error(error.message, {
      context,
      stack: error.stack,
      type: 'error',
    });
  }

  logDatabaseQuery(query: string, duration: number) {
    this.logger.debug('Database Query', {
      query,
      duration,
      type: 'database',
    });
  }

  logAuth(action: string, userId: string, success: boolean) {
    this.logger.info('Auth Action', {
      action,
      userId,
      success,
      type: 'auth',
    });
  }
}
