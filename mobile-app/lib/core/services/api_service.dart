import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../models/video.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // File upload
  Future<Response> uploadFile(
    String path, {
    required String filePath,
    required String fieldName,
    Map<String, dynamic>? data,
  }) async {
    final formData = FormData.fromMap({
      if (data != null) ...data,
      fieldName: await MultipartFile.fromFile(filePath),
    });

    return _dio.post(
      path,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
  }

  // Education video endpoints
  Future<List<Video>> getVideosByClass(int classNumber) async {
    final response = await _dio.get('/media/education/class/$classNumber');
    return (response.data as List).map((e) => Video.fromJson(e)).toList();
  }

  Future<List<Video>> getVideosByClassAndSubject(int classNumber, String subject) async {
    final response = await _dio.get('/media/education/class/$classNumber/subject/$subject');
    return (response.data as List).map((e) => Video.fromJson(e)).toList();
  }

  Future<void> trackVideoView(int mediaId, int watchTime) async {
    await _dio.post('/media/$mediaId/track-view', data: {
      'userId': 1,
      'watchTime': watchTime,
    });
  }

  Future<void> rateVideo(int mediaId, double rating) async {
    await _dio.post('/media/$mediaId/rate', data: {
      'userId': 1,
      'rating': rating,
    });
  }

  Future<void> addBookmark(int mediaId, int timestamp, String? note) async {
    await _dio.post('/media/$mediaId/bookmark', data: {
      'userId': 1,
      'timestamp': timestamp,
      'note': note,
    });
  }

  Future<List<Video>> getTrendingVideos() async {
    final response = await _dio.get('/media/trending');
    return (response.data as List).map((e) => Video.fromJson(e)).toList();
  }

  Future<List<Video>> getRecommendedVideos(int userId) async {
    final response = await _dio.get('/media/recommended/$userId');
    return (response.data as List).map((e) => Video.fromJson(e)).toList();
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiService(dio);
});
