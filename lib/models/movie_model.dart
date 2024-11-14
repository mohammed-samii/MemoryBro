import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 1)
class Movie extends HiveObject {
  @HiveField(0)
  int movieId;

  @HiveField(1)
  String movieName;

  @HiveField(2)
  String movieGenre;

  @HiveField(3)
  String movieMood; 

  @HiveField(4)
  Uint8List? movieImage;

  @HiveField(5)
  int movieYear;

  @HiveField(6)
  String movieStatus; 

  @HiveField(7)
  bool isFavourite;

    @HiveField(8)
  DateTime? lastViewed;


  Movie({
    required this.movieId,
    required this.movieName,
    required this.movieGenre,
    required this.movieMood,
    required this.movieImage,
    required this.movieYear,
    required this.movieStatus,
    required this.isFavourite,
    this.lastViewed,
  });
}
