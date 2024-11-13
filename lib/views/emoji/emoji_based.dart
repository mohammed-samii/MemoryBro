import 'package:flutter/material.dart';
import 'package:movie_watchlist/models/movie_model.dart';
import 'package:movie_watchlist/models/show_model.dart';
import 'package:movie_watchlist/models/watchlist_model.dart';
import 'package:movie_watchlist/services/movie_service.dart';
import 'package:movie_watchlist/services/show_service.dart';
import 'package:movie_watchlist/services/watchlist_service.dart';
import 'package:movie_watchlist/widgets/movie_tile.dart';
import 'package:movie_watchlist/widgets/show_tile.dart';
import 'package:movie_watchlist/widgets/watchlist_tile.dart';

class EmojiScreen extends StatefulWidget {
  const EmojiScreen({super.key});

  @override
  State<EmojiScreen> createState() => _EmojiScreenState();
}

class _EmojiScreenState extends State<EmojiScreen> {
  final WatchlistService _watchlistService = WatchlistService();
  final MovieService _movieService = MovieService();
  final ShowService _showService = ShowService();

  String selectedMood = ''; // To keep track of the selected mood

  @override
  void initState() {
    super.initState();
    loadData(); // Initial data load
  }

  void loadData() {
    setState(() {
      // This will trigger a rebuild with the updated mood data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: buildMoodPage(),
    );
  }

  Widget buildMoodPage() {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        loadData();
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            expandedHeight: 220,
            backgroundColor: const Color.fromRGBO(91, 9, 198, 1),
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'So, We all want to get the right movie for our mood',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Choose your mood, and let\'s binge\nwatch it together',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _buildMoodEmoji('😄'),
                          _buildMoodEmoji('😎'),
                          _buildMoodEmoji('😔'),
                          _buildMoodEmoji('🤣'),
                          _buildMoodEmoji('🤩'),
                        ],
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
                          fontFamily: 'Poppins',
                        ),
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
                      if (_movieService.getMoviesByMood(selectedMood).isNotEmpty) ...[
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
                      if (_showService.getShowsByMood(selectedMood).isNotEmpty) ...[
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodEmoji(String mood) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = mood;
          loadData();
        });
      },
      child: Container(
        alignment: Alignment.center,
        height: 40,
        width: 50,
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: selectedMood == mood
              ? Colors.blueAccent
              : const Color.fromARGB(155, 63, 0, 146),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          mood,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget buildWatchlistSection() {
    List<Watchlist> watchlists = _watchlistService.getWatchlistsByMood(selectedMood);
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
        : const SizedBox(
                    child: Text('No Watchlists in this mood!.', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Poppins'),),

        ); // No watchlists found, return empty space
  }

  Widget buildAllSection() {
    List<Movie> movies = _movieService.getMoviesByMood(selectedMood);
    List<Show> shows = _showService.getShowsByMood(selectedMood);
    List<dynamic> combinedItems = [...movies, ...shows];

    return combinedItems.isNotEmpty
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: combinedItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: item is Movie
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/edit-movie',
                                arguments: item.movieId);
                          },
                        child: MovieTile(
                            title: item.movieName,
                            movieImage: item.movieImage,
                            genre: item.movieGenre,
                            mood: item.movieMood,
                          ),
                      )
                      : GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/edit-show',
                                arguments: item);
                          },
                        child: ShowTile(
                            title: item.showName,
                            showImage: item.showImage,
                            mood: item.showMood,
                            genre: item.showGenre,
                          ),
                      ),
                );
              }).toList(),
            ),
          )
        : const SizedBox(
          child: Text('No movies or shows in this mood!.', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Poppins'),),
        ); // No movies or shows found, return empty space
  }

  // Separate movies section
  Widget buildMoviesSection() {
    List<Movie> movies = _movieService.getMoviesByMood(selectedMood);

    return movies.isNotEmpty
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: movies.map((movie) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/edit-movie',
                          arguments: movie.movieId);
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
          )
        : const SizedBox(); // No movies found, return empty space
  }

  // Separate shows section
  Widget buildShowsSection() {
    List<Show> shows = _showService.getShowsByMood(selectedMood);

    return shows.isNotEmpty
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: shows.map((show) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/edit-show',
                          arguments: show);
                    },
                    child: ShowTile(
                      title: show.showName,
                      showImage: show.showImage,
                      mood: show.showMood,
                      genre: show.showGenre,
                    ),
                  ),
                );
              }).toList(),
            ),
          )
        : const SizedBox(); // No shows found, return empty space
  }
}
