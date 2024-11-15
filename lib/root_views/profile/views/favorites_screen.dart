import 'package:flutter/material.dart';
import 'package:movie_watchlist/models/watchlist_model.dart';
import 'package:movie_watchlist/services/movie_service.dart';
import 'package:movie_watchlist/services/show_service.dart';
import 'package:movie_watchlist/services/watchlist_service.dart';
import 'package:movie_watchlist/models/movie_model.dart'; // Import your movie model
import 'package:movie_watchlist/models/show_model.dart';
import 'package:movie_watchlist/shared_widgets/movie_tile.dart';
import 'package:movie_watchlist/shared_widgets/show_tile.dart';
import 'package:movie_watchlist/shared_widgets/watchlist_tile.dart'; // Import your show model

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

AppBar _buildAppBar() => AppBar(
      foregroundColor: Colors.white,
      title: const Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: Text(
          'Favourites',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 47, 47, 47),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
      ),
    );

class _FavoritesScreenState extends State<FavoritesScreen> {
  String selectedCategory = 'Watchlist';
  final WatchlistService _watchlistService = WatchlistService();
  final MovieService _movieService = MovieService();
  final ShowService _showService = ShowService();

  // Fetch favorite items based on selected category
  Widget _buildContent() {
    if (selectedCategory == 'Watchlist') {
      List<Watchlist> watchlists = _watchlistService.getFavoriteWatchlists();
      return _buildWatchlistGrid(watchlists);
    } else if (selectedCategory == 'Movies') {
      List<Movie> movies = _movieService.getFavouriteMovies();
      return _buildMoviesGrid(movies);
    } else if (selectedCategory == 'Shows') {
      List<Show> shows = _showService.getFavouriteShows();
      return _buildShowsGrid(shows);
    } else {
      return const Center(child: Text("No content available"));
    }
  }

  _loadWatchlist() async {
    _buildContent();
  }

// Helper to determine number of columns based on screen width
  int _getCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 1200) {
      return 8; // Large screens
    } else if (screenWidth >= 800) {
      return 4; // Medium screens
    } else if (screenWidth >= 600) {
      return 2; // Small screens
    } else {
      return 1; // Extra small screens
    }
  }

  double _getChildAspectRatio(BuildContext context) {
    int crossAxisCount = _getCrossAxisCount(context);
    // Adjust aspect ratio based on the crossAxisCount for tile consistency
    if (crossAxisCount == 4) {
      return 0.8;
    } else if (crossAxisCount == 3) {
      return 0.75;
    } else if (crossAxisCount == 2) {
      return 0.7;
    } else {
      return 0.9; // for single column, allow more height for a "tile" look
    }
  }

  // Generalized method to build item grids
  Widget _buildItemGrid<T>(
      {required List<T> items, required Widget Function(BuildContext, T) itemBuilder}) {
    return GridView.builder(
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        crossAxisSpacing: 8,
        mainAxisSpacing: 10,
        childAspectRatio: _getChildAspectRatio(context), // Adjust aspect ratio
      ),
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index]);
      },
    );
  }

  // Watchlist Grid
  Widget _buildWatchlistGrid(List<Watchlist> watchlists) {
    if (watchlists.isEmpty) {
      return const Center(
        child: Text(
          'No favorite watchlists available.',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }
    return _buildItemGrid(
      items: watchlists,
      itemBuilder: (context, item) => GestureDetector(
        onTap: () => _navigateToEditWatchlist(item.watchlistId),
        child: WatchlistTile(
          watchlistname: item.watchlistName,
          mood: item.watchlistMood,
          itemImage: item.watchlistImage,
        ),
      ),
    );
  }

  // Movies Grid
  Widget _buildMoviesGrid(List<Movie> movies) {
    if (movies.isEmpty) {
      return const Center(
        child: Text(
          'No favorite movies available.',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }
    return _buildItemGrid(
      items: movies,
      itemBuilder: (context, item) => GestureDetector(
        onTap: () => _navigateToEditMovie(item.movieId),
        child: MovieTile(
          title: item.movieName,
          genre: item.movieGenre,
          mood: item.movieMood,
          movieImage: item.movieImage,
        ),
      ),
    );
  }

  // Shows Grid
  Widget _buildShowsGrid(List<Show> shows) {
    if (shows.isEmpty) {
      return const Center(
        child: Text(
          'No favorite shows available.',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }
    return _buildItemGrid(
      items: shows,
      itemBuilder: (context, item) => GestureDetector(
        onTap: () => _navigateToEditShow(item),
        child: ShowTile(
          title: item.showName,
          genre: item.showGenre,
          mood: item.showMood,
          showImage: item.showImage,
        ),
      ),
    );
  }

  // Header buttons to switch between categories
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedCategory = 'Watchlist';
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedCategory == 'Watchlist'
                ? const Color.fromARGB(255, 46, 45, 45)
                : const Color.fromARGB(255, 62, 28, 158),
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          child: const Text('Watchlist'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedCategory = 'Movies';
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedCategory == 'Movies'
                ? const Color.fromARGB(255, 46, 45, 45)
                : const Color.fromARGB(255, 62, 28, 158),
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          child: const Text('Movies'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              selectedCategory = 'Shows';
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedCategory == 'Shows'
                ? const Color.fromARGB(255, 46, 45, 45)
                : const Color.fromARGB(255, 62, 28, 158),
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          child: const Text('Shows'),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () => _loadWatchlist(),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            Expanded(child: _buildContent()), // Dynamically display content
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // Dummy method for navigating to edit watchlist screen
  void _navigateToEditWatchlist(int watchlistId) {
    Navigator.pushNamed(context, '/watchlist-detail', arguments: watchlistId)
        .then((result) {
      if (result == true) {
        _loadWatchlist();
      }
    });
    print("Navigating to edit watchlist: $watchlistId");
  }

  // Dummy method for navigating to edit movie screen
  void _navigateToEditMovie(int movieId) {
    Navigator.pushNamed(context, '/edit-movie', arguments: movieId)
        .then((result) {
      if (result == true) {
        _buildContent();
      }
    });
    print("Navigating to edit movie: $movieId");
  }

  void _navigateToEditShow(Show show) {
    Navigator.pushNamed(context, '/edit-show', arguments: show)
        .then((result) {
      if (result == true) {
        _buildContent();
      }
    });
    print("Navigating to edit movie: $show");
  }
}
