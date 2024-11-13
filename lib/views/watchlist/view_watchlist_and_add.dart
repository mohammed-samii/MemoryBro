import 'package:flutter/material.dart';
import 'package:movie_watchlist/models/watchlist_model.dart';
import 'package:movie_watchlist/services/watchlist_service.dart';
import 'package:movie_watchlist/widgets/watchlist_dated_tile.dart';

class ViewWatchlistScreen extends StatefulWidget {
  const ViewWatchlistScreen({super.key});

  @override
  State<ViewWatchlistScreen> createState() => _ViewWatchlistScreenState();
}

class _ViewWatchlistScreenState extends State<ViewWatchlistScreen> {
  final WatchlistService _watchlistService = WatchlistService();
  List<Watchlist> watchlists = []; 
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    _loadWatchlists();
    _watchlistService.getAllWatchlists();

  }

  Future<void> _loadWatchlists() async {
    debugPrint('Loading watchlists...');
    try {
      List<Watchlist> loadedWatchlists =  _watchlistService.getAllWatchlists();
      isLoading = false;
      
      for (var watchlist in loadedWatchlists) {
        await _watchlistService.getMoviesAndShowsFromWatchlist(watchlist.watchlistId);
      }

      setState(() {
        watchlists = loadedWatchlists;
        isLoading = false;
      });

    } catch (error) {
      debugPrint('Error loading watchlists: $error');
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'Your Watchlists',
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
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple)) 
          : RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              color: Colors.deepPurple,
              backgroundColor: Colors.transparent,
              onRefresh: () async {
                await _loadWatchlists();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 50, left: 40),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const Text(
                      'Watchlists',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    watchlists.isNotEmpty
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: watchlists.map((watchlist) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                              context, '/watchlist-detail',
                                              arguments: watchlist.watchlistId)
                                          .then((result) {
                                        if (result == true) {
                                          _loadWatchlists();
                                        }
                                      });
                                    },
                                    child: WatchlistDatedTile(
                                      watchlistname: watchlist.watchlistName,
                                      date: watchlist.watchlistAddedDate,
                                      itemImage: watchlist.watchlistImage,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        : const Text(
                            "You currently don't have\nany watchlists",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                color: Colors.white),
                          ),
                    const SizedBox(height: 150),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 35),
                        child: SizedBox(
                          height: 75,
                          width: 180,
                          child: ElevatedButton(
                            onPressed: () {
                              debugPrint('Navigating to Add Watchlist screen...');
                              Navigator.pushNamed(context, '/add-watchlist')
                                  .then((_) async {
                                await _loadWatchlists(); // Reload watchlists after adding
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(91, 9, 198, 1),
                              foregroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            child: const Text(
                              'Add A New\nWatchlist',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
