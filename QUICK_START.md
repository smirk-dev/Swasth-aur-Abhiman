# Swastha Aur Abhiman - Quick Start Scripts

## Start Development Environment

### Option 1: PowerShell (Windows)

```powershell
# Start all services at once
cd backend
docker-compose up -d
npx ts-node -r tsconfig-paths/register src/main.ts &
cd ../mobile-app
flutter run -d chrome --release
```

### Option 2: Separate Terminals

**Terminal 1 - Docker Services:**
```powershell
cd backend
docker-compose up -d
```

**Terminal 2 - Backend API:**
```powershell
cd backend
npx ts-node -r tsconfig-paths/register src/main.ts
# Or use: npm run start:dev (if watch mode is needed)
```

**Terminal 3 - Flutter App:**
```powershell
cd mobile-app
flutter run -d chrome --release
```

## Quick Commands

### Backend

```powershell
# Install dependencies
cd backend
npm install

# Start development server
npm run start:dev

# Build for production
npm run build

# Run production build
npm run start:prod

# View logs
docker-compose logs -f postgres

# Stop all Docker services
docker-compose down

# Reset database (WARNING: Deletes all data)
docker-compose down -v
docker-compose up -d
```

### Mobile App

```powershell
# Install dependencies
cd mobile-app
flutter pub get

# Run on Chrome
flutter run -d chrome

# Run in release mode (faster)
flutter run -d chrome --release

# Clean build artifacts
flutter clean

# Analyze code
flutter analyze

# Format code
dart format .

# Run tests
flutter test
```

### Database Operations

```powershell
# Connect to PostgreSQL
docker exec -it swastha_postgres psql -U postgres -d swastha_aur_abhiman

# List all tables
docker exec -it swastha_postgres psql -U postgres -d swastha_aur_abhiman -c "\dt"

# View users
docker exec -it swastha_postgres psql -U postgres -d swastha_aur_abhiman -c "SELECT id, email, role, \"fullName\" FROM users;"

# View events
docker exec -it swastha_postgres psql -U postgres -d swastha_aur_abhiman -c "SELECT * FROM events;"

# View prescriptions
docker exec -it swastha_postgres psql -U postgres -d swastha_aur_abhiman -c "SELECT * FROM prescriptions;"
```

### API Testing with PowerShell

```powershell
# Register a user
$registerBody = @{
    email = "user@example.com"
    password = "SecurePass123!"
    fullName = "John Doe"
    gender = "MALE"
    role = "USER"
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:3000/api/auth/register" `
    -Method POST `
    -ContentType "application/json" `
    -Body $registerBody

# Login
$loginBody = @{
    email = "user@example.com"
    password = "SecurePass123!"
} | ConvertTo-Json

$response = Invoke-WebRequest -Uri "http://localhost:3000/api/auth/login" `
    -Method POST `
    -ContentType "application/json" `
    -Body $loginBody

$token = ($response.Content | ConvertFrom-Json).access_token
Write-Host "Access Token: $token"

# Get user profile (authenticated)
Invoke-WebRequest -Uri "http://localhost:3000/api/users/profile" `
    -Method GET `
    -Headers @{Authorization="Bearer $token"}

# Get all doctors
Invoke-WebRequest -Uri "http://localhost:3000/api/users/doctors" `
    -Method GET `
    -Headers @{Authorization="Bearer $token"}

# Get events
Invoke-WebRequest -Uri "http://localhost:3000/api/events" `
    -Method GET

# Get media content
Invoke-WebRequest -Uri "http://localhost:3000/api/media" `
    -Method GET `
    -Headers @{Authorization="Bearer $token"}
```

### Troubleshooting

#### Port already in use
```powershell
# Find process using port 3000
Get-Process -Id (Get-NetTCPConnection -LocalPort 3000).OwningProcess

# Kill the process
Stop-Process -Id <ProcessId> -Force
```

#### Docker containers not starting
```powershell
# Check Docker Desktop is running
docker version

# Restart Docker services
docker-compose restart

# View container logs
docker-compose logs
```

#### Flutter errors
```powershell
# Clean and rebuild
flutter clean
flutter pub get
flutter run -d chrome --release
```

## Environment Variables

Create `backend/.env` from `backend/.env.example`:

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=swastha_aur_abhiman

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-this
JWT_EXPIRES_IN=7d

# MinIO
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

## Useful URLs

- **Backend API**: http://localhost:3000/api
- **MinIO Console**: http://localhost:9001 (admin/minioadmin)
- **PostgreSQL**: localhost:5432 (postgres/postgres)
- **Redis**: localhost:6379
- **Flutter App**: Opens automatically in Chrome

## Project Roles

- **USER**: Regular app users
- **DOCTOR**: Medical professionals who review prescriptions
- **TEACHER**: Educational content creators
- **TRAINER**: Skills training instructors
- **ADMIN**: Platform administrators
