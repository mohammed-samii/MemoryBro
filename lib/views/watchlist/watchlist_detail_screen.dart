import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_watchlist/models/movie_model.dart';
import 'package:movie_watchlist/models/show_model.dart';
import 'package:movie_watchlist/models/watchlist_model.dart';
import 'package:movie_watchlist/services/views_service.dart';
import 'package:movie_watchlist/services/watchlist_service.dart';
import 'package:movie_watchlist/widgets/movie_tile.dart';
import 'package:movie_watchlist/widgets/show_tile.dart';

class WatchlistDetailScreen extends StatefulWidget {
  const WatchlistDetailScreen({super.key});

  @override
  State<WatchlistDetailScreen> createState() => _WatchlistDetailScreenState();
}

class _WatchlistDetailScreenState extends State<WatchlistDetailScreen> {
  final WatchlistService _watchlistService = WatchlistService();
  Watchlist? watchlist;
  int? watchlistId;
  String? searchQuery;
  bool isSearchMode = false;

  List<Movie> movies = [];
  List<Show> shows = [];
  List<dynamic> combinedItems = [];
  String? selectedGenre;
  String? selectedMood;
  String? selectedType;
  List<int> movieIds = [];
  List<int> showIds = [];

  final List<String> genres = [
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

  final List<String> moods = [
    '😄',
    '😎',
    '😔',
    '🤣',
    '🤩',
  ];

  bool isLoading = false;
  final ViewsService _viewsService = ViewsService();

  @override
  void initState() {
    super.initState();
    _loadWatchlist();

    isLoading = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (watchlistId == null) {
      watchlistId = ModalRoute.of(context)?.settings.arguments as int?;
      setState(() {
        _loadWatchlist();
      });
    }
  }

  Future<void> _loadWatchlist() async {
    if (watchlistId != null) {
      setState(() => isLoading = true);

      try {
        // Await the watchlist data
        watchlist = await _watchlistService.getWatchlistById(watchlistId!);
            _viewsService.markAsViewed(watchlist);

        print('WatchlistId: $watchlistId');
        print('Fetched watchlist: ${watchlist!.toString()}');
        print('Movies: here $movieIds');
        print('Shows: $shows');

        if (watchlist != null) {
          List<Movie> fetchedMovies =
              await _watchlistService.getMoviesFromWatchlist(watchlistId!);
          List<Show> fetchedShows =
              await _watchlistService.getShowsFromWatchlist(watchlistId!);

          setState(() {
            movies = fetchedMovies;
            shows = fetchedShows;
            combinedItems = [...movies, ...shows];
            isLoading = false; // Set loading to false after data is fetched
          });
        } else {
          setState(() => isLoading = false);
        }
      } catch (error) {
        print('Error loading watchlist: $error');
        setState(() => isLoading = false);
      }
    }
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
      combinedItems = _getFilteredItems(query);
    });
  }

  List<dynamic> _getFilteredItems(String query) {
    List<dynamic> filteredItems = [...combinedItems];

    if (query.isNotEmpty) {
      filteredItems = filteredItems
          .where((item) =>
              (item is Movie &&
                  item.movieName.toLowerCase().contains(query.toLowerCase())) ||
              (item is Show &&
                  item.showName.toLowerCase().contains(query.toLowerCase())) ||
              (item is Movie &&
                  item.movieGenre
                      .toLowerCase()
                      .contains(query.toLowerCase())) ||
              (item is Show &&
                  item.showGenre.toLowerCase().contains(query.toLowerCase())) ||
              (item is Movie &&
                  item.movieMood.toLowerCase().contains(query.toLowerCase())) ||
              (item is Show &&
                  item.showMood.toLowerCase().contains(query.toLowerCase())))
          .toList();
    }

    filteredItems =
        filteredItems.where((item) => _matchesSelectedFilters(item)).toList();

    return filteredItems;
  }

  void _resetSearch() {
    setState(() {
      isSearchMode = false;
      searchQuery = '';
      combinedItems = [...movies, ...shows];
    });
  }

  void _filterItems() {
    setState(() {
      combinedItems = _getFilteredItems(searchQuery ?? '');
    });
  }

  bool _matchesSelectedFilters(dynamic item) {
    bool matchGenre = selectedGenre == null ||
        (item is Movie && item.movieGenre == selectedGenre) ||
        (item is Show && item.showGenre == selectedGenre);
    bool matchMood = selectedMood == null ||
        (item is Movie && item.movieMood == selectedMood) ||
        (item is Show && item.showMood == selectedMood);
    bool matchType = selectedType == null ||
        (item is Movie && selectedType == 'Movies') ||
        (item is Show && selectedType == 'Shows');
    return matchGenre && matchMood && matchType;
  }

  void _resetFilters() {
    setState(() {
      selectedGenre = null;
      selectedMood = null;
      selectedType = null;
      combinedItems = [...movies, ...shows];
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildFilterDialog(context);
      },
    );
  }

  Widget _buildFilterDialog(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text(
            'Filter By',
            style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
          ),
          content: _buildFilterDialogContent(setState),
          actions: _buildFilterDialogActions(),
        );
      },
    );
  }

  Widget _buildFilterDialogContent(StateSetter setState) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDropdown(
          hint: 'Select Type',
          value: selectedType,
          items: ['Movies', 'Shows'],
          onChanged: (value) => setState(() => selectedType = value),
        ),
        const SizedBox(height: 10),
        _buildDropdown(
          hint: 'Select Genre',
          value: selectedGenre,
          items: genres,
          onChanged: (value) => setState(() => selectedGenre = value),
        ),
        const SizedBox(height: 10),
        _buildDropdown(
          hint: 'Select Mood',
          value: selectedMood,
          items: moods,
          onChanged: (value) => setState(() => selectedMood = value),
        ),
      ],
    );
  }

  List<Widget> _buildFilterDialogActions() {
    return [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          _resetFilters();
        },
        child: const Text('Reset', style: TextStyle(color: Colors.white)),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          _filterItems();
        },
        child: const Text('Apply', style: TextStyle(color: Colors.white)),
      ),
    ];
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(199, 41, 41, 41),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[700]!),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[500]!),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      dropdownColor: Colors.grey[800],
      hint: Text(hint, style: const TextStyle(color: Colors.white70)),
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: const TextStyle(color: Colors.white)),
        );
      }).toList(),
      onChanged: onChanged,
      iconEnabledColor: Colors.white,
    );
  }

  Future<void> _toggleFavorite() async {
    if (watchlist != null) {
      watchlist!.isFavourite = watchlist!.isFavourite;
      await _watchlistService.toggleFavoriteWatchlist(watchlist!.watchlistId);
      setState(() {});
    }
  }

  Future<void> _deleteWatchlist() async {
    if (watchlist != null) {
      await _watchlistService.deleteWatchlist(watchlist!.watchlistId);
      Navigator.pop(context);
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildDeleteConfirmationDialog(context);
      },
    );
  }

  Widget _buildDeleteConfirmationDialog(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(top: 25, left: 30, bottom: 10),
      actionsPadding: const EdgeInsets.only(top: 30, right: 30, bottom: 15),
      contentPadding: const EdgeInsets.only(top: 10, left: 30),
      title: const Text('Delete Watchlist',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
      content: Text(
          'Are you sure you want to delete "${watchlist!.watchlistName}"?\n\nNote: This will delete all movies and shows listed in the watchlist',
          style: const TextStyle(fontFamily: 'Poppins')),
      actions: _buildDeleteConfirmationActions(),
    );
  }

  List<Widget> _buildDeleteConfirmationActions() {
    return [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('No, Keep', style: TextStyle(fontFamily: 'Poppins')),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[100],
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () async {
          Navigator.of(context).pop();
          await _deleteWatchlist();
        },
        child:
            const Text('Yes, Delete', style: TextStyle(fontFamily: 'Poppins')),
      ),
    ];
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kIsWeb ? 70 : 60),
      child: AppBar(
        foregroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(top: kIsWeb ? 30 : 40), // Adjust horizontal padding
          child: isSearchMode ? _buildSearchField() : _buildTitle(),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0), // Adjust padding for leading icon
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        actions: _buildAppBarActions(),
        backgroundColor: const Color.fromARGB(255, 47, 47, 47),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(35),
            bottomRight: Radius.circular(35),
          ),
        ),
      ),
    );
  }


  Widget _buildSearchField() {
    return TextField(
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: 'Search...',
        hintStyle: TextStyle(color: Colors.white),
        border: InputBorder.none,
      ),
      onChanged: _onSearch,
    );
  }

  Widget _buildTitle() {
    return Text(
      watchlist?.watchlistName ?? 'Watchlist',
      style: const TextStyle(
          fontFamily: 'Poppins', color: Colors.white, fontSize: 25),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      if (!isSearchMode)
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _navigateToEditWatchlist(),
        ),
      IconButton(
        icon: Icon(isSearchMode ? Icons.close : Icons.search),
        onPressed: _toggleSearchMode,
      ),
    ];
  }

  void _navigateToEditWatchlist() {
    Navigator.pushNamed(context, '/edit-watchlist', arguments: watchlistId)
        .then((result) {
      if (result == true) {
        _loadWatchlist();
      }
    });
  }

  void _navigateToEditMovie(int movieId) {
    Navigator.pushNamed(context, '/edit-movie', arguments: movieId)
        .then((result) {
      if (result == true) {
        _loadWatchlist();
      }
      print(movieId);
    });
  }

  void _toggleSearchMode() {
    setState(() {
      isSearchMode = !isSearchMode;
      if (!isSearchMode) {
        _resetSearch();
      }
    });
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _loadWatchlist,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: _buildItemGrid(), // Build the grid of items
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildWatchlistDetails(),
        _buildActionsColumn(),
      ],
    );
  }

  Widget _buildWatchlistDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailText('Name: ${watchlist?.watchlistName ?? ''}'),
        const SizedBox(height: 8),
        _buildDetailText('Genre: ${watchlist?.watchlistGenre ?? ''}'),
        const SizedBox(height: 8),
        _buildDetailText('Mood: ${watchlist?.watchlistMood ?? ''}'),
      ],
    );
  }

  Widget _buildDetailText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Poppins',
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildActionsColumn() {
    return Column(
      children: [
        _buildFavoriteAndDeleteRow(),
        const SizedBox(height: 20),
        _buildFilterButton(),
      ],
    );
  }

  Widget _buildFavoriteAndDeleteRow() {
    return Row(
      children: [
        _buildFavoriteButton(),
        const SizedBox(width: 10),
        _buildDeleteButton(),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: Container(
        height: 45,
        width: 55,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          Icons.favorite_outlined,
          color: (watchlist?.isFavourite ?? false)
              ? Colors.deepPurple
              : const Color.fromARGB(197, 226, 226, 226),
          size: 30,
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: _showDeleteConfirmationDialog,
      child: Container(
        height: 45,
        width: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.red,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return SizedBox(
      height: 35,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color.fromARGB(195, 255, 255, 255),
          backgroundColor: const Color.fromARGB(194, 53, 52, 52),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        onPressed: _showFilterDialog,
        child: const FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filter'),
              SizedBox(width: 5),
              Icon(Icons.arrow_drop_down_outlined),
            ],
          ),
        ),
      ),
    );
  }


Widget _buildItemGrid() {
  if (combinedItems.isEmpty) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'Add movies or shows to this watchlist by edit.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  return GridView.builder(
    itemCount: combinedItems.length,
    padding: const EdgeInsets.all(8.0), // Padding around the grid
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: _getCrossAxisCount(context),
      crossAxisSpacing: 8,
      mainAxisSpacing: 10,
      childAspectRatio: _getChildAspectRatio(context), // Adjust aspect ratio
    ),
    itemBuilder: (context, index) {
      return _buildGridItem(combinedItems[index]);
    },
  );
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


  Widget _buildGridItem(dynamic item) {
    if (item is Movie) {
      return GestureDetector(
        onTap: () {
          _navigateToEditMovie(item.movieId);
          print(item.movieName);
        },
        child: MovieTile(
          title: item.movieName,
          genre: item.movieGenre,
          mood: item.movieMood,
          movieImage: item.movieImage,
        ),
      );
    } else if (item is Show) {
      return GestureDetector(
        onTap: () =>
            Navigator.pushNamed(context, '/edit-show', arguments: item),
        child: ShowTile(
          title: item.showName,
          genre: item.showGenre,
          mood: item.showMood,
          showImage: item.showImage,
        ),
      );
    }
    return const SizedBox.shrink();
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
