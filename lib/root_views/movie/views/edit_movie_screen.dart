import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:movie_watchlist/models/movie_model.dart';
import 'package:movie_watchlist/services/movie_service.dart';
import 'package:movie_watchlist/services/views_service.dart';
import 'package:movie_watchlist/shared_widgets/dropdown.dart';
import 'package:movie_watchlist/shared_widgets/textfield.dart';

class EditMovieScreen extends StatefulWidget {
  const EditMovieScreen({super.key});

  @override
  State<EditMovieScreen> createState() => _EditMovieScreenState();
}

class _EditMovieScreenState extends State<EditMovieScreen> {
  final ViewsService _viewsService = ViewsService();
  int? movieId;
  final MovieService _movieService = MovieService();
  Movie? movie;
  final TextEditingController _nameController = TextEditingController();
  List<String> movieGenres = [
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

  List<String> movieMoods = [
    '😄',
    '😎',
    '😔',
    '🤣',
    '🤩',
  ];
  final TextEditingController _movieYearController = TextEditingController();
  String dropdownValue = 'Mixed';
  String movieMoodValue = '😄';
  Uint8List? image; // Store image as Uint8List

  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      movieId = ModalRoute.of(context)?.settings.arguments as int?;
      if (movieId != null) {
        setState(() {
          movieId = movieId;
        });
        _loadMovieDetails(movieId!);
      }
    });
  }

  Future<void> _loadMovieDetails(int movieId) async {
    print('Movie is first here: $movieId');
    movie = _movieService.getMovieById(movieId);
              _viewsService.markAsViewed(movie);

    print(
        'Movie is here: ${movie!.movieName} ${movie!.movieGenre} ${movie!.movieMood} ${movie!.movieYear} ${movie!.movieStatus} ${movie!.movieImage}');
    setState(() {
      if (movie != null) {
        _nameController.text = movie!.movieName;
        dropdownValue = movie!.movieGenre;
        movieMoodValue = movie!.movieMood;
        _movieYearController.text = movie!.movieYear.toString();
        isFavorite = movie!.isFavourite;
      }
    });
  }

    Future<void> _toggleFavorite() async {
    if (movie != null) {
      await _movieService.toggleFavoriteMovie(movie!.movieId);
      setState(() {
        isFavorite = !isFavorite; // Update favorite status
      });
    }
  }

  Future<void> _deleteMovie() async {
    if (movie != null) {
      await _movieService.deleteMovie(movie!.movieId); // Delete the watchlist
      print('Movie deleted');
      Navigator.pop(context); // Return to the previous screen after deletion
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(top: 25, left: 20, bottom: 10),
          actionsPadding:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
          contentPadding: const EdgeInsets.only(top: 10, left: 20),
          title: const Text('Delete Movie'),
          content:
              Text('Are you sure you want to delete \n "${movie!.movieName}"?'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[100],
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: const Text('No, Keep'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without deleting
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              child: const Text('Yes, Delete'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _deleteMovie(); // Proceed with deletion
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    try {
      if (kIsWeb) {
        // Web platform
        Uint8List? pickedFile = await ImagePickerWeb.getImageAsBytes();
        print('Image picked on web');

        if (pickedFile != null) {
          setState(() {
            image = pickedFile;
            print('Image picked and updated (web)');
          });
        } else {
          print('No image selected on web');
        }
      } else {
        // Mobile (Android/iOS)
        final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
        print('Image picked on mobile');

        if (pickedFile != null) {
          final bytes = await File(pickedFile.path).readAsBytes();
          print('Bytes read: ${bytes.length}');  // Debugging line

          setState(() {
            image = bytes;
            print('Image picked and updated');
          });
        } else {
          print('No image selected on mobile');
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }


  void _updateMovie() async {
    if (movie != null) {
      print(
          "Updating movie: ${_nameController.text}, $dropdownValue, $movieMoodValue, ${_movieYearController.text}");

      Movie updatedMovie = Movie(
          movieId: movie!.movieId,
          movieName: _nameController.text,
          movieGenre: dropdownValue,
          movieMood: movieMoodValue,
          movieYear: int.parse(_movieYearController.text),
          movieStatus: 'pending',
          movieImage: image != null ? image! : movie!.movieImage,
          isFavourite: isFavorite);

          if (_nameController.text.isEmpty) {
      _showSnackbar('Please enter the movie name');
      return;
    }

    if (_movieYearController.text.isEmpty) {
      _showSnackbar('Please enter the release year');
      return;
    }

    if (int.tryParse(_movieYearController.text) == null) {
      _showSnackbar('Please enter a valid year');
      return;
    }

    if (movie!.movieImage == null) {
      _showSnackbar('Please select an image');
      return;
    }

      await _movieService.updateMovie(updatedMovie);
      debugPrint(
          "Movie upmovied: ${updatedMovie.movieName}, ${updatedMovie.movieGenre}, ${updatedMovie.movieMood}, ${updatedMovie.movieYear}");

      Navigator.pop(context, true);
    }
  }
    void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
          title: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              movie?.movieName ?? 'null',
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _toggleFavorite, 
                    child: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite, 
                      color: isFavorite ? Colors.deepPurple : const Color.fromARGB(255, 97, 97, 97),
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: _showDeleteConfirmationDialog,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 30,
                    ),
                  )
                ],
              ),
            )
          ],
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 140,
                    width: 220,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(4),
                      image: image != null
                          ? DecorationImage(
                              image: MemoryImage(
                                  image!), // Show new image if picked
                              fit: BoxFit.cover,
                            )
                          : movie?.movieImage != null
                              ? DecorationImage(
                                  image: MemoryImage(movie!.movieImage!), // Show existing image
                                  fit: BoxFit.cover,
                                )
                              : null,
                    ),
                    child: image == null && movie?.movieImage == null
                        ? const Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                buildTextField('Name', _nameController),
                const SizedBox(
                  height: 15,
                ),
                buildDropdown('movieGenre', movieGenres, dropdownValue,
                    (newmovieGenre) {
                  setState(() {
                    dropdownValue = newmovieGenre!;
                  });
                }),
                const SizedBox(height: 15),
                buildTextField('movieYear', _movieYearController),
                const SizedBox(
                  height: 15,
                ),
                buildDropdown('movieMood', movieMoods, movieMoodValue,
                    (newmovieMood) {
                  setState(() {
                    movieMoodValue = newmovieMood!;
                  });
                }),
                const SizedBox(
                  height: 30,
                ),
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
                    onPressed: _updateMovie,
                    child: const Text(
                      'Update Movie',
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
    );
  }
}
