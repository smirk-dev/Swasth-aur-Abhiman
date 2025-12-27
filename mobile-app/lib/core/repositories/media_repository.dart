import 'package:dio/dio.dart';
import '../models/media_models.dart';

class MediaRepository {
  final Dio _dio;

  MediaRepository(this._dio);

  Future<List<MediaContent>> getAllMedia({String? category}) async {
    final params = category != null ? {'category': category} : null;
    final response = await _dio.get('/media', queryParameters: params);
    return (response.data as List)
        .map((json) => MediaContent.fromJson(json))
        .toList();
  }

  Future<List<MediaContent>> getMediaByCategory(String category) async {
    final response = await _dio.get('/media', queryParameters: {'category': category});
    return (response.data as List)
        .map((json) => MediaContent.fromJson(json))
        .toList();
  }

  Future<List<MediaContent>> getMediaBySubCategory(String category, String subCategory) async {
    final response = await _dio.get('/media/$category/$subCategory');
    return (response.data as List)
        .map((json) => MediaContent.fromJson(json))
        .toList();
  }

  Future<void> incrementViewCount(String mediaId) async {
    await _dio.post('/media/$mediaId/view');
  }

  Future<MediaContent> createMedia(CreateMediaRequest request) async {
    final response = await _dio.post('/media', data: request.toJson());
    return MediaContent.fromJson(response.data);
  }

  Future<String> uploadFile(String filePath, String filename) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: filename),
    });
    final response = await _dio.post('/media/upload', data: formData);
    return response.data['url'];
  }
}
