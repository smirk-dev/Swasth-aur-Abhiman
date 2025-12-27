import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../repositories/media_repository.dart';
import '../models/media_models.dart';

final mediaRepositoryProvider = Provider<MediaRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MediaRepository(dio);
});

class MediaState {
  final Map<String, List<MediaContent>> contentByCategory;
  final bool isLoading;
  final String? error;

  MediaState({
    this.contentByCategory = const {},
    this.isLoading = false,
    this.error,
  });

  List<MediaContent> getByCategory(String category) {
    return contentByCategory[category] ?? [];
  }

  MediaState copyWith({
    Map<String, List<MediaContent>>? contentByCategory,
    bool? isLoading,
    String? error,
  }) {
    return MediaState(
      contentByCategory: contentByCategory ?? this.contentByCategory,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MediaNotifier extends StateNotifier<MediaState> {
  final MediaRepository _repository;

  MediaNotifier(this._repository) : super(MediaState());

  Future<void> loadCategory(String category) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final content = await _repository.getMediaByCategory(category);
      final updatedMap = Map<String, List<MediaContent>>.from(state.contentByCategory);
      updatedMap[category] = content;
      
      state = state.copyWith(contentByCategory: updatedMap, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadSubCategory(String category, String subCategory) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final content = await _repository.getMediaBySubCategory(category, subCategory);
      final key = '$category:$subCategory';
      final updatedMap = Map<String, List<MediaContent>>.from(state.contentByCategory);
      updatedMap[key] = content;
      
      state = state.copyWith(contentByCategory: updatedMap, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> trackView(String mediaId) async {
    try {
      await _repository.incrementViewCount(mediaId);
    } catch (e) {
      // Silent fail for analytics
    }
  }
}

final mediaProvider = StateNotifierProvider<MediaNotifier, MediaState>((ref) {
  final repository = ref.watch(mediaRepositoryProvider);
  return MediaNotifier(repository);
});
