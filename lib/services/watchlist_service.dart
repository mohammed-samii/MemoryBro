import 'dart:math';
import 'package:hive/hive.dart';
import 'package:movie_watchlist/models/movie_model.dart';
import 'package:movie_watchlist/models/show_model.dart';
import 'package:movie_watchlist/services/movie_service.dart';
import 'package:movie_watchlist/services/show_service.dart';
import '../models/watchlist_model.dart';

class WatchlistService {
  Box<Watchlist> getWatchlistBox() => Hive.box<Watchlist>('watchlistsBox');

  int generateId(Box box) {
    return box.isEmpty ? 0 : box.values.last.key + 1;
  }

Future<void> addWatchlist(Watchlist watchlist) async {
  final box = getWatchlistBox();
  watchlist.watchlistId = generateId(box);

  String randomImage = _getRandomImageFromMoviesOrShows(watchlist);
  if (randomImage.isNotEmpty) {
    watchlist.watchlistImage = randomImage;
  }

  await box.put(watchlist.watchlistId, watchlist);
}
List<Watchlist> getWatchlistsByMood(String mood) {
    final box = getWatchlistBox();
    return box.values
        .where((watchlist) => watchlist.watchlistMood == mood)
        .toList();
  }


  String _getRandomImageFromMoviesOrShows(Watchlist watchlist) {
    Random random = Random();

    List<String> imageSources = [];

    if (watchlist.movieIds.isNotEmpty) {
      MovieService movieService = MovieService();
      for (int movieId in watchlist.movieIds) {
        Movie? movie = movieService.getMovieById(movieId);
        if (movie != null) {
          imageSources.add(movie.movieImage);
        }
      }
    }

    if (watchlist.showIds.isNotEmpty) {
      ShowService showService = ShowService();
      for (int showId in watchlist.showIds) {
        Show? show = showService.getShowById(showId);
        if (show != null) {
          imageSources.add(show.showImage);
        }
      }
    }

    if (imageSources.isNotEmpty) {
      return imageSources[random.nextInt(imageSources.length)];
    }

    return '';
  }

Future<Watchlist?> getWatchlistById(int watchlistId) async {
  final watchlist = getWatchlistBox().get(watchlistId);
  return watchlist;
}


  List<Watchlist> getFavoriteWatchlists() {
    final box = getWatchlistBox();
    return box.values.where((watchlist) => watchlist.isFavourite).toList();
  }

  Future<List<Movie>> getMoviesFromWatchlist(int watchlistId) async {
    final watchlist = await getWatchlistById(watchlistId);
    if (watchlist != null) {
      List<Movie> movies = [];
      MovieService movieService =
          MovieService(); 
      for (int movieId in watchlist.movieIds) {
        Movie? movie =
            movieService.getMovieById(movieId); 
        if (movie != null) {
          movies.add(movie);
        }
      }
      print(movies);
      return movies;
    }
    return [];
  }

  Future<List<Show>> getShowsFromWatchlist(int watchlistId) async {
    final watchlist = await getWatchlistById(watchlistId);
    if (watchlist != null) {
      List<Show> shows = [];
      ShowService showService =
          ShowService(); 
      for (int showId in watchlist.showIds) {
        Show? show =
            showService.getShowById(showId); 
        if (show != null) {
          shows.add(show);
        }
      }
      return shows;
    }
    return [];
  }

  Future<Map<String, List<dynamic>>> getMoviesAndShowsFromWatchlist(
      int watchlistId) async {
    List<Movie> movies = await getMoviesFromWatchlist(watchlistId);
    List<Show> shows = await getShowsFromWatchlist(watchlistId);
    return {
      'movies': movies,
      'shows': shows,
    };
  }

  List<Watchlist> getAllWatchlists() {
    return getWatchlistBox().values.toList();
  }

  Future<void> updateWatchlist(Watchlist updatedWatchlist) async {
  final box = getWatchlistBox();

  String randomImage = _getRandomImageFromMoviesOrShows(updatedWatchlist);
  if (randomImage.isNotEmpty) {
    updatedWatchlist.watchlistImage = randomImage;
  } 

  await box.put(updatedWatchlist.watchlistId, updatedWatchlist);
   }

Future<void> deleteWatchlist(int watchlistId) async {
  final watchlist = await getWatchlistById(watchlistId);

  if (watchlist != null) {
    // Step 1: Delete associated movies and shows
    await deleteMoviesAndShows(watchlist.movieIds, watchlist.showIds);

    // Step 2: Delete the watchlist
    await getWatchlistBox().delete(watchlistId);
  }
}

Future<void> deleteMoviesAndShows(List<int> movieIds, List<int> showIds) async {
  final movieBox = Hive.box<Movie>('moviesBox'); 
  final showBox = Hive.box<Show>('showsBox'); 
  
  for (int movieId in movieIds) {
    await movieBox.delete(movieId);
  }

  for (int showId in showIds) {
    await showBox.delete(showId);
  }
}



  Future<void> toggleFavoriteWatchlist(int watchlistId) async {
    final watchlist = getWatchlistBox().get(watchlistId);
    if (watchlist != null) {
      watchlist.isFavourite = !watchlist.isFavourite;
      await watchlist.save();
    }
  }
}
