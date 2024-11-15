import 'package:flutter/material.dart';
import 'package:movie_watchlist/models/movie_model.dart';
import 'package:movie_watchlist/models/show_model.dart';
import 'package:movie_watchlist/models/watchlist_model.dart';
import 'package:movie_watchlist/services/movie_service.dart';
import 'package:movie_watchlist/services/show_service.dart';
import 'package:movie_watchlist/services/user_service.dart';
import 'package:movie_watchlist/services/watchlist_service.dart';
import 'package:movie_watchlist/shared_widgets/movie_tile.dart';
import 'package:movie_watchlist/shared_widgets/show_tile.dart';
import 'package:movie_watchlist/shared_widgets/watchlist_tile.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService userService = UserService();
  final WatchlistService _watchlistService = WatchlistService();
  final MovieService _movieService = MovieService();
  final ShowService _showService = ShowService();

  bool checkWatchlistExists() {
    final watchlists = _watchlistService.getAllWatchlists();
    return watchlists.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      // Reloads all data sections on refresh
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(

        preferredSize: const Size.fromHeight(0), // Set to 0 to hide AppBar
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromRGBO(91, 9, 198, 1),
        ),
      ),
      backgroundColor: Colors.black,
      body: checkWatchlistExists()
          ? buildWatchlistHomePage()
          : buildDefaultHomePage(),
    );
  }

  Widget buildDefaultHomePage() {
    return RefreshIndicator(
      onRefresh: loadData,
      child: ListView(
        children: [
          Container(
            height: 270,
            width: double.maxFinite,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(91, 9, 198, 1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 13, left: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    ValueListenableBuilder<String?>(
                      valueListenable: userService.usernameNotifier,
                      builder: (context, username, child) {
                        return Text(
                          'Welcome, ${username ?? 'Guest'} 👋🏻',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Looks like you are here for the\nfirst time.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Add a new movie by clicking the\nbutton below.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      'Let’s start our beautiful Journey 🎬.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 120),
          const Center(
            child: Text(
              'ADD A NEW WATCHLIST',
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWatchlistHomePage() {
    return RefreshIndicator(
      onRefresh: loadData,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            )),
            expandedHeight: 260,
            backgroundColor: const Color.fromRGBO(91, 9, 198, 1),
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 13, left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      ValueListenableBuilder<String?>(
                        valueListenable: userService.usernameNotifier,
                        builder: (context, username, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Welcome, ${username ?? 'Guest'} 👋🏻',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/search');
                                    },
                                    icon: const Icon(Icons.search, color: Colors.white)),
                              )
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'We have some watchlists to finish now.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Are you ready to disconnect yourself \nfrom reality',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Let’s start our beautiful Journey 🎬.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'All Watchlists',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 10),
                      buildWatchlistSection(),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
Padding(
  padding: const EdgeInsets.only(left: 25),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const Text(
        'All Movies/Shows',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Poppins',
        ),
      ),
      const SizedBox(height: 10),
      buildAllSection(),
      const SizedBox(height: 20),

      // Movies Section
      if (_movieService.getAllMovies().isNotEmpty) ...[
        const Text(
          'Movies',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 10),
        buildMoviesSection(),
        const SizedBox(height: 20),
      ],

      // Shows Section
      if (_showService.getAllShows().isNotEmpty) ...[
        const Text(
          'Shows',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 10),
        buildShowsSection(),
      ],
    ],
  ),
),],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWatchlistSection() {
    List<Watchlist> watchlists = _watchlistService.getAllWatchlists();
    return watchlists.isNotEmpty
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: watchlists.map((watchlist) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/watchlist-detail',
                          arguments: watchlist.watchlistId);
                    },
                    child: WatchlistTile(
                      watchlistname: watchlist.watchlistName,
                      mood: watchlist.watchlistMood,
                      itemImage: watchlist.watchlistImage,
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        : const Text(
            "No watchlists found",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 18, color: Colors.white),
          );
  }

  Widget buildAllSection() {
    List<Movie> movies = _movieService.getAllMovies();
    List<Show> shows = _showService.getAllShows();
    List<dynamic> combinedItems = [...movies, ...shows];

    return combinedItems.isNotEmpty
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: combinedItems.map((item) {
                return Padding(
  padding: const EdgeInsets.only(right: 10),
  child: Builder(
    builder: (context) {
      Widget content;
      if (item is Movie) {
        content = GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/edit-movie', arguments: item.movieId);
          },
          child: MovieTile(
            title: item.movieName,
            movieImage: item.movieImage,
            genre: item.movieGenre,
            mood: item.movieMood,
          ),
        );
      } else if (item is Show) {
        content = GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/edit-show', arguments: item);
          },
          child: ShowTile(
            title: item.showName,
            showImage: item.showImage,
            mood: item.showMood,
            genre: item.showGenre,
          ),
        );
      } else {
        content = SizedBox.shrink(); // Empty widget if item is neither Movie nor Show.
      }

      return content;
    },
  ),
);


              }).toList(),
            ),
          )
        : const Text(
            "No movies or shows found",
            style: TextStyle(
                fontFamily: 'Poppins', fontSize: 18, color: Colors.white),
          );
  }

  // Separate movies section
Widget buildMoviesSection() {
  List<Movie> movies = _movieService.getAllMovies();

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: movies.map((movie) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/edit-movie', arguments: movie.movieId);
            },
            child: MovieTile(
              title: movie.movieName,
              movieImage: movie.movieImage,
              genre: movie.movieGenre,
              mood: movie.movieMood,
            ),
          ),
        );
      }).toList(),
    ),
  );
}

// Separate shows section
Widget buildShowsSection() {
  List<Show> shows = _showService.getAllShows();

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: shows.map((show) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/edit-show', arguments: show);
            },
            child: ShowTile(
              title: show.showName,
              showImage: show.showImage,
              genre: show.showGenre,
              mood: show.showMood,
            ),
          ),
        );
      }).toList(),
    ),
  );
}
}
