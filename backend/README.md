# Swastha Aur Abhiman - Backend API

NestJS-based backend API for the Swastha Aur Abhiman health, education, and training platform.

## 🚀 Tech Stack

- **Framework**: NestJS (Node.js + TypeScript)
- **Database**: PostgreSQL with TypeORM
- **Authentication**: JWT (JSON Web Tokens)
- **Real-time Communication**: Socket.io for WebSockets
- **File Storage**: AWS S3 (or MinIO for local/on-premise)
- **API Documentation**: Built-in Swagger support

## 📋 Prerequisites

- Node.js (v18 or higher)
- npm or yarn
- Docker and Docker Compose (for running PostgreSQL and MinIO locally)
- PostgreSQL 15+ (if not using Docker)

## 🛠️ Installation

### 1. Clone the repository
```bash
cd backend
```

### 2. Install dependencies
```bash
npm install
```

### 3. Environment Setup
Copy the example environment file and configure it:
```bash
cp .env.example .env
```

Edit `.env` file with your configuration:
```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=swastha_aur_abhiman

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRATION=7d

# AWS S3 (or MinIO)
AWS_REGION=ap-south-1
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_S3_BUCKET_NAME=swastha-aur-abhiman
AWS_S3_PRESCRIPTIONS_BUCKET=swastha-prescriptions-private

# Application
PORT=3000
NODE_ENV=development

# CORS
CORS_ORIGINS=http://localhost:3000,http://localhost:8080
```

### 4. Start Database with Docker
```bash
docker-compose up -d
```

This will start:
- PostgreSQL on port 5432
- MinIO (S3-compatible storage) on port 9000
- Redis on port 6379

## 🏃 Running the Application

### Development mode
```bash
npm run start:dev
```

### Production mode
```bash
npm run build
npm run start:prod
```

The API will be available at `http://localhost:3000/api`

## 📚 API Documentation

Once the server is running, you can access:
- API endpoints at: `http://localhost:3000/api`
- Swagger documentation (if configured): `http://localhost:3000/api/docs`

## 🔑 API Endpoints

### Authentication
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login user

### Users
- `GET /api/users/profile` - Get current user profile
- `GET /api/users/all` - Get all users (Admin only)
- `GET /api/users/doctors` - Get all doctors
- `GET /api/users/teachers` - Get all teachers
- `GET /api/users/trainers` - Get all trainers

### Media Content
- `POST /api/media` - Upload media content (Admin only)
- `GET /api/media` - Get all media content
- `GET /api/media/:category/:subCategory` - Get media by category

### Events
- `POST /api/events` - Create event (Admin only)
- `GET /api/events` - Get all events
- `GET /api/events/upcoming` - Get upcoming events

### Prescriptions
- `POST /api/prescriptions` - Upload prescription (User only)
- `GET /api/prescriptions/my` - Get user's prescriptions
- `GET /api/prescriptions/pending` - Get pending prescriptions (Doctor only)
- `PATCH /api/prescriptions/:id/review` - Review prescription (Doctor only)

### Chat
- `POST /api/chat/rooms` - Create chat room
- `GET /api/chat/rooms` - Get user's chat rooms
- `GET /api/chat/rooms/:roomId/messages` - Get room messages

## 🗄️ Database Schema

The application uses the following main entities:
- **Users**: Core user authentication and profile
- **User Profiles**: User-specific health data
- **Doctor Profiles**: Doctor credentials and specialization
- **Media Content**: Videos and educational content
- **Events**: Community events
- **Prescriptions**: Medical prescriptions and reviews
- **Chat Rooms**: Real-time messaging
- **Messages**: Chat messages

## 🔐 Role-Based Access Control (RBAC)

The system supports 5 user roles:
- **ADMIN**: Full system access, content management
- **USER**: Access to all features, can upload prescriptions
- **DOCTOR**: Can review prescriptions, access chat
- **TEACHER**: Access education content, chat
- **TRAINER**: Access training content, chat

## 🧪 Testing

```bash
# Unit tests
npm run test

# E2E tests
npm run test:e2e

# Test coverage
npm run test:cov
```

## 🐳 Docker Deployment

Build and run with Docker:
```bash
docker build -t swastha-backend .
docker run -p 3000:3000 swastha-backend
```

## 📝 Development Guidelines

1. **Code Style**: Follow the existing NestJS patterns and TypeScript best practices
2. **Database Migrations**: Use TypeORM migrations for schema changes
3. **Error Handling**: Use NestJS exception filters for consistent error responses
4. **Validation**: Use class-validator decorators in DTOs
5. **Documentation**: Comment complex logic and keep API documentation updated

## 🔧 Troubleshooting

### Database Connection Issues
- Ensure PostgreSQL is running: `docker-compose ps`
- Check credentials in `.env` file
- Verify network connectivity

### Port Already in Use
```bash
# Find process using port 3000
lsof -i :3000  # macOS/Linux
netstat -ano | findstr :3000  # Windows

# Kill the process and restart
```

## 📄 License

This project is licensed under UNLICENSED - see the package.json file for details.

## 👥 Support

For issues and questions, please contact the development team.
