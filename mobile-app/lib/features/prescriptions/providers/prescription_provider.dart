import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../../core/network/dio_client.dart';
import '../models/prescription_models.dart';
import '../repositories/prescription_repository.dart';

final prescriptionRepositoryProvider = Provider<PrescriptionRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return PrescriptionRepository(dio);
});

class PrescriptionState {
  final List<Prescription> prescriptions;
  final List<Prescription> pendingPrescriptions;
  final bool isLoading;
  final bool isUploading;
  final String? error;

  PrescriptionState({
    this.prescriptions = const [],
    this.pendingPrescriptions = const [],
    this.isLoading = false,
    this.isUploading = false,
    this.error,
  });

  PrescriptionState copyWith({
    List<Prescription>? prescriptions,
    List<Prescription>? pendingPrescriptions,
    bool? isLoading,
    bool? isUploading,
    String? error,
  }) {
    return PrescriptionState(
      prescriptions: prescriptions ?? this.prescriptions,
      pendingPrescriptions: pendingPrescriptions ?? this.pendingPrescriptions,
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      error: error,
    );
  }
}

class PrescriptionNotifier extends StateNotifier<PrescriptionState> {
  final PrescriptionRepository _repository;

  PrescriptionNotifier(this._repository) : super(PrescriptionState()) {
    loadPrescriptions();
  }

  Future<void> loadPrescriptions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final prescriptions = await _repository.getUserPrescriptions();
      state = state.copyWith(prescriptions: prescriptions, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadPendingPrescriptions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final pending = await _repository.getPendingPrescriptions();
      state = state.copyWith(pendingPrescriptions: pending, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadAllPrescriptions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final prescriptions = await _repository.getAllPrescriptions();
      state = state.copyWith(prescriptions: prescriptions, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> uploadPrescription({
    required File imageFile,
    String? description,
    String? symptoms,
  }) async {
    state = state.copyWith(isUploading: true, error: null);

    try {
      // Upload image first
      final imageUrl = await _repository.uploadPrescriptionImage(imageFile);

      // Create prescription record
      final request = CreatePrescriptionRequest(
        imageUrl: imageUrl,
        description: description,
        symptoms: symptoms,
      );

      final prescription = await _repository.createPrescription(request);
      
      state = state.copyWith(
        prescriptions: [prescription, ...state.prescriptions],
        isUploading: false,
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(isUploading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> reviewPrescription(String prescriptionId, String doctorNotes) async {
    try {
      final request = ReviewPrescriptionRequest(doctorNotes: doctorNotes);
      final updated = await _repository.reviewPrescription(prescriptionId, request);
      
      // Update both lists
      state = state.copyWith(
        prescriptions: state.prescriptions.map((p) {
          return p.id == prescriptionId ? updated : p;
        }).toList(),
        pendingPrescriptions: state.pendingPrescriptions
            .where((p) => p.id != prescriptionId)
            .toList(),
      );
      
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

final prescriptionProvider =
    StateNotifierProvider<PrescriptionNotifier, PrescriptionState>((ref) {
  final repository = ref.watch(prescriptionRepositoryProvider);
  return PrescriptionNotifier(repository);
});
