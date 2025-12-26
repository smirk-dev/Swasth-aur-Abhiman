# Swastha Aur Abhiman - Mobile App

Flutter-based mobile application for the Swastha Aur Abhiman health, education, and training platform.

## 🚀 Features

- **Multi-Role Authentication**: Support for User, Doctor, Teacher, Trainer, and Admin roles
- **Medical Dashboard**: Health tracking, prescription uploads, and doctor consultations
- **Education Hub**: Access to NCERT books (Class 1-12) and educational content
- **Skills Training**: Vocational training videos (Bamboo, Honeybee farming, etc.)
- **Nutrition**: Diet plans and Post-COVID recovery guidance
- **Events**: Community event listings and registration
- **Real-time Chat**: Inter-role messaging system
- **Admin Panel**: Content management and user approval

## 📋 Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / Xcode for mobile development
- VS Code or Android Studio with Flutter plugins

## 🛠️ Installation

### 1. Install Flutter
Follow the official Flutter installation guide:
- https://flutter.dev/docs/get-started/install

### 2. Clone and Setup
```bash
cd mobile-app
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Configure API Endpoint
Edit `lib/core/constants/app_constants.dart`:
```dart
class AppConstants {
  static const String baseUrl = 'http://YOUR_API_URL:3000/api';
  static const String wsUrl = 'http://YOUR_API_URL:3000';
  // ...
}
```

For local development:
- Android Emulator: `http://10.0.2.2:3000/api`
- iOS Simulator: `http://localhost:3000/api`
- Physical Device: `http://YOUR_COMPUTER_IP:3000/api`

## 🏃 Running the Application

### Development Mode
```bash
# Run on connected device/emulator
flutter run

# Run with specific device
flutter devices
flutter run -d <device-id>

# Run in debug mode with hot reload
flutter run --debug
```

### Build for Production

#### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

#### iOS
```bash
# Build for iOS
flutter build ios --release
```

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (11.0+)
- 🔄 Web (Future support)
- 🔄 Desktop (Future support)

## 🎨 App Architecture

The app follows Clean Architecture principles with feature-based organization:

```
lib/
├── core/                      # Core functionality
│   ├── constants/             # App-wide constants
│   ├── network/               # API clients (Dio)
│   ├── router/                # Navigation (GoRouter)
│   ├── services/              # Shared services
│   └── theme/                 # App theming
│
├── features/                  # Feature modules
│   ├── auth/                  # Authentication
│   │   ├── models/            # Data models
│   │   ├── providers/         # Riverpod state management
│   │   ├── repositories/      # Data layer
│   │   └── presentation/      # UI screens & widgets
│   │
│   ├── home/                  # Home dashboard
│   ├── medical/               # Medical features
│   ├── education/             # Education hub
│   ├── skills/                # Skills training
│   ├── nutrition/             # Nutrition guidance
│   ├── events/                # Events listing
│   ├── chat/                  # Real-time messaging
│   └── admin/                 # Admin dashboard
│
└── main.dart                  # App entry point
```

## 🔑 Key Dependencies

- **flutter_riverpod**: State management
- **go_router**: Navigation and routing
- **dio**: HTTP client for API calls
- **hive**: Local database for offline storage
- **socket_io_client**: WebSocket for real-time chat
- **image_picker**: Camera and gallery access
- **video_player**: Video playback
- **fl_chart**: Health metrics charts

## 🎯 User Roles

### 1. **USER (Citizen/Applicant)**
- Health tracking (BP, Sugar, BMI)
- Upload prescriptions
- Access education materials
- View training videos
- Chat with doctors/teachers/trainers

### 2. **DOCTOR**
- View patient prescriptions
- Provide medical consultations
- Access medical content
- Chat with users

### 3. **TEACHER**
- Access educational content
- Chat with users
- View education materials

### 4. **TRAINER**
- Access training content
- Chat with users
- Share skill development resources

### 5. **ADMIN**
- Complete system management
- Upload content across all domains
- User approval and management
- Event creation

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

## 🔐 Security Features

- JWT-based authentication
- Secure token storage using SharedPreferences
- Role-based access control
- Encrypted API communication (HTTPS in production)
- Secure file upload to S3

## 📊 State Management

The app uses **Riverpod** for state management with the following patterns:

```dart
// Provider Example
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final storageService = ref.watch(storageServiceProvider);
  return AuthNotifier(authRepository, storageService);
});
```

## 🎨 Theming

The app uses Material Design 3 with custom theme:
- Primary Color: Green (#2E7D32) - Represents health
- Secondary Color: Orange (#FF9800) - Represents education
- Accent Color: Blue (#1976D2) - Represents technology

## 🌐 Localization

Current language support:
- English (Default)

Future support:
- Hindi
- Regional languages

## 🔧 Common Issues

### Issue: Build fails with dependency errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Issue: API connection fails
- Check if backend server is running
- Verify API URL in `app_constants.dart`
- Check network connectivity
- For Android emulator, use `10.0.2.2` instead of `localhost`

### Issue: Hot reload not working
```bash
# Restart with hot reload enabled
flutter run --hot
```

## 📱 Screenshots

[Add screenshots here once available]

## 🚀 Deployment

### Android Play Store
1. Update version in `pubspec.yaml`
2. Build app bundle: `flutter build appbundle --release`
3. Upload to Play Console

### iOS App Store
1. Update version in `pubspec.yaml`
2. Build iOS: `flutter build ios --release`
3. Open in Xcode and submit to App Store

## 📝 Development Guidelines

1. **Code Style**: Follow Dart style guide
2. **Naming**: Use descriptive names for variables and functions
3. **Comments**: Document complex logic
4. **State Management**: Use Riverpod providers
5. **Error Handling**: Use try-catch blocks and show user-friendly messages
6. **UI**: Follow Material Design guidelines

## 🔄 Future Enhancements

- [ ] Offline mode support
- [ ] Push notifications
- [ ] Video call integration
- [ ] Multi-language support
- [ ] Advanced health analytics
- [ ] PDF generation for prescriptions

## 📄 License

This project is licensed under UNLICENSED.

## 👥 Support

For issues and questions, please contact the development team.
