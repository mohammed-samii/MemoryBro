import 'package:movie_watchlist/models/movie_model.dart';
import 'package:movie_watchlist/models/show_model.dart';
import 'package:movie_watchlist/models/watchlist_model.dart';
import 'package:movie_watchlist/services/movie_service.dart';
import 'package:movie_watchlist/services/show_service.dart';
import 'package:movie_watchlist/services/watchlist_service.dart';

class ViewsService {
  final WatchlistService _watchlistService = WatchlistService();
  final MovieService _movieService = MovieService();
  final ShowService _showService = ShowService();
  void markAsViewed(dynamic item) async {
  print('Item: $item');
  if (item is Movie) {
    item.lastViewed = DateTime.now();
  } else if (item is Show) {
    item.lastViewed = DateTime.now();
  } else if(item is Watchlist) {
    item.lastViewed = DateTime.now();
  }
  await item.save();
}

Future<List<Movie>> getRecentlyViewedMovies(int limit) async {
  var box = _movieService.getMoviesBox();
  var movies = box.values
      .where((movie) => movie.lastViewed != null)
      .toList();
  movies.sort((a, b) => b.lastViewed!.compareTo(a.lastViewed!));
  return movies.take(limit).toList();
}

Future<List<Show>> getRecentlyViewedShows(int limit) async {
  var box =  _showService.getShowsBox();
  var shows = box.values
      .where((show) => show.lastViewed != null)
      .toList();
  shows.sort((a, b) => b.lastViewed!.compareTo(a.lastViewed!));
  return shows.take(limit).toList();
}

Future<List<Watchlist>> getRecentlyViewedWatchlists(int limit) async {
  var box =  _watchlistService.getWatchlistBox();
  var watchlists = box.values
      .where((watchlist) => watchlist.lastViewed != null)
      .toList();
      print('watchlists: $watchlists');
  watchlists.sort((a, b) => b.lastViewed!.compareTo(a.lastViewed!));
  return watchlists.take(limit).toList();
}

}