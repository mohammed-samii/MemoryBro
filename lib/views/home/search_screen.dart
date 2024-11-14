import 'package:flutter/material.dart';
import 'package:movie_watchlist/models/movie_model.dart';
import 'package:movie_watchlist/models/show_model.dart';
import 'package:movie_watchlist/models/watchlist_model.dart';
import 'package:movie_watchlist/services/hive_service.dart';
import 'package:movie_watchlist/widgets/movie_tile.dart';
import 'package:movie_watchlist/widgets/show_tile.dart';
import 'package:movie_watchlist/widgets/watchlist_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  List<Movie> _movies = [];
  List<Show> _shows = [];
  List<Watchlist> _watchlists = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final movieBox = HiveService().getMoviesBox();
    final showBox = HiveService().getShowsBox();
    final watchlistBox = HiveService().getWatchlistBox();

    setState(() {
      _movies = movieBox.values.toList();
      _shows = showBox.values.toList();
      _watchlists = watchlistBox.values.toList();
    });
  }

  List<dynamic> _searchResults() {
    List<dynamic> results = [];

    // Search Movies
    results.addAll(_movies.where((movie) =>
        movie.movieName.toLowerCase().contains(_searchQuery.toLowerCase())));

    // Search Shows
    results.addAll(_shows.where((show) =>
        show.showName.toLowerCase().contains(_searchQuery.toLowerCase())));

    // Search Watchlists
    results.addAll(_watchlists.where((watchlist) =>
        watchlist.watchlistName.toLowerCase().contains(_searchQuery.toLowerCase())));

    return results;
  }

  int _getCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 1200) {
      return 8;
    } else if (screenWidth >= 800) {
      return 4;
    } else if (screenWidth >= 600) {
      return 2;
    } else {
      return 1;
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

  void _navigateToEditMovie(int movieId) {
    // Replace with actual navigation to movie edit page
    Navigator.pushNamed(context, '/edit-movie', arguments: movieId);
  }




  void _navigateToEditShow(Show show) {
    // Replace with actual navigation to show edit page
    Navigator.pushNamed(context, '/edit-show', arguments: show);
  }

  void _navigateToWatchlistDetail(Watchlist watchlist) {
    // Replace with actual navigation to watchlist detail page
    Navigator.pushNamed(context, '/watchlist-detail', arguments: watchlist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Search', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: GridView.builder(
                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getCrossAxisCount(context),
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: _getChildAspectRatio(context),
                ),
                itemCount: _searchResults().length,
                itemBuilder: (context, index) {
                  var item = _searchResults()[index];

                  if (item is Movie) {
                    return GestureDetector(
                      onTap: () => _navigateToEditMovie(item.movieId),
                      child: MovieTile(
                        title: item.movieName,
                        genre: item.movieGenre,
                        mood: item.movieMood,
                        movieImage: item.movieImage,
                      ),
                    );
                  } else if (item is Show) {
                    return GestureDetector(
                      onTap: () => _navigateToEditShow(item),
                      child: ShowTile(
                        title: item.showName,
                        genre: item.showGenre,
                        mood: item.showMood,
                        showImage: item.showImage,
                      ),
                    );
                  } else if (item is Watchlist) {
                    return GestureDetector(
                      onTap: () => _navigateToWatchlistDetail(item),
                      child: WatchlistTile(
                        watchlistname: item.watchlistName,
                        mood: item.watchlistMood,
                        itemImage: item.watchlistImage,
                      ),
                    );
                  }

                  return Container(); // Just in case of any unexpected data type
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
