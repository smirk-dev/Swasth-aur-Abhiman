# Production Deployment Guide

## Prerequisites

1. **Docker & Docker Compose** installed
2. **PostgreSQL** database ready
3. **Redis** server running
4. **AWS Account** (for cloud storage)
5. **Domain & SSL certificate** configured

## Environment Setup

### 1. Configure Production Environment

Create `.env.production`:

```bash
NODE_ENV=production
PORT=3000

# Database
DB_HOST=your-production-db.rds.amazonaws.com
DB_PORT=5432
DB_USERNAME=dbuser
DB_PASSWORD=strong-password
DB_DATABASE=swastha_production

# JWT
JWT_SECRET=super-secret-production-key-min-32-characters-long
JWT_EXPIRATION=7d

# Redis
REDIS_HOST=your-redis.cache.amazonaws.com
REDIS_PORT=6379
REDIS_PASSWORD=redis-password

# AWS S3
ENABLE_CLOUD_STORAGE=true
AWS_REGION=ap-south-1
AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXX
AWS_SECRET_ACCESS_KEY=your-secret-key
S3_BUCKET_NAME=swastha-production-uploads
AWS_S3_PRESCRIPTIONS_BUCKET=swastha-prescriptions-prod
CLOUDFRONT_DOMAIN=cdn.yourapp.com

# CORS
CORS_ORIGINS=https://yourapp.com,https://www.yourapp.com,https://admin.yourapp.com

# Logging
LOG_LEVEL=warn
LOG_DIR=/var/log/swastha

# Rate Limiting
THROTTLE_TTL=60000
THROTTLE_LIMIT=100
```

### 2. Database Migrations

Run migrations in production:

```bash
npm run migration:run
```

### 3. Build Docker Image

```bash
docker build -t swasth-backend:latest .
```

### 4. Deploy with Docker Compose

Create `docker-compose.prod.yml`:

```yaml
version: '3.8'

services:
  backend:
    image: swasth-backend:latest
    restart: always
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    env_file:
      - .env.production
    depends_on:
      - redis
    volumes:
      - ./logs:/var/log/swastha
    healthcheck:
      test: ["CMD", "node", "-e", "require('http').get('http://localhost:3000/health-check/liveness', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  redis:
    image: redis:7-alpine
    restart: always
    ports:
      - "6379:6379"
    command: redis-server --requirepass your-redis-password
    volumes:
      - redis-data:/data

  nginx:
    image: nginx:alpine
    restart: always
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - backend

volumes:
  redis-data:
```

Start services:

```bash
docker-compose -f docker-compose.prod.yml up -d
```

## AWS Deployment

### Option 1: AWS ECS (Elastic Container Service)

1. **Push Docker image to ECR**:
```bash
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.ap-south-1.amazonaws.com
docker tag swasth-backend:latest <account-id>.dkr.ecr.ap-south-1.amazonaws.com/swasth-backend:latest
docker push <account-id>.dkr.ecr.ap-south-1.amazonaws.com/swasth-backend:latest
```

2. **Create ECS Task Definition** with the image
3. **Create ECS Service** with load balancer
4. **Configure Auto Scaling**

### Option 2: AWS Elastic Beanstalk

1. Install EB CLI:
```bash
pip install awsebcli
```

2. Initialize:
```bash
eb init -p docker swasth-backend
```

3. Create environment:
```bash
eb create production-env --instance-type t3.medium --database.engine postgres
```

4. Deploy:
```bash
eb deploy
```

### Option 3: AWS EC2

1. Launch EC2 instance (t3.medium or larger)
2. SSH into instance
3. Install Docker & Docker Compose
4. Clone repository
5. Run deployment commands

## Monitoring & Logging

### CloudWatch Integration

Add CloudWatch agent to Docker container or EC2 instance:

```bash
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
```

Configure log groups:
- `/aws/swastha/application`
- `/aws/swastha/error`
- `/aws/swastha/access`

### Health Checks

Monitor endpoints:
- `GET /health-check` - Overall health
- `GET /health-check/liveness` - Liveness probe
- `GET /health-check/readiness` - Readiness probe

## Security Checklist

- [ ] Change all default passwords
- [ ] Enable HTTPS with valid SSL certificate
- [ ] Configure WAF (Web Application Firewall)
- [ ] Set up VPC with private subnets for database
- [ ] Enable RDS encryption at rest
- [ ] Configure Security Groups properly
- [ ] Enable CloudTrail for audit logging
- [ ] Set up backup strategy for database
- [ ] Configure secrets in AWS Secrets Manager
- [ ] Enable AWS GuardDuty for threat detection

## Performance Optimization

1. **Database Indexing**: Ensure all required indexes are created
2. **Redis Caching**: Verify Redis is properly configured
3. **CDN**: Use CloudFront for static assets
4. **Connection Pooling**: Configure optimal pool sizes
5. **Compression**: Gzip enabled for API responses

## Rollback Strategy

1. Keep previous Docker images tagged
2. Quick rollback command:
```bash
docker-compose -f docker-compose.prod.yml down
docker pull <account-id>.dkr.ecr.ap-south-1.amazonaws.com/swasth-backend:previous
docker-compose -f docker-compose.prod.yml up -d
```

## Load Testing Results

Run load tests before production:

```bash
npm run load-test:report
```

Expected performance:
- **Response time (p95)**: < 500ms
- **Throughput**: > 100 req/s
- **Error rate**: < 0.1%

## Backup & Disaster Recovery

1. **Automated RDS Snapshots**: Daily at 3 AM UTC
2. **S3 Bucket Versioning**: Enabled
3. **Redis Persistence**: AOF + RDB
4. **Application Logs**: Retained for 30 days

## Post-Deployment Verification

1. Check health endpoints
2. Verify database connectivity
3. Test authentication flow
4. Verify file uploads to S3
5. Check Redis connectivity
6. Monitor error logs
7. Test critical API endpoints
8. Verify CORS configuration

## Support & Maintenance

- **Logs location**: `/var/log/swastha/`
- **Metrics**: CloudWatch Dashboard
- **Alerts**: SNS notifications configured
- **On-call**: PagerDuty integration

## Scaling Recommendations

- **Horizontal scaling**: Use ECS Auto Scaling or EKS
- **Vertical scaling**: Upgrade instance types as needed
- **Database**: Use RDS read replicas for read-heavy workloads
- **Redis**: Use ElastiCache cluster mode for high availability
