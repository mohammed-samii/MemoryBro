import 'package:flutter/material.dart';
import 'package:movie_watchlist/services/hive_service.dart';
import 'package:movie_watchlist/views/home/search_screen.dart';
import 'package:movie_watchlist/views/movie/edit_movie_screen.dart';
import 'package:movie_watchlist/views/profile/favorites_screen.dart';
import 'package:movie_watchlist/views/profile/recently_viewed.dart';
import 'package:movie_watchlist/views/show/edit_show_screen.dart';
import 'package:movie_watchlist/views/watchlist/edit_watchlist_screen.dart';
// import 'package:movie_watchlist/views/movie/edit_movie_screen.dart';
// import 'package:movie_watchlist/views/show/edit_show_screen.dart';
// import 'package:movie_watchlist/views/watchlist/edit_watchlist_screen.dart';
import 'package:movie_watchlist/views/watchlist/view_watchlist_and_add.dart';
import 'package:movie_watchlist/views/emoji/emoji_based.dart';
import 'package:movie_watchlist/views/main_screen.dart';
import 'package:movie_watchlist/views/movie/add_movie_screen.dart';
import 'package:movie_watchlist/views/profile/profile_screen.dart';
import 'package:movie_watchlist/views/show/add_show_screen.dart';
import 'package:movie_watchlist/views/watchlist/add_watchlist_screen.dart';
import 'package:movie_watchlist/views/watchlist/watchlist_detail_screen.dart';
import 'package:movie_watchlist/views/welcome/add_user_screen.dart';
import 'package:movie_watchlist/views/welcome/splash_screen.dart';
import 'package:movie_watchlist/views/welcome/welcome_message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final hiveService = HiveService();
  await hiveService.initHive();

  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeMessage(),
        '/create-user': (context) => CreateUser(),
        '/main': (context) => const MainScreen(),
        '/mood': (context) => const EmojiScreen(),
        '/view-watchlist': (context) => const ViewWatchlistScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/add-movie': (context) => const AddMovieScreen(),
        '/add-show': (context) => const AddShowScreen(),
        '/add-watchlist': (context) =>const  AddWatchlistScreen(),
        '/edit-watchlist': (context) => const EditWatchlistScreen(),
        '/watchlist-detail': (context) => const WatchlistDetailScreen(),
        '/edit-movie': (context) => const EditMovieScreen(),
        '/edit-show': (context) => const EditShowScreen(),
        '/favourites': (context) => const FavoritesScreen(), 
        '/recents': (context) => const RecentlyViewedScreen(),
        '/search': (context) => const SearchScreen(),
      },
      //     onGenerateRoute: (settings) 
      //   if (settings.name == '/home') {
      //     return MaterialPageRoute(
      //       builder: (context) {
      //         return HomeScreen(
      //           onAddWatchlistPressed: () {
      //             Navigator.pushNamed(context, '/create-watchlist');
      //           },
      //         );
      //       },
      //     );
      //   }
      //   return null; 
      // },
    );
  }
}















