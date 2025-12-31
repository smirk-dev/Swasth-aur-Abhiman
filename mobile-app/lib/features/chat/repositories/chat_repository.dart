import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/services/api_service.dart';
import '../models/chat_models.dart';

class ChatRepository {
  final ApiService _apiService;

  ChatRepository(this._apiService);

  // Get all chat rooms for current user
  Future<List<ChatRoom>> getChatRooms() async {
    try {
      final response = await _apiService.get('/chat/rooms');
      return (response.data as List)
          .map((r) => ChatRoom.fromJson(r))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get messages for a room
  Future<List<Message>> getMessages(String roomId, {int page = 1}) async {
    try {
      final response = await _apiService.get(
        '/chat/rooms/$roomId/messages',
        queryParameters: {'page': page.toString()},
      );
      return (response.data as List)
          .map((m) => Message.fromJson(m))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Send a text message
  Future<Message?> sendMessage(String roomId, String content, {String type = 'TEXT'}) async {
    try {
      final response = await _apiService.post(
        '/chat/rooms/$roomId/messages',
        data: {
          'content': content,
          'type': type,
        },
      );
      return Message.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  // Send an audio message
  Future<Message?> sendAudioMessage(
    String roomId, 
    String filePath, 
    int duration,
  ) async {
    try {
      final formData = FormData.fromMap({
        'type': 'AUDIO',
        'content': 'Voice message',
        'audioDuration': duration,
        'audio': await MultipartFile.fromFile(filePath, filename: 'voice_message.m4a'),
      });
      
      final response = await _apiService.post(
        '/chat/rooms/$roomId/messages',
        data: formData,
      );
      return Message.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  // Create a new chat room (direct or group)
  Future<ChatRoom?> createRoom({
    required String name,
    required List<String> participantIds,
    String type = 'DIRECT',
  }) async {
    try {
      final response = await _apiService.post(
        '/chat/rooms',
        data: {
          'name': name,
          'type': type,
          'participantIds': participantIds,
        },
      );
      return ChatRoom.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  // Get available contacts (doctors, teachers, trainers, users)
  Future<List<AvailableContact>> getAvailableContacts({String? role}) async {
    try {
      final queryParams = <String, String>{};
      if (role != null) queryParams['role'] = role;

      final response = await _apiService.get(
        '/chat/contacts',
        queryParameters: queryParams,
      );
      return (response.data as List)
          .map((c) => AvailableContact.fromJson(c))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Mark messages as read
  Future<void> markAsRead(String roomId) async {
    try {
      await _apiService.patch('/chat/rooms/$roomId/read');
    } catch (e) {
      // Ignore errors
    }
  }
}

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ChatRepository(apiService);
});
