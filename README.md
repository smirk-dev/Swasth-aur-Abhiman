# Swastha Aur Abhiman

A comprehensive digital ecosystem for health, education, and training services built for government outreach programs.

## 🎯 Project Overview

**Swastha Aur Abhiman** is a full-stack application designed to bridge the gap between citizens and essential services including medical advice, educational resources, and vocational training. The platform emphasizes Post-COVID recovery strategies and traditional knowledge of herbal remedies.

## 🏗️ System Architecture

### Technology Stack

#### Backend
- **Framework**: NestJS (Node.js + TypeScript)
- **Database**: PostgreSQL with TypeORM
- **Authentication**: JWT (JSON Web Tokens)
- **Real-time**: Socket.io for WebSockets
- **Storage**: AWS S3 / MinIO

#### Frontend
- **Mobile**: Flutter (Dart)
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Local Storage**: Hive

## 📁 Project Structure

```
swasth-aur-abhiman/
├── backend/                    # NestJS Backend API
│   ├── src/
│   │   ├── auth/              # Authentication module
│   │   ├── users/             # User management
│   │   ├── media/             # Media content
│   │   ├── events/            # Events management
│   │   ├── prescriptions/     # Medical prescriptions
│   │   ├── chat/              # Real-time chat
│   │   └── common/            # Shared utilities
│   ├── docker-compose.yml     # Docker services
│   └── package.json
│
├── mobile-app/                 # Flutter Mobile App
│   ├── lib/
│   │   ├── core/              # Core functionality
│   │   └── features/          # Feature modules
│   ├── pubspec.yaml
│   └── README.md
│
└── docs/                       # Documentation
    ├── plan.md
    ├── product_requirements_document.md
    ├── structure.md
    └── system_architecture.md
```

## 👥 User Roles

1. **ADMIN** - System administration and content management
2. **USER** - Citizens/applicants accessing services
3. **DOCTOR** - Medical professionals providing consultations
4. **TEACHER** - Educators providing learning resources
5. **TRAINER** - Skill development experts

## ✨ Key Features

### 🏥 Medical Services
- Health metrics tracking (BP, Sugar, BMI)
- Prescription upload and management
- Doctor consultations
- Post-COVID recovery guidance
- Herbal remedies information

### 📚 Education Hub
- NCERT books (Class 1-12)
- Educational videos
- Learning resources

### 🛠️ Skills Training
- Vocational training videos
- Specific topics: Bamboo work, Honeybee farming, Jute work, Macrame
- Artisan training programs

### 🥗 Nutrition
- Diet plans
- Post-COVID nutritional guidance
- Traditional food wisdom

### 📅 Events
- Community event listings
- Event registration
- Notifications

### 💬 Communication
- Real-time chat between roles
- User ↔ Doctor/Teacher/Trainer messaging
- Group discussions

## 🚀 Getting Started

### Prerequisites
- Node.js 18+
- Flutter SDK 3.0+
- Docker & Docker Compose
- PostgreSQL 15+

### Quick Start

#### 1. Setup Backend
```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your configuration
docker-compose up -d
npm run start:dev
```

Backend will run at: `http://localhost:3000/api`

#### 2. Setup Mobile App
```bash
cd mobile-app
flutter pub get
# Update API URL in lib/core/constants/app_constants.dart
flutter run
```

### Development Workflow

1. **Database Setup**
   ```bash
   cd backend
   docker-compose up -d
   ```

2. **Backend Development**
   ```bash
   cd backend
   npm run start:dev
   ```

3. **Mobile Development**
   ```bash
   cd mobile-app
   flutter run --debug
   ```

## 📖 Documentation

Detailed documentation is available in the `docs/` directory:

- [Product Requirements Document](docs/product_requirements_document.md)
- [System Architecture](docs/system_architecture.md)
- [Sprint Plan](docs/plan.md)
- [Project Structure](docs/structure.md)

## 🔒 Security

- JWT-based authentication
- Role-based access control (RBAC)
- Secure file storage (S3)
- Encrypted API communication
- Password hashing with bcrypt

## 🧪 Testing

### Backend Tests
```bash
cd backend
npm run test
npm run test:e2e
```

### Mobile Tests
```bash
cd mobile-app
flutter test
```

## 📊 Database Schema

### Core Entities
- **Users**: Authentication and profile
- **User Profiles**: Health metrics and personal data
- **Doctor Profiles**: Medical credentials
- **Media Content**: Videos and educational materials
- **Events**: Community events
- **Prescriptions**: Medical prescriptions
- **Chat Rooms & Messages**: Real-time communication

## 🌐 API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login

### Users
- `GET /api/users/profile` - Get user profile
- `GET /api/users/doctors` - List all doctors

### Media
- `POST /api/media` - Upload content (Admin)
- `GET /api/media` - Get all media

### Prescriptions
- `POST /api/prescriptions` - Upload prescription
- `PATCH /api/prescriptions/:id/review` - Review prescription

### Chat
- `POST /api/chat/rooms` - Create chat room
- `GET /api/chat/rooms/:id/messages` - Get messages

## 🔄 Development Roadmap

### Sprint 1: Foundation ✅
- [x] Database setup
- [x] Authentication system
- [x] User management
- [x] Basic UI screens

### Sprint 2: Admin Features (In Progress)
- [ ] Admin dashboard
- [ ] Media upload functionality
- [ ] Event management
- [ ] Content tagging

### Sprint 3: User Experience
- [ ] Medical dashboard
- [ ] Education hub
- [ ] Skills training viewer
- [ ] Prescription upload

### Sprint 4: Communication
- [ ] Real-time chat
- [ ] Doctor-patient interaction
- [ ] Video streaming
- [ ] Notifications

## 🤝 Contributing

1. Follow the existing code style
2. Write tests for new features
3. Update documentation
4. Create meaningful commit messages
5. Submit pull requests for review

## 📝 Environment Variables

### Backend (.env)
```env
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=swastha_aur_abhiman
JWT_SECRET=your-secret-key
AWS_ACCESS_KEY_ID=your-key
AWS_SECRET_ACCESS_KEY=your-secret
```

### Mobile App (app_constants.dart)
```dart
static const String baseUrl = 'http://localhost:3000/api';
static const String wsUrl = 'http://localhost:3000';
```

## 🐛 Troubleshooting

### Backend Issues
- **Port 3000 in use**: Change PORT in .env or kill existing process
- **Database connection**: Verify PostgreSQL is running
- **Module not found**: Run `npm install`

### Mobile Issues
- **Build errors**: Run `flutter clean && flutter pub get`
- **API connection**: Check baseUrl in constants
- **Emulator issues**: Use correct IP (10.0.2.2 for Android)

## 📄 License

This project is licensed under UNLICENSED.

## 👨‍💻 Development Team

Built with ❤️ for government health and education initiatives.

## 📧 Contact & Support

For questions, issues, or contributions, please contact the development team.

---

**Note**: This is a government project aimed at improving access to healthcare, education, and vocational training services for underserved communities.