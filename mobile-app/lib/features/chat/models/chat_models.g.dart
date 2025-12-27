// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatRoomAdapter extends TypeAdapter<ChatRoom> {
  @override
  final int typeId = 20;

  @override
  ChatRoom read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatRoom(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      type: fields[3] as String,
      participants: (fields[4] as List).cast<ChatParticipant>(),
      lastMessage: fields[5] as Message?,
      unreadCount: fields[6] as int,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatRoom obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.participants)
      ..writeByte(5)
      ..write(obj.lastMessage)
      ..writeByte(6)
      ..write(obj.unreadCount)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatRoomAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatParticipantAdapter extends TypeAdapter<ChatParticipant> {
  @override
  final int typeId = 21;

  @override
  ChatParticipant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatParticipant(
      id: fields[0] as String,
      name: fields[1] as String,
      role: fields[2] as String,
      avatarUrl: fields[3] as String?,
      isOnline: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChatParticipant obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.avatarUrl)
      ..writeByte(4)
      ..write(obj.isOnline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatParticipantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 22;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      id: fields[0] as String,
      roomId: fields[1] as String,
      senderId: fields[2] as String,
      senderName: fields[3] as String,
      content: fields[4] as String,
      type: fields[5] as String,
      mediaUrl: fields[6] as String?,
      createdAt: fields[7] as DateTime,
      isRead: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.roomId)
      ..writeByte(2)
      ..write(obj.senderId)
      ..writeByte(3)
      ..write(obj.senderName)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.mediaUrl)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.isRead);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
