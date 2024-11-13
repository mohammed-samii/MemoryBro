import 'package:flutter/material.dart';
import 'package:movie_watchlist/models/movie_model.dart';
import 'package:movie_watchlist/models/show_model.dart';
import 'package:movie_watchlist/models/watchlist_model.dart';
import 'package:movie_watchlist/services/views_service.dart';
import 'package:movie_watchlist/widgets/movie_tile.dart';
import 'package:movie_watchlist/widgets/show_tile.dart';
import 'package:movie_watchlist/widgets/watchlist_tile.dart';

class RecentlyViewedScreen extends StatefulWidget {
  const RecentlyViewedScreen({super.key});

  @override
  _RecentlyViewedScreenState createState() => _RecentlyViewedScreenState();
}

class _RecentlyViewedScreenState extends State<RecentlyViewedScreen> {
  final ViewsService _viewsService = ViewsService();
  String selectedCategory = 'All';
  late Future<List<Movie>> recentlyViewedMovies;
  late Future<List<Show>> recentlyViewedShows;
  late Future<List<Watchlist>> recentlyViewedWatchlists;

  @override
  void initState() {
    super.initState();
    recentlyViewedMovies = _viewsService.getRecentlyViewedMovies(5);
    recentlyViewedShows = _viewsService.getRecentlyViewedShows(5);
    recentlyViewedWatchlists = _viewsService.getRecentlyViewedWatchlists(5);
  }

  AppBar _buildAppBar() => AppBar(
        title: const Text("Recently Viewed", style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
        backgroundColor: const Color.fromARGB(255, 47, 47, 47),
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
          ),
        ),
        centerTitle: true,
      );

  Widget _buildCategorySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ['All', 'Movies', 'Shows', 'Watchlists'].map((category) {
          return ChoiceChip(
            label: Text(
              category,
              style: TextStyle(
                color: selectedCategory == category
                    ? Colors.white
                    : Colors.grey[300],
              ),
            ),
            selected: selectedCategory == category,
            selectedColor: Colors.grey[800],
            onSelected: (bool selected) {
              setState(() {
                selectedCategory = category;
              });
            },
            backgroundColor: Colors.grey[600],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          _buildCategorySelector(),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedCategory == 'All' || selectedCategory == 'Movies')
                    _buildSection("Movies", recentlyViewedMovies),
                  if (selectedCategory == 'All' || selectedCategory == 'Shows')
                    _buildSection("Shows", recentlyViewedShows),
                  if (selectedCategory == 'All' ||
                      selectedCategory == 'Watchlists')
                    _buildSection("Watchlists", recentlyViewedWatchlists),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection<T>(String title, Future<List<T>> futureList) {
    return FutureBuilder<List<T>>(
      future: futureList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No recently viewed $title.', style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Poppins')));
        } else {
          var items = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 10),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Poppins'),
                ),
              ),
              const SizedBox(height: 5),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.94,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  if (items[index] is Movie) {
                    return GestureDetector(
                      onTap: () {
                            Navigator.pushNamed(context, '/edit-movie', arguments: items[index]);

                      },
                      child: MovieTile(
                        title: (items[index] as Movie).movieName,
                        genre: (items[index] as Movie).movieGenre,
                        mood: (items[index] as Movie).movieMood,
                        movieImage: (items[index] as Movie).movieImage,
                      ),
                    );
                  } else if (items[index] is Show) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/edit-show', arguments: items[index]);
                      },
                      child: ShowTile(
                        title: (items[index] as Show).showName,
                        genre: (items[index] as Show).showGenre,
                        mood: (items[index] as Show).showMood,
                        showImage: (items[index] as Show).showImage,
                      ),
                    );
                  } else if (items[index] is Watchlist) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/watchlist-detail', arguments: (items[index] as Watchlist).watchlistId);
                      },
                      child: WatchlistTile(
                        watchlistname: (items[index] as Watchlist).watchlistName,
                        mood: (items[index] as Watchlist).watchlistMood,
                        itemImage: (items[index] as Watchlist).watchlistImage,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          );
        }
      },
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
}
