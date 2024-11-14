// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieAdapter extends TypeAdapter<Movie> {
  @override
  final int typeId = 1;

  @override
  Movie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movie(
      movieId: fields[0] as int,
      movieName: fields[1] as String,
      movieGenre: fields[2] as String,
      movieMood: fields[3] as String,
      movieImage: fields[4] as Uint8List,
      movieYear: fields[5] as int,
      movieStatus: fields[6] as String,
      isFavourite: fields[7] as bool,
      lastViewed: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Movie obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.movieId)
      ..writeByte(1)
      ..write(obj.movieName)
      ..writeByte(2)
      ..write(obj.movieGenre)
      ..writeByte(3)
      ..write(obj.movieMood)
      ..writeByte(4)
      ..write(obj.movieImage)
      ..writeByte(5)
      ..write(obj.movieYear)
      ..writeByte(6)
      ..write(obj.movieStatus)
      ..writeByte(7)
      ..write(obj.isFavourite)
      ..writeByte(8)
      ..write(obj.lastViewed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
