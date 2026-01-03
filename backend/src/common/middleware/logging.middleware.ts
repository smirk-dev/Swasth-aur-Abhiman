import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { LoggerService } from '../logger/logger.service';

@Injectable()
export class LoggingMiddleware implements NestMiddleware {
  constructor(private readonly logger: LoggerService) {}

  use(req: Request, res: Response, next: NextFunction) {
    const { method, originalUrl, ip } = req;
    const userAgent = req.get('user-agent') || '';
    const startTime = Date.now();

    // Log request
    this.logger.log(`Incoming Request: ${method} ${originalUrl}`, 'HTTP');

    // Capture response
    res.on('finish', () => {
      const { statusCode } = res;
      const responseTime = Date.now() - startTime;
      
      // Get user ID from request if authenticated
      const userId = (req as any).user?.id;

      // Log response
      this.logger.logRequest(method, originalUrl, statusCode, responseTime, userId);

      // Log slow requests (>2 seconds)
      if (responseTime > 2000) {
        this.logger.warn(
          `Slow request detected: ${method} ${originalUrl} - ${responseTime}ms`,
          'Performance',
        );
      }

      // Log errors
      if (statusCode >= 400) {
        this.logger.warn(
          `Request failed: ${method} ${originalUrl} - Status ${statusCode}`,
          'HTTP',
        );
      }
    });

    next();
  }
}
