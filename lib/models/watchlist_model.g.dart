// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchlistAdapter extends TypeAdapter<Watchlist> {
  @override
  final int typeId = 0;

  @override
  Watchlist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Watchlist(
      watchlistId: fields[0] as int,
      watchlistName: fields[1] as String,
      watchlistGenre: fields[2] as String,
      watchlistMood: fields[3] as String,
      watchlistImage: fields[4] as Uint8List,
      watchlistAddedDate: fields[5] as DateTime,
      isFavourite: fields[6] as bool,
      watchlistStatus: fields[7] as String,
      movieIds: (fields[8] as List).cast<int>(),
      showIds: (fields[9] as List).cast<int>(),
      lastViewed: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Watchlist obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.watchlistId)
      ..writeByte(1)
      ..write(obj.watchlistName)
      ..writeByte(2)
      ..write(obj.watchlistGenre)
      ..writeByte(3)
      ..write(obj.watchlistMood)
      ..writeByte(4)
      ..write(obj.watchlistImage)
      ..writeByte(5)
      ..write(obj.watchlistAddedDate)
      ..writeByte(6)
      ..write(obj.isFavourite)
      ..writeByte(7)
      ..write(obj.watchlistStatus)
      ..writeByte(8)
      ..write(obj.movieIds)
      ..writeByte(9)
      ..write(obj.showIds)
      ..writeByte(10)
      ..write(obj.lastViewed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchlistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
