// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SkillVideoAdapter extends TypeAdapter<SkillVideo> {
  @override
  final int typeId = 31;

  @override
  SkillVideo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SkillVideo(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      url: fields[3] as String,
      thumbnailUrl: fields[4] as String?,
      category: fields[5] as String,
      viewCount: fields[6] as int?,
      uploadedById: fields[7] as String?,
      createdAt: fields[8] as DateTime,
      duration: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, SkillVideo obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.url)
      ..writeByte(4)
      ..write(obj.thumbnailUrl)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.viewCount)
      ..writeByte(7)
      ..write(obj.uploadedById)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkillVideoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
