import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:movie_watchlist/models/movie_model.dart';
import 'package:movie_watchlist/services/movie_service.dart';
// import 'package:movie_watchlist/services/views_service.dart';

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});


  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  // final ViewsService _viewsService = ViewsService();
  final MovieService _movieService = MovieService();
  final ValueNotifier<String> dropdownValue = ValueNotifier<String>('Action');
  final ValueNotifier<String> moodValue = ValueNotifier<String>('😄');
  Uint8List? image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

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


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _addMovie() async {
    String name = _nameController.text.trim();
    String year = _yearController.text.trim();
    String genre = dropdownValue.value;
    String mood = moodValue.value;
    Uint8List imagePath = image!;

    if (name.isEmpty) {
      _showSnackbar('Please enter the movie name');
      return;
    }

    if (year.isEmpty) {
      _showSnackbar('Please enter the release year');
      return;
    }

    if (int.tryParse(year) == null) {
      _showSnackbar('Please enter a valid year');
      return;
    }

    if (image == null) {
      _showSnackbar('Please select an image');
      return;
    }

    int movieId = _movieService.generateId(_movieService.getMoviesBox());

    Movie newMovie = Movie(
      movieId: movieId,
      movieName: name,
      movieYear: int.parse(year),
      movieGenre: genre,
      movieMood: mood,
      movieImage: imagePath,
      movieStatus: "Pending",
      isFavourite: false,
    );

    await _movieService.addMovie(newMovie);

    Navigator.pop(context, {'movieId': movieId});
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> genres = [
      'Action', 'Adventure', 'Comedy', 'Drama', 'Fantasy', 'Horror', 'Romance', 'Sci-Fi', 'Thriller'
    ];

    List<String> moods = [
      '😄', '😎', '😔', '🤣', '🤩',
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'Add Movie',
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
                          ? DecorationImage(image: MemoryImage(image!), fit: BoxFit.cover)
                          : null,
                    ),
                    child: image == null
                        ? const Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField('Name', _nameController),
                const SizedBox(height: 15),
                ValueListenableBuilder<String>(
                  valueListenable: dropdownValue,
                  builder: (context, value, child) {
                    return _buildDropdown('Genre', genres, value, (newGenre) {
                      dropdownValue.value = newGenre!;
                    });
                  },
                ),
                const SizedBox(height: 15),
                _buildTextField('Year', _yearController),
                const SizedBox(height: 15),
                ValueListenableBuilder<String>(
                  valueListenable: moodValue,
                  builder: (context, value, child) {
                    return _buildDropdown('Mood', moods, value, (newMood) {
                      moodValue.value = newMood!;
                    });
                  },
                ),
                const SizedBox(height: 30),
                
                SizedBox(
                  height: 45,
                  width: 155,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(96, 0, 219, 86),
                    ),
                    onPressed: _addMovie,
                    child: const Text(
                      'Add Movie',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      color: const Color.fromARGB(103, 45, 45, 45),
      height: 50,
      width: 320,
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(
            color: Color.fromARGB(207, 255, 255, 255),
            fontFamily: 'Poppins',
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(59, 255, 255, 255)),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, ValueChanged<String?> onChanged) {
    return Container(
      color: const Color.fromARGB(103, 45, 45, 45),
      height: 50,
      width: 320,
      child: DropdownButtonFormField<String>(
        value: value,
        dropdownColor: Colors.black87,
        style: const TextStyle(color: Color.fromARGB(203, 255, 255, 255)),
        iconEnabledColor: Colors.white,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromARGB(59, 255, 255, 255)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        items: items.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
