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
│   │   ├── admin/             # ✨ Admin dashboard & content management
│   │   ├── doctor/            # ✨ Doctor dashboard & patient management
│   │   ├── education/         # ✨ Teacher dashboard & NCERT content
│   │   ├── health/            # ✨ Health metrics tracking & analysis
│   │   ├── media/             # Media content & file upload services
│   │   ├── notifications/     # ✨ Real-time notification system
│   │   ├── nutrition/         # Nutrition & diet plans
│   │   ├── skills/            # ✨ Skills training & certification
│   │   ├── events/            # Events management
│   │   ├── prescriptions/     # Medical prescriptions
│   │   ├── chat/              # Real-time chat
│   │   └── common/            # Shared utilities
│   ├── docker-compose.yml     # Docker services
│   └── package.json
│
├── admin-dashboard/            # ✨ React Admin Web App
│   ├── src/
│   │   ├── components/        # UI components
│   │   ├── pages/             # Dashboard & login pages
│   │   ├── lib/               # API client
│   │   └── store/             # State management
│   ├── package.json
│   └── README.md
│
├── mobile-app/                 # Flutter Mobile App
│   ├── lib/
│   │   ├── core/              # Core functionality
│   │   ├── features/          # Feature modules
│   │   └── widgets/           # ✨ Reusable UI components
│   ├── pubspec.yaml
│   └── README.md
│
└── docs/                       # Documentation
    ├── plan.md
    ├── product_requirements_document.md
    ├── structure.md
    ├── system_architecture.md
    ├── API_INTEGRATION_GUIDE.md         # ✨ Complete API documentation
    ├── FILE_UPLOAD_API.md               # ✨ File upload & storage guide
    ├── IMPLEMENTATION_SUMMARY.md        # ✨ Feature implementation details
    └── PROJECT_STATUS.md                # ✨ Current project status

✨ = Recently implemented
```

## 👥 User Roles

1. **ADMIN** - System administration and content management
2. **USER** - Citizens/applicants accessing services
3. **DOCTOR** - Medical professionals providing consultations
4. **TEACHER** - Educators providing learning resources
5. **TRAINER** - Skill development experts

## 🎉 Recent Accomplishments

### Backend Implementation (100% Complete)
- ✅ **Admin Module**: Complete CRUD operations for all content types
- ✅ **Doctor Module**: Patient management, prescription reviews, health monitoring
- ✅ **Teacher Module**: Dashboard with analytics, lesson planning, student progress
- ✅ **Health Module**: Comprehensive health metrics tracking with AI analysis
- ✅ **Skills Module**: Enrollment system with certification automation
- ✅ **Notifications Module**: Real-time notification system with WebSocket support
- ✅ **File Upload**: Dual storage system (local + AWS S3/MinIO)
- ✅ **Cloud Storage**: Complete S3/MinIO integration with CDN support

### Frontend Implementation
- ✅ **Admin Dashboard**: Full-featured React web application
- ✅ **Authentication**: Login with JWT and session management
- ✅ **Content Management**: Upload, edit, delete media content
- ✅ **User Management**: Admin controls for user activation/deactivation
- ✅ **Analytics Dashboard**: Charts and statistics for content performance
- ✅ **File Upload UI**: Drag-and-drop with progress indicators
- ✅ **Storage Settings**: Toggle between local and cloud storage

### Mobile App Screens
- ✅ **Video Player Screen**: Full-featured video playback with controls
- ✅ **Health Metrics Screen**: Track and visualize health data
- ✅ **Notifications Screen**: View and manage notifications
- ✅ **Nutrition Screen**: Browse diet plans and recipes
- ✅ **Skills Hub Screen**: Enroll and track skill training progress

## 📸 Screenshot Checklist

Save all captures in the repo under `assets/screenshots/` so they travel with the codebase.

- **Admin Dashboard (React)** — place files in `assets/screenshots/admin-dashboard/`
   - Login: ![Admin - Login](assets/screenshots/admin-dashboard/login.png)
   - Dashboard overview (stats/charts): ![Admin - Dashboard](assets/screenshots/admin-dashboard/dashboard.png)
   - File upload flow: ![Admin - File Upload](assets/screenshots/admin-dashboard/file-upload.png)
   - Content management table: ![Admin - Content Management](assets/screenshots/admin-dashboard/content-management.png)
   - User management: ![Admin - User Management](assets/screenshots/admin-dashboard/user-management.png)
   - Storage/settings panel: ![Admin - Settings](assets/screenshots/admin-dashboard/settings.png)

- **Mobile App (Flutter)** — place files in `assets/screenshots/mobile-app/`
   - Login: ![Mobile - Login](assets/screenshots/mobile-app/login.png)
   - Register: ![Mobile - Register](assets/screenshots/mobile-app/register.png)
   - Home dashboard: ![Mobile - Home](assets/screenshots/mobile-app/home.png)
   - Medical dashboard: ![Mobile - Medical](assets/screenshots/mobile-app/medical.png)
   - Health metrics details: ![Mobile - Health Metrics](assets/screenshots/mobile-app/health-metrics.png)
   - Prescriptions list: ![Mobile - Prescriptions](assets/screenshots/mobile-app/prescriptions.png)
   - Upload prescription flow: ![Mobile - Upload Prescription](assets/screenshots/mobile-app/upload-prescription.png)
   - Education hub: ![Mobile - Education](assets/screenshots/mobile-app/education.png)
   - PDF/video lesson view: ![Mobile - Education Content](assets/screenshots/mobile-app/education-content.png)
   - Skills hub: ![Mobile - Skills Hub](assets/screenshots/mobile-app/skills-hub.png)
   - Skill category list: ![Mobile - Skill Category](assets/screenshots/mobile-app/skill-category.png)
   - Skill content/video player: ![Mobile - Skill Content](assets/screenshots/mobile-app/skill-content.png)
   - Nutrition hub: ![Mobile - Nutrition](assets/screenshots/mobile-app/nutrition.png)
   - Nutrition detail/video: ![Mobile - Nutrition Content](assets/screenshots/mobile-app/nutrition-content.png)
   - Events list: ![Mobile - Events](assets/screenshots/mobile-app/events.png)
   - Event detail: ![Mobile - Event Detail](assets/screenshots/mobile-app/event-detail.png)
   - Chat list: ![Mobile - Chat List](assets/screenshots/mobile-app/chat-list.png)
   - Notifications: ![Mobile - Notifications](assets/screenshots/mobile-app/notifications.png)
   - Admin dashboard: ![Mobile - Admin Dashboard](assets/screenshots/mobile-app/admin-dashboard.png)
   - Doctor dashboard: ![Mobile - Doctor Dashboard](assets/screenshots/mobile-app/doctor-dashboard.png)
   - Teacher dashboard: ![Mobile - Teacher Dashboard](assets/screenshots/mobile-app/teacher-dashboard.png)
   - Trainer dashboard: ![Mobile - Trainer Dashboard](assets/screenshots/mobile-app/trainer-dashboard.png)

Tip: keep filenames kebab-case (as above) and capture one image per bullet so broken links make it obvious what still needs a screenshot.

### Database & Architecture
- ✅ **32+ Entity Models**: Complete database schema implementation
- ✅ **TypeORM Integration**: Full ORM setup with migrations
- ✅ **Indexing & Optimization**: Performance-optimized queries
- ✅ **Relationship Mapping**: Complex many-to-many and one-to-many relations

### DevOps & Infrastructure
- ✅ **Docker Setup**: Multi-container orchestration
- ✅ **Environment Configuration**: Comprehensive .env setup
- ✅ **Storage Flexibility**: Easy switching between storage backends
- ✅ **Error Handling**: Robust error handling and validation
- ✅ **API Documentation**: Complete endpoint documentation

### Code Quality
- ✅ **TypeScript**: 100% TypeScript for type safety
- ✅ **DTOs & Validation**: Input validation with class-validator
- ✅ **Guards & Decorators**: Custom authentication guards
- ✅ **Service Architecture**: Clean separation of concerns
- ✅ **Modular Design**: Feature-based module organization

## ✨ Key Features

### 🏥 Medical Services
- ✅ **Health Metrics Tracking**: Complete system for BP, Blood Sugar, BMI, Weight, Temperature, Pulse
- ✅ **Health Sessions**: Record complete health check sessions with all vitals
- ✅ **Health Analysis**: Automatic condition evaluation (normal, elevated, high, critical)
- ✅ **Health Recommendations**: AI-powered health advice based on metrics
- ✅ **Doctor Dashboard**: Patient management, prescription review, activity feeds
- ✅ **Prescription Management**: Upload, review, and track prescriptions
- ✅ **Patient-Doctor Chat**: Real-time communication between patients and doctors
- Post-COVID recovery guidance (in progress)
- Herbal remedies information (in progress)

### 📚 Education Hub
- ✅ **NCERT Content**: Complete integration for Class 1-12 books and resources
- ✅ **Teacher Dashboard**: Content management, analytics, and student progress tracking
- ✅ **Subject & Chapter Organization**: Structured content by class, subject, and chapter
- ✅ **Content Analytics**: View counts, ratings, and engagement metrics
- ✅ **Lesson Plans**: Create and manage comprehensive lesson plans
- Educational videos (in progress)
- Interactive learning resources (planned)

### 🛠️ Skills Training
- ✅ **Skill Categories**: Bamboo work, Honeybee farming, Jute work, Macrame, Artisan training
- ✅ **Course Enrollment**: Track student enrollments and progress
- ✅ **Skill Progress Tracking**: Monitor completion percentage and milestones
- ✅ **Certification System**: Automatic certificate issuance upon completion
- ✅ **Trainer Dashboard**: Manage trainees, track progress, view analytics
- ✅ **Skill Assessments**: Quiz and evaluation system
- Video tutorials (in progress)

### 🥗 Nutrition
- ✅ **Nutrition Content Management**: Diet plans, recipes, wellness guides
- ✅ **Post-COVID Nutrition**: Specialized dietary guidance for recovery
- ✅ **Nutrition Entities**: Complete database schema for nutrition content
- Traditional food wisdom (in progress)

### 📅 Events
- ✅ **Event Management**: Create, update, and delete events
- ✅ **Event Types**: Health camps, training workshops, education programs
- ✅ **Event Registration**: Track participants and attendance
- ✅ **Assignment Notifications**: Automatic alerts for new assignments
- Community event listings (in progress)

### 💬 Communication
- ✅ **Real-time Chat**: Socket.io powered instant messaging
- ✅ **Multi-Role Chat**: User ↔ Doctor/Teacher/Trainer messaging
- ✅ **Chat Rooms**: Group discussions and private conversations
- ✅ **Message Notifications**: Real-time alerts for new messages
- ✅ **Media Sharing**: Share images and files in chat
- Video calls (planned)

### 🔔 Notifications
- ✅ **Real-time Notifications**: WebSocket-based instant alerts
- ✅ **Notification Types**: Health alerts, prescriptions, messages, assignments, certifications
- ✅ **Notification History**: 30-day retention with search and filtering
- ✅ **Read/Unread Tracking**: Mark notifications as read
- ✅ **Broadcast Notifications**: System-wide announcements
- Push notifications (planned)

### 🎛️ Admin Dashboard
- ✅ **Web-based Admin Panel**: React application for administrators
- ✅ **Media Management**: Upload, edit, delete, and organize content
- ✅ **User Management**: Activate/deactivate users, role management
- ✅ **Content Analytics**: Views, ratings, engagement statistics
- ✅ **File Upload System**: Support for videos, images, documents
- ✅ **Cloud Storage Integration**: AWS S3/MinIO support with local fallback
- ✅ **Bulk Operations**: Batch upload and CSV export
- ✅ **Storage Backend Switching**: Toggle between local and cloud storage

### 📤 File Management
- ✅ **Local File Storage**: Upload files to local server storage
- ✅ **Cloud Storage**: AWS S3 and MinIO-compatible storage
- ✅ **Dual Storage Mode**: Seamlessly switch between local and cloud
- ✅ **Thumbnail Generation**: Automatic thumbnail creation for media
- ✅ **File Type Validation**: Support for videos, images, PDFs
- ✅ **Size Limits**: Configurable file size restrictions (500MB for videos)
- ✅ **CDN Support**: CloudFront distribution integration

## 🚀 Getting Started

### Prerequisites

Before setting up the project, ensure you have the following installed:

- **Node.js 18+** - [Download](https://nodejs.org/)
- **npm 9+** - Comes with Node.js
- **Flutter SDK 3.0+** - [Download](https://flutter.dev/docs/get-started/install)
- **Docker & Docker Compose** - [Download](https://www.docker.com/products/docker-desktop)
- **PostgreSQL 15+** - [Download](https://www.postgresql.org/download/) (or use Docker)
- **Git** - [Download](https://git-scm.com/)

#### Verify Installations
```bash
node --version      # Should be v18 or higher
npm --version       # Should be 9 or higher
flutter --version   # Should be 3.0 or higher
docker --version    # Verify Docker is installed
docker-compose --version  # Verify Docker Compose is installed
```

---

### 📋 Step-by-Step Setup Guide

#### Step 1: Clone the Repository
```bash
git clone https://github.com/smirk-dev/Swasth-aur-Abhiman.git
cd Swasth-aur-Abhiman
```

#### Step 2: Setup Backend (NestJS API)

1. **Navigate to backend directory**
   ```bash
   cd backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment variables**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` with your configuration:
   ```env
   # Database Configuration
   DB_HOST=localhost
   DB_PORT=5432
   DB_USERNAME=postgres
   DB_PASSWORD=postgres
   DB_DATABASE=swastha_aur_abhiman
   
   # JWT Configuration
   JWT_SECRET=your-secret-key-here
   JWT_EXPIRES_IN=7d
   
   # Server Configuration
   PORT=3000
   NODE_ENV=development
   
   # Redis Configuration (for caching)
   REDIS_HOST=localhost
   REDIS_PORT=6379
   
   # Storage Configuration
   ENABLE_CLOUD_STORAGE=false
   ```

4. **Start Docker services** (PostgreSQL, Redis)
   ```bash
   docker-compose up -d
   ```
   
   Verify services are running:
   ```bash
   docker-compose ps
   ```

5. **Run database migrations**
   ```bash
   npm run migration:run
   ```

6. **Start the backend server**
   ```bash
   npm run start:dev
   ```
   
   The backend will be available at: `http://localhost:3000`
   
   You should see: `Nest application successfully started`

7. **Verify backend is working**
   ```bash
   curl http://localhost:3000/health
   ```

---

#### Step 3: Setup Admin Dashboard (React Web App)

1. **Open a new terminal and navigate to admin-dashboard**
   ```bash
   cd admin-dashboard
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment variables**
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env`:
   ```env
   REACT_APP_API_URL=http://localhost:3000/api
   REACT_APP_WS_URL=http://localhost:3000
   ```

4. **Start the development server**
   ```bash
   npm start
   ```
   
   The admin dashboard will open at: `http://localhost:3001`

5. **Default login credentials** (after backend seed)
   ```
   Email: admin@example.com
   Password: admin123
   ```

---

#### Step 4: Setup Mobile App (Flutter)

1. **Open a new terminal and navigate to mobile-app**
   ```bash
   cd mobile-app
   ```

2. **Get Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoints**
   
   Edit `lib/core/constants/app_constants.dart`:
   ```dart
   static const String baseUrl = 'http://localhost:3000/api';
   static const String wsUrl = 'http://localhost:3000';
   
   // For Android Emulator, use:
   // static const String baseUrl = 'http://10.0.2.2:3000/api';
   
   // For iOS Simulator, use:
   // static const String baseUrl = 'http://localhost:3000/api';
   
   // For Physical Device (replace with your IP):
   // static const String baseUrl = 'http://192.168.1.100:3000/api';
   ```

4. **List available devices**
   ```bash
   flutter devices
   ```

5. **Run the app**
   
   For Android Emulator:
   ```bash
   flutter run
   ```
   
   For iOS Simulator:
   ```bash
   open -a Simulator
   flutter run
   ```
   
   For Physical Device:
   ```bash
   flutter run -d <device-id>
   ```

6. **Enable hot reload during development**
   - Press `r` in terminal to hot reload
   - Press `R` to hot restart
   - Press `q` to quit

---

### ✅ Verification Checklist

After completing all steps, verify everything is working:

- [ ] **Backend running**: `http://localhost:3000/health` returns 200 OK
- [ ] **Database connected**: No connection errors in backend logs
- [ ] **Admin dashboard loads**: `http://localhost:3001` opens without errors
- [ ] **Admin login works**: Can log in with default credentials
- [ ] **Mobile app runs**: App starts on emulator/device without errors
- [ ] **API communication**: Mobile app can communicate with backend

---

### 🔄 Development Workflow

Once everything is set up, here's the typical development workflow:

**Terminal 1 - Backend**
```bash
cd backend
npm run start:dev
```

**Terminal 2 - Admin Dashboard**
```bash
cd admin-dashboard
npm start
```

**Terminal 3 - Mobile App**
```bash
cd mobile-app
flutter run -d emulator-5554  # or your device ID
```

**Or run all services with Docker** (optional):
```bash
docker-compose -f backend/docker-compose.yml up
```

---

### 🛠️ Useful Development Commands

**Backend**
```bash
npm run start         # Production start
npm run start:dev     # Development with auto-reload
npm run start:debug   # With debugging
npm run build         # Build for production
npm run test          # Run tests
npm run test:e2e      # Run end-to-end tests
npm run lint          # Run ESLint
npm run migration:run # Run database migrations
```

**Admin Dashboard**
```bash
npm start             # Development server
npm run build         # Production build
npm run test          # Run tests
npm run eject         # Eject from Create React App (irreversible)
```

**Mobile App**
```bash
flutter run           # Run on default device
flutter run -d chrome # Run on web (experimental)
flutter build apk     # Build Android APK
flutter build ios     # Build iOS app
flutter pub upgrade   # Update dependencies
flutter analyze       # Analyze code for issues
flutter test          # Run tests
```

---

### 📱 Running on Different Platforms

**Android Emulator**
```bash
# Set API URL in app_constants.dart
static const String baseUrl = 'http://10.0.2.2:3000/api';

# Run app
flutter run
```

**iOS Simulator**
```bash
# Set API URL in app_constants.dart
static const String baseUrl = 'http://localhost:3000/api';

# Start simulator first
open -a Simulator

# Run app
flutter run
```

**Physical Android Device**
```bash
# Enable USB debugging on device
# Connect device via USB

# Find device ID
flutter devices

# Set API URL in app_constants.dart (use your machine IP)
static const String baseUrl = 'http://192.168.1.100:3000/api';

# Run app
flutter run -d <device-id>
```

**Physical iOS Device**
```bash
# Set API URL in app_constants.dart
static const String baseUrl = 'http://192.168.1.100:3000/api';

# Run app (requires Apple developer account)
flutter run -d <device-id>
```

---

### 🐳 Docker Setup (Alternative)

If you prefer using Docker for everything:

1. **Build Docker images**
   ```bash
   docker-compose build
   ```

2. **Start all services**
   ```bash
   docker-compose up -d
   ```

3. **Check service status**
   ```bash
   docker-compose ps
   ```

4. **View logs**
   ```bash
   docker-compose logs -f backend
   docker-compose logs -f postgres
   ```

5. **Stop all services**
   ```bash
   docker-compose down
   ```

6. **Access database via Docker**
   ```bash
   docker-compose exec postgres psql -U postgres -d swastha_aur_abhiman
   ```

---

### 🚀 Quick Start (One-Command Setup)

If you want to set up everything quickly:

**macOS/Linux:**
```bash
./scripts/setup.sh
```

**Windows:**
```bash
scripts\setup.bat
```

(Note: Create these scripts based on the step-by-step guide above)

---

### 💡 Tips & Best Practices

1. **Keep dependencies updated**
   ```bash
   npm outdated      # Check for outdated packages
   npm update        # Update packages
   ```

2. **Use environment variables**
   - Never commit `.env` files
   - Keep `.env.example` updated with new variables

3. **Database best practices**
   - Always create migrations for schema changes
   - Test migrations in development first
   - Keep database backups

4. **Mobile development**
   - Use `flutter analyze` before committing code
   - Run `flutter test` to catch bugs early
   - Test on multiple devices/screen sizes

5. **Performance monitoring**
   - Use Chrome DevTools for web debugging
   - Use DevTools for Flutter debugging
   - Monitor API performance with `npm run load-test`

---

## 🎬 Features Tour & Screenshots

Explore the comprehensive features of **Swastha Aur Abhiman** across all platforms:

### 🏥 Medical Services Module

#### Health Metrics Tracking
Track and monitor vital health indicators in real-time.

**Features:**
- 📊 Record multiple health metrics: Blood Pressure, Blood Sugar, BMI, Weight, Temperature, Pulse
- 📈 Visual charts and trend analysis over time
- 🎯 Health status indicators (Normal, Elevated, High, Critical)
- 🔔 Automatic alerts for abnormal readings
- 📋 Complete health session history

**Screenshots:**
- `screenshots/health-metrics-tracking.png` - Metrics recording interface
- `screenshots/health-trends.png` - Health trends visualization
- `screenshots/health-analysis.png` - AI-powered health analysis

**How to Use:**
1. Open the Health section in mobile app
2. Click "Record Metrics"
3. Input vital readings (BP, Blood Sugar, BMI, etc.)
4. View automatic analysis and recommendations
5. Check trends in the "Health History" tab

---

#### Doctor Dashboard
Comprehensive patient management system for medical professionals.

**Features:**
- 👥 Patient list with search and filtering
- 📊 Patient health metrics and medical history
- 💊 Prescription management and review
- 📝 Patient notes and consultation records
- 📊 Health analytics per patient
- 🔔 Real-time notifications for new patient activities
- 💬 Direct messaging with patients

**Screenshots:**
- `screenshots/doctor-dashboard.png` - Main dashboard overview
- `screenshots/doctor-patients.png` - Patient list view
- `screenshots/doctor-patient-detail.png` - Detailed patient profile
- `screenshots/doctor-prescriptions.png` - Prescription review interface
- `screenshots/doctor-chat.png` - Patient-doctor chat

**Key Sections:**
1. **Patients Tab** - View all assigned patients
   - Search by name/ID
   - Filter by health status
   - Sort by recent activity
   - View patient summaries

2. **Health Records Tab** - Access patient health data
   - View complete health history
   - Analyze trends and patterns
   - Add clinical notes
   - Generate health reports

3. **Prescriptions Tab** - Manage medical prescriptions
   - Review uploaded prescriptions
   - Add notes and recommendations
   - Update prescription status
   - Track prescription compliance

4. **Chat Tab** - Real-time communication
   - Message patients directly
   - Receive patient health updates
   - Share medical resources
   - Schedule consultations

---

### 📚 Education Hub

#### Teacher Dashboard
Complete content management system for educators.

**Features:**
- 📚 NCERT content management (Class 1-12)
- 📊 Student progress tracking and analytics
- ✏️ Lesson plan creation and management
- 📈 Performance metrics and engagement statistics
- 🎯 Assignment distribution and tracking
- 📊 Class-wise analytics and reports
- 📁 Content organization by subject and chapter

**Screenshots:**
- `screenshots/teacher-dashboard.png` - Teacher dashboard overview
- `screenshots/teacher-classes.png` - Class management
- `screenshots/teacher-content.png` - NCERT content browser
- `screenshots/teacher-analytics.png` - Student analytics dashboard
- `screenshots/teacher-lesson-plans.png` - Lesson planning interface

**Key Features:**
1. **Content Management**
   - Browse NCERT books by class and subject
   - Upload supplementary materials
   - Organize content with tags
   - Track content performance

2. **Student Progress**
   - Monitor student engagement
   - Track assignment completion
   - View performance metrics
   - Generate progress reports

3. **Analytics**
   - View class-wide statistics
   - Identify struggling students
   - Analyze content popularity
   - Track learning outcomes

4. **Lesson Planning**
   - Create detailed lesson plans
   - Link to NCERT content
   - Schedule lessons
   - Assign homework and assessments

---

#### Student/User Learning View
Intuitive learning interface for students.

**Features:**
- 📖 Browse NCERT content by class and subject
- 📺 Video tutorials and educational materials
- ✏️ Interactive assessments and quizzes
- 📊 Progress tracking and badges
- 📝 Notes and bookmarks
- 🎓 Download certificates upon completion
- 💬 Ask questions to teachers (in progress)

**Screenshots:**
- `screenshots/student-home.png` - Student home screen
- `screenshots/student-subjects.png` - Subject selection
- `screenshots/student-content-viewer.png` - Content viewing interface
- `screenshots/student-progress.png` - Progress tracking

---

### 🛠️ Skills Training Module

#### Trainer Dashboard
Manage vocational and skill training programs.

**Features:**
- 👥 Trainee management and enrollment
- 📊 Skills progress tracking per trainee
- 🎓 Automated certificate generation
- 📈 Training analytics and reports
- 📋 Course content management
- 🎯 Skill assessment and evaluations
- 💼 Job placement tracking

**Screenshots:**
- `screenshots/trainer-dashboard.png` - Trainer overview
- `screenshots/trainer-trainees.png` - Trainee management
- `screenshots/trainer-progress.png` - Training progress tracking
- `screenshots/trainer-certificates.png` - Certificate management
- `screenshots/trainer-analytics.png` - Training analytics

**Supported Skills:**
- 🎍 Bamboo Work
- 🐝 Honeybee Farming
- 🧵 Jute Work
- 🎨 Macrame
- 👨‍🏫 Artisan Training

**How to Use:**
1. View enrolled trainees
2. Monitor training progress
3. Review skill assessments
4. Issue certificates upon completion
5. Generate training reports

---

#### Skills Hub (Student View)
Access skill training programs and track progress.

**Features:**
- 🔍 Browse available skills and courses
- 📝 Enroll in training programs
- 📊 Track training progress
- 📜 Earn and download certificates
- 💬 Communicate with trainers
- 🏆 View earned badges and achievements
- 📹 Access training videos and materials

**Screenshots:**
- `screenshots/skills-browse.png` - Skills catalog
- `screenshots/skills-enroll.png` - Enrollment interface
- `screenshots/skills-progress.png` - Training progress
- `screenshots/skills-certificate.png` - Certificate display

---

### 🍽️ Nutrition Module

#### Nutrition Plans & Dietary Guidance
Personalized nutrition and wellness recommendations.

**Features:**
- 📋 Browse diet plans and recipes
- 🥗 Nutrition information and calorie tracking
- 🏥 Post-COVID nutrition guidance
- 🌿 Traditional food wisdom and remedies
- 📊 Personalized recommendations based on health metrics
- 🔖 Save favorite recipes
- 📥 Download meal plans
- 🍽️ Food substitution suggestions

**Screenshots:**
- `screenshots/nutrition-home.png` - Nutrition hub
- `screenshots/nutrition-plans.png` - Available diet plans
- `screenshots/nutrition-recipes.png` - Recipe browsing
- `screenshots/nutrition-details.png` - Nutrition information
- `screenshots/nutrition-postcovid.png` - Post-COVID guidance

**Content Categories:**
- General Wellness
- Post-COVID Recovery
- Disease-Specific Diets
- Weight Management
- Traditional Remedies

---

### 💬 Real-Time Communication

#### Chat System
Seamless messaging between different user roles.

**Features:**
- 👥 One-on-one and group chats
- ⚡ Real-time messaging with WebSocket
- 📸 Share images and files in chat
- 📞 Chat notifications and unread counters
- 🔍 Search message history
- 🔒 Encrypted communication
- 📱 Mobile and web support

**Supported Conversations:**
- Patient ↔ Doctor
- Student ↔ Teacher
- Trainee ↔ Trainer
- User ↔ Admin Support

**Screenshots:**
- `screenshots/chat-list.png` - Chat rooms list
- `screenshots/chat-messages.png` - Chat conversation
- `screenshots/chat-media.png` - Media sharing in chat
- `screenshots/chat-notifications.png` - Chat notifications

**Usage:**
1. Open Chat section
2. Select conversation or create new
3. Type message and send
4. Receive real-time notifications
5. Share media directly in chat

---

### 🔔 Notifications System

#### Real-Time Alerts & Updates
Stay informed with instant notifications.

**Features:**
- 🔔 Real-time WebSocket notifications
- 📱 Push notifications (planned)
- 🎯 Notification categorization
  - Health alerts
  - Prescription updates
  - Assignment reminders
  - Message notifications
  - System announcements
- 📋 Notification history (30 days)
- ✅ Mark as read/unread
- 🔍 Search notifications
- ⚙️ Notification preferences (planned)

**Notification Types:**
- **Health**: Abnormal health readings, prescription alerts
- **Education**: New assignments, grades, announcements
- **Skills**: Enrollment confirmations, progress updates, certificates
- **Chat**: New messages, message replies
- **System**: Maintenance notices, updates

**Screenshots:**
- `screenshots/notifications-center.png` - Notification hub
- `screenshots/notifications-types.png` - Different notification types
- `screenshots/notifications-history.png` - Notification history
- `screenshots/notifications-settings.png` - Notification preferences

---

### 🎛️ Admin Dashboard (Web)

#### Content Management
Comprehensive admin panel for system management.

**Features:**
- 📤 Media upload (videos, images, documents)
- 🏷️ Content tagging and categorization
- 📊 Analytics dashboard
- 👥 User management and role assignment
- 🔑 Access control and permissions
- 📋 Bulk upload capabilities
- ☁️ Cloud storage configuration (AWS S3/MinIO)
- 💾 Toggle between local and cloud storage
- 📥 CSV export functionality
- 🔐 Secure file management with versioning

**Screenshots:**
- `screenshots/admin-dashboard.png` - Admin dashboard
- `screenshots/admin-media.png` - Media management
- `screenshots/admin-upload.png` - File upload interface
- `screenshots/admin-users.png` - User management
- `screenshots/admin-analytics.png` - Analytics dashboard
- `screenshots/admin-settings.png` - System settings

**Key Sections:**

1. **Dashboard**
   - System overview
   - Quick stats
   - Recent activities
   - Performance metrics

2. **Media Management**
   - Upload new media
   - Edit metadata
   - Delete/archive content
   - View analytics
   - Organize by category

3. **User Management**
   - View all users
   - Filter by role
   - Activate/deactivate accounts
   - Reset passwords
   - Export user list

4. **Analytics**
   - Content performance metrics
   - User engagement statistics
   - Health trend analysis
   - Revenue reports
   - Custom date ranges

5. **Settings**
   - Storage configuration
   - API keys management
   - Email settings
   - System preferences
   - Backup and restore

---

### 📱 Mobile App Interface

#### Home Screen
Dashboard with quick access to all features.

**Components:**
- 👤 User profile section
- 🔔 Notification bell with unread count
- 🎯 Quick action buttons
- 📰 News and announcements feed
- 🔗 Quick links to main modules

**Screenshots:**
- `screenshots/mobile-home.png` - Home screen
- `screenshots/mobile-navigation.png` - Bottom navigation bar

#### Navigation Structure
```
📱 Bottom Navigation Bar
├── 🏠 Home
│   ├── Dashboard
│   ├── Quick Actions
│   └── Announcements
├── 🏥 Health
│   ├── Record Metrics
│   ├── Health History
│   ├── Prescriptions
│   └── Doctor Chat
├── 📚 Education
│   ├── Browse Content
│   ├── My Progress
│   ├── Assignments
│   └── Teacher Chat
├── 💼 Skills
│   ├── Available Courses
│   ├── My Enrollments
│   ├── Progress Tracking
│   └── Certificates
├── 🍽️ Nutrition
│   ├── Diet Plans
│   ├── Recipes
│   ├── Recommendations
│   └── Wellness Guides
├── 💬 Chat
│   ├── Messages
│   └── Notifications
└── 👤 Profile
    ├── Profile Info
    ├── Settings
    ├── Preferences
    └── Logout
```

---

### 🔐 Authentication & Security

#### Login Screen
Secure user authentication.

**Features:**
- 📧 Email-based login
- 🔐 Password security
- 🔄 Forgot password recovery
- 📝 New user registration
- ✅ Email verification
- 🔒 JWT token-based sessions
- 🛡️ Account lockout after failed attempts

**Screenshots:**
- `screenshots/login-screen.png` - Login interface
- `screenshots/signup-screen.png` - Registration screen
- `screenshots/password-reset.png` - Password recovery

**User Roles After Login:**
- 👤 **Regular User** - Access health, education, skills, nutrition
- 🏥 **Doctor** - Full doctor dashboard + user features
- 👨‍🏫 **Teacher** - Full teacher dashboard + user features
- 👨‍🏫 **Trainer** - Full trainer dashboard + user features
- 🔑 **Admin** - Full system access via admin dashboard

---

#### User Profile
Personal information and preferences.

**Features:**
- 👤 Profile information editing
- 📸 Profile picture upload
- 📞 Contact details management
- 🗺️ Address and location
- 🏥 Medical information (for doctors)
- 🎓 Educational background (for teachers)
- ⚙️ App preferences and settings
- 🔔 Notification preferences
- 🌙 Theme selection (light/dark mode)
- 🌍 Language preferences (planned)

**Screenshots:**
- `screenshots/profile-view.png` - Profile display
- `screenshots/profile-edit.png` - Profile editing
- `screenshots/profile-settings.png` - App settings
- `screenshots/profile-preferences.png` - User preferences

---

### 📊 Analytics & Reporting

#### Health Analytics
Comprehensive health data visualization.

**Features:**
- 📈 Trend analysis for all health metrics
- 📊 Comparative analysis (current vs. previous)
- 🎯 Health status indicators
- 📋 Generate health reports
- 📥 Export data as CSV/PDF
- 🔍 Filter by date range
- 💾 Health history archive

**Visualizations:**
- Line charts for trends
- Bar charts for comparisons
- Gauge indicators for status
- Summary cards with key metrics

**Screenshots:**
- `screenshots/analytics-health.png` - Health analytics
- `screenshots/analytics-trends.png` - Trend visualization
- `screenshots/analytics-reports.png` - Health reports

#### Content Analytics
Track content performance and engagement.

**Available to:**
- Teachers (for educational content)
- Admins (for all content)
- Trainers (for course materials)

**Metrics:**
- 👁️ View counts
- ⭐ Ratings and reviews
- 📝 Comments and feedback
- ⏱️ Average view duration
- 📊 Engagement rates
- 🔝 Most popular content
- 📉 Least engaging content

**Screenshots:**
- `screenshots/analytics-content.png` - Content performance
- `screenshots/analytics-engagement.png` - Engagement metrics

---

## 📖 Documentation

Detailed documentation is available in the `docs/` directory and root:

### Core Documentation
- [Product Requirements Document](docs/product_requirements_document.md) - Complete product specification
- [System Architecture](docs/system_architecture.md) - Technical architecture details
- [Sprint Plan](docs/plan.md) - Development sprint planning
- [Project Structure](docs/structure.md) - Codebase organization

### Implementation Guides
- [API Integration Guide](API_INTEGRATION_GUIDE.md) - Complete API endpoint documentation
- [File Upload API](FILE_UPLOAD_API.md) - File upload and storage implementation
- [Implementation Summary](IMPLEMENTATION_SUMMARY.md) - Feature-by-feature implementation details
- [Backend Compilation Fixes](BACKEND_COMPILATION_FIXES.md) - TypeScript compilation troubleshooting
- [Notification Integration](backend/src/notifications/NOTIFICATION_INTEGRATION_GUIDE.md) - Notification system integration

### Project Status
- [Project Status](PROJECT_STATUS.md) - Current development status and progress
- [Remaining Tasks](REMAINING_TASKS_IMPLEMENTATION.md) - Pending features and enhancements

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
- **Users**: Authentication and profile management
- **User Profiles**: Detailed user information and preferences
- **Doctor Profiles**: Medical credentials and specializations
- **Teacher Profiles**: Educational background and subjects
- **Trainer Profiles**: Expertise areas and certifications

### Health & Medical
- **Health Metrics**: BP, blood sugar, BMI, weight, temperature, pulse tracking
- **Health Metric Sessions**: Complete health check records
- **Prescriptions**: Medical prescriptions with status tracking

### Education & Training
- **Media Content**: Videos, documents, and educational materials
- **Skill Enrollments**: Student skill course enrollments
- **Skill Progress**: Course completion tracking
- **Lesson Plans**: Teacher-created lesson plans

### Communication
- **Chat Rooms**: One-on-one and group chat rooms
- **Messages**: Real-time chat messages with media support
- **Notifications**: System-wide notification tracking

### Events & Nutrition
- **Events**: Community events, assignments, and activities
- **Nutrition**: Diet plans, recipes, and wellness content

## 🌐 API Endpoints

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `GET /api/auth/profile` - Get current user profile

### Admin Endpoints
- `POST /admin/media/upload` - Upload media content
- `POST /admin/media/upload-file` - Upload with file
- `POST /admin/media/bulk-upload` - Bulk media upload
- `GET /admin/media` - Get all media with filters
- `PUT /admin/media/:id` - Update media content
- `DELETE /admin/media/:id` - Soft delete media
- `GET /admin/analytics` - Dashboard analytics
- `GET /admin/users` - User management
- `POST /admin/events` - Create events

### Doctor Endpoints
- `GET /doctor/patients` - Get patient list
- `GET /doctor/patients/:id` - Patient details with health records
- `GET /doctor/patients/:id/health-summary` - Patient health summary
- `GET /doctor/patients/:id/metrics` - Patient metrics history
- `GET /doctor/prescriptions` - Get all prescriptions
- `POST /doctor/prescriptions/:id/notes` - Add prescription notes
- `PUT /doctor/prescriptions/:id/status` - Update prescription status
- `GET /doctor/dashboard` - Doctor dashboard overview

### Teacher Endpoints
- `GET /teacher/dashboard` - Teacher dashboard overview
- `GET /teacher/classes` - Get all classes
- `GET /teacher/classes/:classLevel/subjects` - Subjects for a class
- `GET /teacher/classes/:classLevel/subjects/:subject/chapters` - Chapter content
- `POST /teacher/lesson-plans` - Create lesson plan
- `GET /teacher/content/:contentId/progress` - Student progress
- `GET /teacher/analytics` - Teaching analytics
- `GET /teacher/export/csv` - Export content data

### Health Endpoints
- `POST /health/metrics` - Record health metric
- `GET /health/metrics` - Get user's health metrics
- `GET /health/metrics/latest` - Latest metrics for all types
- `GET /health/summary` - Health summary with trends
- `GET /health/metrics/range` - Metrics for date range
- `GET /health/recommendations` - Health recommendations
- `POST /health/sessions` - Record complete health session
- `GET /health/sessions` - Get health sessions
- `POST /health/analyze/bp` - Analyze blood pressure
- `POST /health/analyze/blood-sugar` - Analyze blood sugar
- `POST /health/analyze/bmi` - Analyze BMI

### Skills & Training Endpoints
- `POST /skills/enroll` - Enroll in skill training
- `GET /skills/my-enrollments` - User's enrollments
- `GET /skills/enrollment/:id/progress` - Enrollment progress
- `POST /skills/progress/:id/complete` - Mark course complete
- `GET /skills/certificates` - User's certificates
- `GET /trainer/trainees` - Get all trainees
- `GET /trainer/dashboard` - Trainer dashboard
- `GET /trainer/analytics` - Training analytics

### Notifications Endpoints
- `GET /notifications` - Get user notifications
- `GET /notifications/unread` - Get unread notifications
- `PATCH /notifications/:id/read` - Mark notification as read
- `PATCH /notifications/mark-all-read` - Mark all as read
- `DELETE /notifications/:id` - Delete notification

### Media & Content
- `GET /media` - Get all media content
- `GET /media/:id` - Get media by ID
- `POST /media` - Create media content (Admin)
- `PATCH /media/:id` - Update media content
- `DELETE /media/:id` - Delete media content

### Prescriptions
- `POST /prescriptions` - Upload prescription
- `GET /prescriptions` - Get user's prescriptions
- `PATCH /prescriptions/:id/review` - Review prescription (Doctor)

### Chat
- `POST /chat/rooms` - Create chat room
- `GET /chat/rooms` - Get user's chat rooms
- `GET /chat/rooms/:id/messages` - Get messages
- `POST /chat/rooms/:id/messages` - Send message
- `WebSocket /chat` - Real-time chat connection

### Events
- `GET /events` - Get all events
- `GET /events/:id` - Get event details
- `POST /events` - Create event (Admin/Teacher)
- `PUT /events/:id` - Update event
- `DELETE /events/:id` - Delete event

## 🔄 Development Roadmap

### ✅ Sprint 1: Foundation (COMPLETED)
- [x] Database setup with PostgreSQL & TypeORM
- [x] Authentication system with JWT
- [x] User management with role-based access
- [x] Basic Flutter UI screens
- [x] Docker configuration

### ✅ Sprint 2: Core Features (COMPLETED)
- [x] Admin dashboard (React web app)
- [x] Media upload functionality (local & cloud)
- [x] Event management system
- [x] Content tagging and organization
- [x] Health metrics tracking system
- [x] Prescription management
- [x] Real-time notification system

### ✅ Sprint 3: Role-Specific Dashboards (COMPLETED)
- [x] Doctor dashboard with patient management
- [x] Teacher dashboard with content analytics
- [x] Trainer dashboard for skill training
- [x] Health analysis and recommendations
- [x] Skills enrollment and progress tracking
- [x] Certificate generation system

### ✅ Sprint 4: Advanced Features (COMPLETED)
- [x] Real-time chat with Socket.io
- [x] File upload with S3/MinIO integration
- [x] Storage backend switching (local/cloud)
- [x] Bulk upload operations
- [x] Analytics and reporting
- [x] CSV export functionality
- [x] Notification integration across modules

### 🚧 Sprint 5: Mobile App Enhancement (IN PROGRESS)
- [ ] Video player screen implementation
- [ ] Health metrics visualization
- [ ] Skills hub with progress tracking
- [ ] Nutrition recommendation engine
- [ ] Enhanced chat UI with media preview
- [ ] Offline data caching
- [ ] Push notifications (FCM)

### 📋 Sprint 6: Polish & Production (PLANNED)
- [ ] Performance optimization
- [ ] Security hardening
- [ ] Load testing and scaling
- [ ] Comprehensive testing suite
- [ ] Production deployment setup
- [ ] User documentation
- [ ] Admin training materials
- [ ] API rate limiting
- [ ] Monitoring and logging

### 🎯 Future Enhancements
- [ ] Video calling for doctor consultations
- [ ] AI-powered health recommendations
- [ ] Multilingual support (Hindi, regional languages)
- [ ] Mobile app for doctors and teachers
- [ ] Advanced analytics dashboard
- [ ] Integration with government health systems
- [ ] SMS notifications for low-bandwidth users
- [ ] Offline-first mobile app capabilities

## 🤝 Contributing

1. Follow the existing code style
2. Write tests for new features
3. Update documentation
4. Create meaningful commit messages
5. Submit pull requests for review

## 📝 Environment Variables

### Backend (.env)
```env
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=swastha_aur_abhiman

# JWT Authentication
JWT_SECRET=your-secret-key
JWT_EXPIRES_IN=7d

# AWS S3 / Cloud Storage (Optional)
ENABLE_CLOUD_STORAGE=false
AWS_ACCESS_KEY_ID=your-key
AWS_SECRET_ACCESS_KEY=your-secret
AWS_REGION=us-east-1
S3_BUCKET_NAME=your-bucket-name
CLOUDFRONT_DOMAIN=your-cdn-domain.cloudfront.net

# MinIO Configuration (Alternative to AWS S3)
USE_MINIO=false
MINIO_ENDPOINT=http://localhost:9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin

# Server Configuration
PORT=3000
NODE_ENV=development

# File Upload Limits
MAX_FILE_SIZE=524288000  # 500MB in bytes
MAX_FILES_PER_UPLOAD=10

# CORS Configuration
CORS_ORIGIN=http://localhost:3001,http://localhost:8080
```

### Admin Dashboard (.env)
```env
REACT_APP_API_URL=http://localhost:3000/api
REACT_APP_WS_URL=http://localhost:3000
```

### Mobile App (app_constants.dart)
```dart
static const String baseUrl = 'http://localhost:3000/api';
static const String wsUrl = 'http://localhost:3000';

// For Android Emulator, use:
// static const String baseUrl = 'http://10.0.2.2:3000/api';

// For iOS Simulator, use:
// static const String baseUrl = 'http://localhost:3000/api';

// For Physical Device, use your computer's IP:
// static const String baseUrl = 'http://192.168.x.x:3000/api';
```

## 🐛 Troubleshooting

### Backend Issues
- **Port 3000 in use**: Change PORT in .env or kill existing process
  ```bash
  # Windows
  netstat -ano | findstr :3000
  taskkill /PID <PID> /F
  
  # Linux/Mac
  lsof -ti:3000 | xargs kill -9
  ```
- **Database connection**: Verify PostgreSQL is running
  ```bash
  docker ps  # Check if postgres container is running
  docker-compose up -d  # Start services
  ```
- **Module not found**: Run `npm install` and restart server
- **TypeScript errors**: Check `tsconfig.json` and run `npm run build`
- **File upload errors**: Verify `uploads/` directory exists and has write permissions
- **Cloud storage errors**: Check AWS/MinIO credentials in .env

### Admin Dashboard Issues
- **API connection failed**: Verify `REACT_APP_API_URL` in .env matches backend URL
- **CORS errors**: Add frontend URL to backend CORS configuration
- **Build errors**: Clear cache with `rm -rf node_modules package-lock.json && npm install`
- **Login issues**: Check JWT_SECRET matches between frontend and backend

### Mobile Issues
- **Build errors**: Run `flutter clean && flutter pub get`
- **API connection**: Check baseUrl in constants
  - Android Emulator: `http://10.0.2.2:3000/api`
  - iOS Simulator: `http://localhost:3000/api`
  - Physical Device: `http://<YOUR_IP>:3000/api`
- **Emulator issues**: Use correct IP address for your platform
- **WebSocket connection**: Ensure firewall allows WebSocket connections
- **Hot reload not working**: Restart Flutter app or run `flutter clean`

### Database Issues
- **Migration errors**: Run `npm run migration:run` in backend
- **Connection refused**: Check PostgreSQL is running on correct port
- **Data inconsistency**: Clear database and run migrations from scratch
  ```bash
  docker-compose down -v  # Remove volumes
  docker-compose up -d    # Recreate database
  npm run migration:run   # Run migrations
  ```

### Storage Issues
- **Local storage full**: Check disk space and clean old uploads
- **Cloud upload timeout**: Increase timeout in cloud-storage.service.ts
- **Permission denied**: Check file/directory permissions for uploads folder
- **S3 access denied**: Verify IAM permissions and bucket policy

## � Screenshots

![](assets/Screenshot%202026-01-14%20185311.png)

![](assets/Screenshot%202026-01-14%20185406.png)

![](assets/Screenshot%202026-01-14%20185430.png)

![](assets/Screenshot%202026-01-14%20185458.png)

![](assets/Screenshot%202026-01-14%20185602.png)

![](assets/Screenshot%202026-01-14%20185701.png)

![](assets/Screenshot%202026-01-14%20185721.png)

![](assets/Screenshot%202026-01-14%20185804.png)

![](assets/Screenshot%202026-01-14%20185835.png)

![](assets/Screenshot%202026-01-14%20185850.png)

![](assets/Screenshot%202026-01-14%20185942.png)

![](assets/Screenshot%202026-01-14%20190019.png)

![](assets/Screenshot%202026-01-14%20190035.png)

![](assets/Screenshot%202026-01-14%20190114.png)

![](assets/Screenshot%202026-01-14%20190138.png)

![](assets/Screenshot%202026-01-14%20190153.png)

![](assets/Screenshot%202026-01-14%20190205.png)

![](assets/Screenshot%202026-01-14%20190244.png)

![](assets/Screenshot%202026-01-14%20190258.png)

![](assets/Screenshot%202026-01-14%20190316.png)

![](assets/Screenshot%202026-01-14%20190328.png)

![](assets/Screenshot%202026-01-14%20190344.png)

![](assets/Screenshot%202026-01-14%20190433.png)

![](assets/Screenshot%202026-01-14%20190523.png)

![](assets/Screenshot%202026-01-14%20190657.png)

![](assets/Screenshot%202026-01-14%20190812.png)

## �📄 License

This project is licensed under UNLICENSED.

## 👨‍💻 Development Team

Built with ❤️ for government health and education initiatives.

## 📧 Contact & Support

For questions, issues, or contributions, please contact the development team.

---

**Note**: This is a government project aimed at improving access to healthcare, education, and vocational training services for underserved communities.