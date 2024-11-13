import 'package:flutter/material.dart';
import 'package:movie_watchlist/models/watchlist_model.dart';
import 'package:movie_watchlist/services/watchlist_service.dart';
import 'package:movie_watchlist/widgets/dropdown.dart';
import 'package:movie_watchlist/widgets/section_builder.dart';
import 'package:movie_watchlist/widgets/textfield.dart';

class EditWatchlistScreen extends StatefulWidget {
  const EditWatchlistScreen({super.key});

  @override
  State<EditWatchlistScreen> createState() => _EditWatchlistScreenState();
}

class _EditWatchlistScreenState extends State<EditWatchlistScreen> {
  final WatchlistService _watchlistService = WatchlistService();

  Watchlist? watchlist;
  int? watchlistId;
  List<int> movieIds = [];
  List<int> showIds = [];

  // List of genres and moods
  List<String> genres = [
    'Mixed',
    'Action',
    'Adventure',
    'Comedy',
    'Drama',
    'Fantasy',
    'Horror',
    'Romance',
    'Sci-Fi',
    'Thriller'
  ];

  List<String> moods = [
    '😄',
    '😎',
    '😔',
    '🤣',
    '🤩',
  ];

  // Controllers for pre-filled fields
  final TextEditingController _nameController = TextEditingController();
  String dropdownValue = 'Mixed';
  String moodValue = '😄';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      watchlistId = ModalRoute.of(context)?.settings.arguments as int?;
      _loadWatchlist();
    });
  }

  _addMovie() async {
    final result = await Navigator.pushNamed(context, '/add-movie');
    if (result != null && result is Map) {
      setState(() {
        movieIds.add(result['movieId'] as int);
      });
    }
  }

  _addShow() async {
    final result = await Navigator.pushNamed(context, '/add-show');
    if (result != null && result is Map) {
      setState(() {
        showIds.add(result['showId'] as int);
      });
    }
  }

  Future<void> _loadWatchlist() async {
    if (watchlistId != null) {
      watchlist = await _watchlistService.getWatchlistById(watchlistId!);
      if (watchlist != null) {
        setState(() {
          _nameController.text = watchlist!.watchlistName;
          dropdownValue = watchlist!.watchlistGenre;
          moodValue = watchlist!.watchlistMood;
          movieIds.addAll(watchlist!.movieIds);
          showIds.addAll(watchlist!.showIds);

        });
      }
    }
                          print('heello $showIds                                                 ');
  }

  Future<void> _updateWatchlist() async {
    if (_validateFields()) {
      Watchlist updatedWatchlist = Watchlist(
        watchlistId: watchlist!.watchlistId,
        watchlistName: _nameController.text,
        watchlistGenre: dropdownValue,
        watchlistMood: moodValue,
        watchlistImage: watchlist!.watchlistImage,
        movieIds: movieIds,
        showIds: showIds,
        isFavourite: watchlist!.isFavourite,
        watchlistAddedDate: watchlist!.watchlistAddedDate,
        watchlistStatus: watchlist!.watchlistStatus,
      );

      await _watchlistService.updateWatchlist(updatedWatchlist);
      Navigator.pop(context, true); // Return true to indicate success
    }
  }

  bool _validateFields() {
    if (_nameController.text.isEmpty) {
      _showErrorDialog("Name cannot be empty");
      return false;
    }
    if (movieIds.isEmpty && showIds.isEmpty) {
      _showErrorDialog("Please add at least one movie or show");
      return false;
    }
    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Validation Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          foregroundColor: Colors.white,
          title: const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Edit WatchList',
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
      ),
      body: Center(
        child: Container(
          height: 500,
          width: 320,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'Edit WatchList',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 25),
                    buildTextField('Name', _nameController),
                    const SizedBox(height: 15),
                    buildDropdown('Genre', genres, dropdownValue, (newGenre) {
                      setState(() {
                        dropdownValue = newGenre!;
                      });
                    }),
                    const SizedBox(height: 15),
                    buildDropdown('Mood', moods, moodValue, (newMood) {
                      setState(() {
                        moodValue = newMood!;
                      });
                    }),
                    const SizedBox(height: 20),
                    if (movieIds.isNotEmpty) ...[
                      MovieSection(movieIds: movieIds),
                    ],
                    SizedBox(
                      height: 50,
                      width: 270,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              const Color.fromARGB(195, 255, 255, 255),
                          backgroundColor:
                              const Color.fromARGB(194, 53, 52, 52),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        onPressed: _addMovie,
                        child: const Text(
                          'ADD MOVIE',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (showIds.isNotEmpty) ...[
                      ShowSection(showIds: showIds),
                    ],
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 50,
                      width: 270,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              const Color.fromARGB(195, 255, 255, 255),
                          backgroundColor:
                              const Color.fromARGB(194, 53, 52, 52),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        onPressed: _addShow,
                        child: const Text(
                          'ADD SHOW',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 45,
                      width: 185,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromRGBO(96, 0, 219, 86),
                        ),
                        onPressed: _updateWatchlist,
                        child: const Text(
                          'Update WatchList',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
