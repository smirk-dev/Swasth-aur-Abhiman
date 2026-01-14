class AppConstants {
  // API Configuration
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );
  static const String wsUrl = String.fromEnvironment(
    'WS_URL',
    defaultValue: 'ws://localhost:3000',
  );
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String roleKey = 'user_role';
  
  // Pagination
  static const int pageSize = 20;
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

enum UserRole {
  admin,
  user,
  doctor,
  teacher,
  trainer,
}

enum Block {
  vikasnagar,
  doiwala,
  sahaspur,
}

enum Gender {
  male,
  female,
  other,
}

enum MediaCategory {
  medical,
  education,
  skill,
  nutrition,
}
