// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShowAdapter extends TypeAdapter<Show> {
  @override
  final int typeId = 2;

  @override
  Show read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Show(
      showId: fields[0] as int,
      showName: fields[1] as String,
      showGenre: fields[2] as String,
      showMood: fields[3] as String,
      showImage: fields[4] as Uint8List,
      showYear: fields[5] as int,
      showStatus: fields[6] as String,
      showSeasons: fields[7] as int,
      showEpisodes: fields[8] as int,
      isFavourite: fields[9] as bool,
      lastViewed: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Show obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.showId)
      ..writeByte(1)
      ..write(obj.showName)
      ..writeByte(2)
      ..write(obj.showGenre)
      ..writeByte(3)
      ..write(obj.showMood)
      ..writeByte(4)
      ..write(obj.showImage)
      ..writeByte(5)
      ..write(obj.showYear)
      ..writeByte(6)
      ..write(obj.showStatus)
      ..writeByte(7)
      ..write(obj.showSeasons)
      ..writeByte(8)
      ..write(obj.showEpisodes)
      ..writeByte(9)
      ..write(obj.isFavourite)
      ..writeByte(10)
      ..write(obj.lastViewed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
