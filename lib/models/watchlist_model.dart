import 'package:hive/hive.dart';

part 'watchlist_model.g.dart'; // This part directive will include the generated code.

@HiveType(typeId: 0)
class Watchlist extends HiveObject {
  @HiveField(0)
  int watchlistId;

  @HiveField(1)
  String watchlistName;

  @HiveField(2)
  String watchlistGenre;

  @HiveField(3)
  String watchlistMood; // Single mood as a string.

  @HiveField(4)
  String watchlistImage; // Path to an image from one of the movies/shows.

  @HiveField(5)
  DateTime watchlistAddedDate;

  @HiveField(6)
  bool isFavourite; // New field to mark as a favorite.

  @HiveField(7)
  String watchlistStatus; // completed, incompleted

  @HiveField(8)
  List<int> movieIds; // References to movies in this watchlist.

  @HiveField(9)
  List<int> showIds; // References to shows in this watchlist.

     @HiveField(10)
  DateTime? lastViewed;

  Watchlist({
    required this.watchlistId,
    required this.watchlistName,
    required this.watchlistGenre,
    required this.watchlistMood,
    required this.watchlistImage,
    required this.watchlistAddedDate,
    required this.isFavourite,
    required this.watchlistStatus,
    required this.movieIds,
    required this.showIds,
    this.lastViewed
  });
}
