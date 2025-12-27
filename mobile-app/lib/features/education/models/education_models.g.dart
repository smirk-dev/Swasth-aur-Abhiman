// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EducationVideoAdapter extends TypeAdapter<EducationVideo> {
  @override
  final int typeId = 30;

  @override
  EducationVideo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EducationVideo(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      url: fields[3] as String,
      thumbnailUrl: fields[4] as String?,
      category: fields[5] as String,
      subcategory: fields[6] as String?,
      viewCount: fields[7] as int?,
      uploadedById: fields[8] as String?,
      createdAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, EducationVideo obj) {
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
      ..write(obj.subcategory)
      ..writeByte(7)
      ..write(obj.viewCount)
      ..writeByte(8)
      ..write(obj.uploadedById)
      ..writeByte(9)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EducationVideoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
