import 'package:hive/hive.dart';
import '../models/show_model.dart';

class ShowService {
  Box<Show> getShowsBox() => Hive.box<Show>('showsBox');

  int generateId(Box box) {
    return box.isEmpty ? 0 : box.values.last.key + 1;
  }

  Future<void> addShow(Show show) async {
    final box = getShowsBox();
    show.showId = generateId(box);
    await box.put(show.showId, show);
  }

  Show? getShowById(int showId) {
    return getShowsBox().get(showId);
  }

  List<Show> getShowsByMood(String mood) {
    final box = getShowsBox();
    return box.values
        .where((show) => show.showMood == mood)
        .toList();
  } 

  List<Show> getFavouriteShows() {
    return getShowsBox().values
        .where((show) => show.isFavourite)
        .toList();
  }

  List<Show> getAllShows() {
    return getShowsBox().values.toList();
  }

  Future<void> updateShow(Show updatedShow) async {
    await getShowsBox().put(updatedShow.showId, updatedShow);
  }

  Future<void> deleteShow(int showId) async {
    await getShowsBox().delete(showId);
  }

  Future<void> toggleFavoriteShow(int showId) async {
    final show = getShowsBox().get(showId);
    if (show != null) {
      show.isFavourite = !show.isFavourite;
      await show.save();
    }
  }
}
