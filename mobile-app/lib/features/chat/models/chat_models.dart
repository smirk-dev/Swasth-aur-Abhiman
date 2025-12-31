import 'package:hive/hive.dart';

part 'chat_models.g.dart';

@HiveType(typeId: 20)
class ChatRoom {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String type; // DIRECT, GROUP

  @HiveField(4)
  final List<ChatParticipant> participants;

  @HiveField(5)
  final Message? lastMessage;

  @HiveField(6)
  final int unreadCount;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime? updatedAt;

  ChatRoom({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.participants,
    this.lastMessage,
    this.unreadCount = 0,
    required this.createdAt,
    this.updatedAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      participants: (json['participants'] as List?)
              ?.map((p) => ChatParticipant.fromJson(p))
              .toList() ??
          [],
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'])
          : null,
      unreadCount: json['unreadCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'participants': participants.map((p) => p.toJson()).toList(),
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

@HiveType(typeId: 21)
class ChatParticipant {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String role; // USER, DOCTOR, TEACHER, TRAINER, ADMIN

  @HiveField(3)
  final String? avatarUrl;

  @HiveField(4)
  final bool isOnline;

  ChatParticipant({
    required this.id,
    required this.name,
    required this.role,
    this.avatarUrl,
    this.isOnline = false,
  });

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      avatarUrl: json['avatarUrl'],
      isOnline: json['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'avatarUrl': avatarUrl,
      'isOnline': isOnline,
    };
  }

  String get roleDisplay {
    switch (role) {
      case 'DOCTOR':
        return 'Doctor';
      case 'TEACHER':
        return 'Teacher';
      case 'TRAINER':
        return 'Trainer';
      case 'ADMIN':
        return 'Admin';
      default:
        return 'User';
    }
  }
}

@HiveType(typeId: 22)
class Message {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String roomId;

  @HiveField(2)
  final String senderId;

  @HiveField(3)
  final String senderName;

  @HiveField(4)
  final String content;

  @HiveField(5)
  final String type; // TEXT, IMAGE, AUDIO, FILE

  @HiveField(6)
  final String? mediaUrl;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final bool isRead;

  @HiveField(9)
  final int? audioDuration; // Duration in seconds for audio messages

  Message({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderName,
    required this.content,
    this.type = 'TEXT',
    this.mediaUrl,
    required this.createdAt,
    this.isRead = false,
    this.audioDuration,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      roomId: json['roomId'] ?? json['room']?['id'] ?? '',
      senderId: json['senderId'] ?? json['sender']?['id'] ?? '',
      senderName: json['senderName'] ?? json['sender']?['fullName'] ?? 'Unknown',
      content: json['content'] ?? '',
      type: json['type'] ?? 'TEXT',
      mediaUrl: json['mediaUrl'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      isRead: json['isRead'] ?? false,
      audioDuration: json['audioDuration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'type': type,
      'mediaUrl': mediaUrl,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
    };
  }
}

class AvailableContact {
  final String id;
  final String name;
  final String role;
  final String? block;
  final String? avatarUrl;
  final bool isOnline;

  const AvailableContact({
    required this.id,
    required this.name,
    required this.role,
    this.block,
    this.avatarUrl,
    this.isOnline = false,
  });

  factory AvailableContact.fromJson(Map<String, dynamic> json) {
    return AvailableContact(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      block: json['block'],
      avatarUrl: json['avatarUrl'],
      isOnline: json['isOnline'] ?? false,
    );
  }

  String get roleDisplay {
    switch (role) {
      case 'DOCTOR':
        return '👨‍⚕️ Doctor';
      case 'TEACHER':
        return '👩‍🏫 Teacher';
      case 'TRAINER':
        return '🧑‍🏭 Trainer';
      case 'ADMIN':
        return '👤 Admin';
      default:
        return '👤 User';
    }
  }
}
