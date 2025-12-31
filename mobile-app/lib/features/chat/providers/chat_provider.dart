import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_models.dart';
import '../repositories/chat_repository.dart';

class ChatState {
  final List<ChatRoom> rooms;
  final Map<String, List<Message>> messages;
  final List<AvailableContact> contacts;
  final bool isLoading;
  final bool isSending;
  final String? error;
  final String? activeRoomId;

  const ChatState({
    this.rooms = const [],
    this.messages = const {},
    this.contacts = const [],
    this.isLoading = false,
    this.isSending = false,
    this.error,
    this.activeRoomId,
  });

  ChatState copyWith({
    List<ChatRoom>? rooms,
    Map<String, List<Message>>? messages,
    List<AvailableContact>? contacts,
    bool? isLoading,
    bool? isSending,
    String? error,
    String? activeRoomId,
  }) {
    return ChatState(
      rooms: rooms ?? this.rooms,
      messages: messages ?? this.messages,
      contacts: contacts ?? this.contacts,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      error: error,
      activeRoomId: activeRoomId ?? this.activeRoomId,
    );
  }

  List<Message> getMessagesForRoom(String roomId) {
    return messages[roomId] ?? [];
  }

  int get totalUnreadCount {
    return rooms.fold(0, (sum, room) => sum + room.unreadCount);
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatRepository _repository;

  ChatNotifier(this._repository) : super(const ChatState());

  Future<void> loadRooms() async {
    state = state.copyWith(isLoading: true);

    try {
      final rooms = await _repository.getChatRooms();
      rooms.sort((a, b) {
        final aTime = a.lastMessage?.createdAt ?? a.createdAt;
        final bTime = b.lastMessage?.createdAt ?? b.createdAt;
        return bTime.compareTo(aTime);
      });

      state = state.copyWith(
        rooms: rooms,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMessages(String roomId) async {
    state = state.copyWith(
      isLoading: true,
      activeRoomId: roomId,
    );

    try {
      final messages = await _repository.getMessages(roomId);
      await _repository.markAsRead(roomId);

      final updatedMessages = Map<String, List<Message>>.from(state.messages);
      updatedMessages[roomId] = messages;

      // Update unread count for this room
      final updatedRooms = state.rooms.map((room) {
        if (room.id == roomId) {
          return ChatRoom(
            id: room.id,
            name: room.name,
            description: room.description,
            type: room.type,
            participants: room.participants,
            lastMessage: room.lastMessage,
            unreadCount: 0,
            createdAt: room.createdAt,
            updatedAt: room.updatedAt,
          );
        }
        return room;
      }).toList();

      state = state.copyWith(
        messages: updatedMessages,
        rooms: updatedRooms,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<bool> sendMessage(String roomId, String content) async {
    state = state.copyWith(isSending: true);

    try {
      final message = await _repository.sendMessage(roomId, content);

      if (message != null) {
        final updatedMessages = Map<String, List<Message>>.from(state.messages);
        updatedMessages[roomId] = [message, ...(updatedMessages[roomId] ?? [])];

        state = state.copyWith(
          messages: updatedMessages,
          isSending: false,
        );
        return true;
      }

      state = state.copyWith(isSending: false);
      return false;
    } catch (e) {
      state = state.copyWith(
        isSending: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> sendAudioMessage(String roomId, String filePath, int duration) async {
    state = state.copyWith(isSending: true);

    try {
      final message = await _repository.sendAudioMessage(roomId, filePath, duration);

      if (message != null) {
        final updatedMessages = Map<String, List<Message>>.from(state.messages);
        updatedMessages[roomId] = [message, ...(updatedMessages[roomId] ?? [])];

        state = state.copyWith(
          messages: updatedMessages,
          isSending: false,
        );
        return true;
      }

      state = state.copyWith(isSending: false);
      return false;
    } catch (e) {
      state = state.copyWith(
        isSending: false,
        error: e.toString(),
      );
      return false;
    }
  }
        isSending: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<void> loadContacts({String? role}) async {
    try {
      final contacts = await _repository.getAvailableContacts(role: role);
      state = state.copyWith(contacts: contacts);
    } catch (e) {
      // Ignore errors
    }
  }

  Future<ChatRoom?> createDirectChat(String userId, String userName) async {
    try {
      final room = await _repository.createRoom(
        name: userName,
        participantIds: [userId],
        type: 'DIRECT',
      );

      if (room != null) {
        state = state.copyWith(
          rooms: [room, ...state.rooms],
        );
      }

      return room;
    } catch (e) {
      return null;
    }
  }

  // WebSocket message handling
  void onNewMessage(Message message) {
    final updatedMessages = Map<String, List<Message>>.from(state.messages);
    updatedMessages[message.roomId] = [
      message,
      ...(updatedMessages[message.roomId] ?? [])
    ];

    // Update room's last message
    final updatedRooms = state.rooms.map((room) {
      if (room.id == message.roomId) {
        return ChatRoom(
          id: room.id,
          name: room.name,
          description: room.description,
          type: room.type,
          participants: room.participants,
          lastMessage: message,
          unreadCount: state.activeRoomId == message.roomId
              ? 0
              : room.unreadCount + 1,
          createdAt: room.createdAt,
          updatedAt: DateTime.now(),
        );
      }
      return room;
    }).toList();

    state = state.copyWith(
      messages: updatedMessages,
      rooms: updatedRooms,
    );
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatNotifier(repository);
});
