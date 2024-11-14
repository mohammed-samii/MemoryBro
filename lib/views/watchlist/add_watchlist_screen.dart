import 'package:flutter/material.dart';
import 'package:movie_watchlist/models/watchlist_model.dart';
import 'package:movie_watchlist/services/watchlist_service.dart';
import 'package:movie_watchlist/widgets/dropdown.dart';
import 'package:movie_watchlist/widgets/textfield.dart';

class AddWatchlistScreen extends StatefulWidget {
  const AddWatchlistScreen({super.key});

  @override
  State<AddWatchlistScreen> createState() => _AddWatchlistScreenState();
}

class _AddWatchlistScreenState extends State<AddWatchlistScreen> {
  final TextEditingController _nameController = TextEditingController();
  String dropdownValue = 'Mixed';
  String moodValue = '😄';

  final WatchlistService _watchlistService = WatchlistService();
  int watchlistId = 0;

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

  Future<void> _saveWatchlist() async {
    String watchlistName = _nameController.text.trim();

    if (watchlistName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a watchlist name')),
      );
      return;
    }

    try {
      Watchlist newWatchlist = Watchlist(
        watchlistId: watchlistId,
        watchlistName: watchlistName,
        movieIds: [], 
        showIds: [],  
        isFavourite: false,
        watchlistGenre: dropdownValue,
        watchlistMood: moodValue,
        watchlistAddedDate: DateTime.now(),
        // watchlistImage = [],
        watchlistStatus: 'Incomplete',
      );

      await _watchlistService.addWatchlist(newWatchlist);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved watchlist successfully')),
      );

      Navigator.pop(context, true);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving watchlist')),
      );
    }

    _nameController.clear();
    setState(() {
      dropdownValue = 'Mixed';
      moodValue = '😄';
    });
  }

  @override
  void initState() {
    watchlistId =
      _watchlistService.generateId(_watchlistService.getWatchlistBox());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          foregroundColor: Colors.white,
          title: const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Add WatchList',
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
          height: 380,
          width: 320,
          decoration: BoxDecoration(
              color: Colors.grey[900], borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Scrollbar(
              child: SingleChildScrollView(
                controller: PageController(),
                child: Column(
                  children: [
                    const Text(
                      'Add WatchList',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
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

                    // Add Watchlist Button with Save Logic
                    SizedBox(
                        height: 45,
                        width: 155,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromRGBO(96, 0, 219, 86),
                            ),
                            onPressed: _saveWatchlist, // Save watchlist logic
                            child: const Text(
                              'Add WatchList',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ))),
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
