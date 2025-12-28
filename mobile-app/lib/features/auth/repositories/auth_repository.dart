import 'package:dio/dio.dart';
import '../models/auth_models.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: request.toJson(),
      );

      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: request.toJson(),
      );

      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  String _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'Connection timeout. Please check your internet connection.';
    }

    if (error.type == DioExceptionType.connectionError) {
      return 'Unable to connect to server. Please ensure the backend is running and try again.';
    }

    if (error.response != null) {
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;

      if (statusCode == 401) {
        return 'Invalid email or password.';
      }
      if (statusCode == 409) {
        return 'An account with this email already exists.';
      }
      if (statusCode == 400) {
        final message = data?['message'];
        if (message is String) return message;
        if (message is List && message.isNotEmpty) return message.first.toString();
        return 'Invalid request. Please check your input.';
      }

      final message = data?['message'];
      if (message is String) return message;
      if (message is List && message.isNotEmpty) return message.first.toString();
      return 'Server error. Please try again later.';
    }

    return 'Network error. Please check your connection.';
  }
}
