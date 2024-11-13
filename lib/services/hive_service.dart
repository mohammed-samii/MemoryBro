import 'package:hive_flutter/hive_flutter.dart';
import '../models/movie_model.dart';
import '../models/show_model.dart';
import '../models/watchlist_model.dart';
import '../models/user_model.dart';

class HiveService {

  Future<void> initHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter(MovieAdapter());
    Hive.registerAdapter(ShowAdapter());
    Hive.registerAdapter(WatchlistAdapter());
    Hive.registerAdapter(UserAdapter());

    await Hive.openBox<Movie>('moviesBox');
    await Hive.openBox<Show>('showsBox');
    await Hive.openBox<Watchlist>('watchlistsBox'); 
    await Hive.openBox<User>('userBox');
  }

  Box<Movie> getMoviesBox() => Hive.box<Movie>('moviesBox');
  Box<Show> getShowsBox() => Hive.box<Show>('showsBox');
  Box<Watchlist> getWatchlistBox() => Hive.box<Watchlist>('watchlistsBox');
  Box<User> getUserBox() => Hive.box<User>('userBox');
}
