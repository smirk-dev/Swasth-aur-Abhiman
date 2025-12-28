import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/constants/app_constants.dart';
import '../repositories/auth_repository.dart';
import '../models/auth_models.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});

class AuthState {
  final User? user;
  final bool isLoading;
  final bool isInitialized;
  final String? error;

  AuthState({
    this.user,
    this.isLoading = false,
    this.isInitialized = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    bool? isInitialized,
    String? error,
    bool clearUser = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final StorageService _storageService;

  AuthNotifier(this._authRepository, this._storageService) : super(AuthState()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final token = await _storageService.getString(AppConstants.tokenKey);
      final userData = await _storageService.getMap(AppConstants.userKey);

      if (token != null && userData != null) {
        state = state.copyWith(
          user: User.fromJson(userData),
          isInitialized: true,
        );
      } else {
        state = state.copyWith(isInitialized: true);
      }
    } catch (e) {
      state = state.copyWith(isInitialized: true);
    }
  }

  Future<bool> login(String email, String password, String role) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = LoginRequest(
        email: email,
        password: password,
        role: role,
      );

      final response = await _authRepository.login(request);

      await _storageService.saveString(AppConstants.tokenKey, response.accessToken);
      await _storageService.saveMap(AppConstants.userKey, response.user.toJson());

      state = state.copyWith(user: response.user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> register(RegisterRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authRepository.register(request);

      await _storageService.saveString(AppConstants.tokenKey, response.accessToken);
      await _storageService.saveMap(AppConstants.userKey, response.user.toJson());

      state = state.copyWith(user: response.user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _storageService.remove(AppConstants.tokenKey);
    await _storageService.remove(AppConstants.userKey);
    state = AuthState(isInitialized: true);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final storageService = ref.watch(storageServiceProvider);
  return AuthNotifier(authRepository, storageService);
});
