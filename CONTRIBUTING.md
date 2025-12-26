# Contributing to Swastha Aur Abhiman

## Development Setup

### Prerequisites

- **Node.js**: v18 or higher
- **Flutter**: v3.0 or higher
- **Docker Desktop**: For running PostgreSQL, MinIO, and Redis
- **Git**: For version control

### Getting Started

#### 1. Clone the Repository

```bash
git clone https://github.com/smirk-dev/Swasth-aur-Abhiman.git
cd Swasth-aur-Abhiman
```

#### 2. Backend Setup

```bash
cd backend

# Install dependencies
npm install

# Copy environment example file
cp .env.example .env

# Edit .env with your configuration
# Update database credentials, JWT secret, etc.

# Start Docker services (PostgreSQL, MinIO, Redis)
docker-compose up -d

# Run the backend in development mode
npm run start:dev

# Or run with ts-node
npx ts-node -r tsconfig-paths/register src/main.ts
```

The backend will be available at: http://localhost:3000/api

#### 3. Mobile App Setup

```bash
cd mobile-app

# Install dependencies
flutter pub get

# Run on Chrome (Web)
flutter run -d chrome

# Run in release mode (faster)
flutter run -d chrome --release

# Or run on other platforms
flutter run -d windows
flutter run -d android
```

### Project Structure

```
Swasth-aur-Abhiman/
├── backend/                 # NestJS Backend API
│   ├── src/
│   │   ├── auth/           # Authentication module (JWT)
│   │   ├── users/          # User management
│   │   ├── media/          # Media content module
│   │   ├── events/         # Events module
│   │   ├── prescriptions/  # Prescription management
│   │   ├── chat/           # Real-time chat (WebSocket)
│   │   ├── common/         # Shared utilities
│   │   └── main.ts         # Application entry point
│   ├── docker-compose.yml  # Docker services
│   ├── .env.example        # Environment template
│   └── package.json
│
├── mobile-app/             # Flutter Mobile Application
│   ├── lib/
│   │   ├── core/           # Core utilities, theme, routing
│   │   ├── features/       # Feature modules
│   │   │   ├── auth/       # Authentication UI
│   │   │   ├── home/       # Home screen
│   │   │   ├── medical/    # Medical services
│   │   │   ├── education/  # Education hub
│   │   │   ├── skills/     # Skills training
│   │   │   ├── nutrition/  # Nutrition guidance
│   │   │   ├── events/     # Events management
│   │   │   ├── chat/       # Chat interface
│   │   │   └── admin/      # Admin panel
│   │   └── main.dart       # App entry point
│   └── pubspec.yaml
│
└── docs/                   # Documentation
    ├── plan.md
    ├── product_requirements_document.md
    ├── structure.md
    └── system_architecture.md
```

### Development Workflow

#### Backend Development

1. Make changes to files in `backend/src/`
2. The server will auto-reload with `npm run start:dev`
3. Test endpoints using:
   ```bash
   # Example: Register a user
   curl -X POST http://localhost:3000/api/auth/register \
     -H "Content-Type: application/json" \
     -d '{"email":"test@example.com","password":"Test123!","fullName":"Test User","gender":"MALE","role":"USER"}'
   ```

#### Mobile App Development

1. Make changes to files in `mobile-app/lib/`
2. Press `r` in the terminal to hot reload
3. Press `R` for hot restart
4. The app will automatically update

### Environment Variables

#### Backend (.env)

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=swastha_aur_abhiman

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRES_IN=7d

# MinIO (S3-compatible storage)
MINIO_ENDPOINT=localhost
MINIO_PORT=9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin
MINIO_USE_SSL=false
MINIO_BUCKET=swastha-media

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
```

### Testing

#### Backend Tests

```bash
cd backend

# Run unit tests
npm run test

# Run e2e tests
npm run test:e2e

# Check test coverage
npm run test:cov
```

#### Mobile App Tests

```bash
cd mobile-app

# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

### Code Style

- **Backend**: Uses ESLint and Prettier
  ```bash
  npm run lint
  npm run format
  ```

- **Mobile App**: Uses Dart analyzer
  ```bash
  flutter analyze
  dart format .
  ```

### Database Management

#### View Database Tables

```bash
docker exec -it swastha_postgres psql -U postgres -d swastha_aur_abhiman -c "\dt"
```

#### View Users

```bash
docker exec -it swastha_postgres psql -U postgres -d swastha_aur_abhiman -c "SELECT * FROM users;"
```

#### Reset Database

```bash
docker-compose down -v
docker-compose up -d
```

### Common Issues

#### Backend won't start
- Check if port 3000 is already in use
- Ensure Docker services are running: `docker-compose ps`
- Check `.env` file exists and has correct values

#### Flutter build errors
- Run `flutter clean` and `flutter pub get`
- Ensure Flutter SDK is up to date: `flutter upgrade`
- For Windows, enable Developer Mode in Windows Settings

#### Database connection errors
- Verify Docker containers are running: `docker ps`
- Check database credentials in `.env`
- Restart Docker services: `docker-compose restart`

### Git Workflow

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Make your changes
3. Commit with descriptive messages: `git commit -m "feat: add user profile feature"`
4. Push to your fork: `git push origin feature/your-feature`
5. Create a Pull Request

### Commit Message Convention

Use conventional commits:
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting)
- `refactor:` Code refactoring
- `test:` Test additions/changes
- `chore:` Maintenance tasks

### Getting Help

- Check the [documentation](./docs/)
- Review [README.md](./README.md)
- Open an issue on GitHub

---

## License

This project is licensed under the terms specified in the LICENSE file.
