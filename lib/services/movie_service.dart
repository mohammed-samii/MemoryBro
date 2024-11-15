import 'package:hive/hive.dart';
import '../models/movie_model.dart';

class MovieService {
  Box<Movie> getMoviesBox() => Hive.box<Movie>('moviesBox');

  int generateId(Box box) {
    return box.isEmpty ? 0 : box.values.last.key + 1;
  }

  Future<void> addMovie(Movie movie) async {
    final box = getMoviesBox();
    movie.movieId = generateId(box);
    await box.put(movie.movieId, movie);
    print('Movie added: $movie');
  }

  Movie? getMovieById(int movieId) {
    return getMoviesBox().get(movieId);
  }

  List<Movie> getMoviesByMood(String mood) {
    final box = getMoviesBox();
    return box.values
        .where((movie) => movie.movieMood == mood)
        .toList();
  } 

  List<Movie> getAllMovies() {
    return getMoviesBox().values.toList();
  }

  Future<void> updateMovie(Movie updatedMovie) async {
    await getMoviesBox().put(updatedMovie.movieId, updatedMovie);
  }

  Future<void> deleteMovie(int movieId) async {
    await getMoviesBox().delete(movieId);
  }

  List<Movie> getFavouriteMovies() {
    return getMoviesBox().values
        .where((movie) => movie.isFavourite)
        .toList();
  }

  Future<void> toggleFavoriteMovie(int movieId) async {
    final movie = getMoviesBox().get(movieId);
    if (movie != null) {
      movie.isFavourite = !movie.isFavourite;
      await movie.save();
    }
  }
}
