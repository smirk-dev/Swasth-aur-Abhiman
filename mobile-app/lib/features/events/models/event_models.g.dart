// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 10;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      eventDate: fields[3] as DateTime,
      eventTime: fields[4] as String?,
      location: fields[5] as String,
      block: fields[6] as String,
      eventType: fields[7] as String,
      organizerName: fields[8] as String?,
      organizerContact: fields[9] as String?,
      imageUrl: fields[10] as String?,
      expectedAttendees: fields[11] as int?,
      isActive: fields[12] as bool,
      createdAt: fields[13] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.eventDate)
      ..writeByte(4)
      ..write(obj.eventTime)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.block)
      ..writeByte(7)
      ..write(obj.eventType)
      ..writeByte(8)
      ..write(obj.organizerName)
      ..writeByte(9)
      ..write(obj.organizerContact)
      ..writeByte(10)
      ..write(obj.imageUrl)
      ..writeByte(11)
      ..write(obj.expectedAttendees)
      ..writeByte(12)
      ..write(obj.isActive)
      ..writeByte(13)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
