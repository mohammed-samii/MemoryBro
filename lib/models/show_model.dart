import 'package:hive/hive.dart';

part 'show_model.g.dart';

@HiveType(typeId: 2)
class Show extends HiveObject {
  @HiveField(0)
  int showId;

  @HiveField(1)
  String showName;

  @HiveField(2)
  String showGenre;

  @HiveField(3)
  String showMood; 

  @HiveField(4)
  String showImage; 

  @HiveField(5)
  int showYear;

  @HiveField(6)
  String showStatus; 
  @HiveField(7)
  int showSeasons;

  @HiveField(8)
  int showEpisodes;

  @HiveField(9)
  bool isFavourite; 
     @HiveField(10)
  DateTime? lastViewed;

 

  Show({
    required this.showId,
    required this.showName,
    required this.showGenre,
    required this.showMood,
    required this.showImage,
    required this.showYear,
    required this.showStatus,
    required this.showSeasons,
    required this.showEpisodes,
    required this.isFavourite,
    this.lastViewed,
  });
}
