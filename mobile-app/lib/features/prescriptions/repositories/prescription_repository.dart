import 'package:dio/dio.dart';
import 'dart:io';
import '../models/prescription_models.dart';

class PrescriptionRepository {
  final Dio _dio;

  PrescriptionRepository(this._dio);

  Future<List<Prescription>> getUserPrescriptions() async {
    final response = await _dio.get('/prescriptions/my');
    return (response.data as List)
        .map((json) => Prescription.fromJson(json))
        .toList();
  }

  Future<List<Prescription>> getAllPrescriptions() async {
    final response = await _dio.get('/prescriptions');
    return (response.data as List)
        .map((json) => Prescription.fromJson(json))
        .toList();
  }

  Future<List<Prescription>> getPendingPrescriptions() async {
    final response = await _dio.get('/prescriptions/pending');
    return (response.data as List)
        .map((json) => Prescription.fromJson(json))
        .toList();
  }

  Future<Prescription> createPrescription(CreatePrescriptionRequest request) async {
    final response = await _dio.post('/prescriptions', data: request.toJson());
    return Prescription.fromJson(response.data);
  }

  Future<String> uploadPrescriptionImage(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: 'prescription_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ),
    });
    
    final response = await _dio.post('/media/upload', data: formData);
    return response.data['url'];
  }

  Future<Prescription> reviewPrescription(
    String prescriptionId,
    ReviewPrescriptionRequest request,
  ) async {
    final response = await _dio.put(
      '/prescriptions/$prescriptionId/review',
      data: request.toJson(),
    );
    return Prescription.fromJson(response.data);
  }
}
