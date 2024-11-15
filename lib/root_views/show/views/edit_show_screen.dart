import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:movie_watchlist/models/show_model.dart';
import 'package:movie_watchlist/services/show_service.dart';
import 'package:movie_watchlist/services/views_service.dart';
import 'package:movie_watchlist/shared_widgets/dropdown.dart';
import 'package:movie_watchlist/shared_widgets/textfield.dart';


class EditShowScreen extends StatefulWidget {
  const EditShowScreen({super.key});

  @override
  State<EditShowScreen> createState() => _EditShowScreenState();
}

class _EditShowScreenState extends State<EditShowScreen> {
  final ShowService _showService = ShowService();
  final ViewsService _viewsService = ViewsService();

  Show? show;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _seasonsController = TextEditingController();
  final TextEditingController _episodesController = TextEditingController();
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

  bool isFavorite = false;

  List<String> moods = [
    '😄',
    '😎',
    '😔',
    '🤣',
    '🤩',
  ];
  final TextEditingController _yearController = TextEditingController();
  String dropdownValue = 'Mixed';
  String moodValue = '😄';
  Uint8List? image;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      show = ModalRoute.of(context)?.settings.arguments as Show?;
          _viewsService.markAsViewed(show);

      setState(() {
        print(show!.showId);
        _nameController.text = show!.showName;
        dropdownValue = show!.showGenre;
        moodValue = show!.showMood;
        _yearController.text = show!.showYear.toString();
        _seasonsController.text = show!.showSeasons.toString();
        _episodesController.text = show!.showEpisodes.toString();
      }); // Rebuild the screen with show data
    });
  }

  Future<void> _deleteShow() async {
    if (show != null) {
      await _showService.deleteShow(show!.showId); // Delete the watchlist
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
          title: const Text('Delete Show'),
          content: Text('Are you sure you want to delete "${show!.showName}"?'),
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
                await _deleteShow(); // Proceed with deletion
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _toggleFavorite() async {
    if (show != null) {
      await _showService.toggleFavoriteShow(show!.showId);
      setState(() {
        isFavorite = !isFavorite; // Update favorite status
      });
    }
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

  Future<void> _updateshow() async {
    if (show != null) {
      Show updatedshow = Show(
        showId: show!.showId,
        showName: _nameController.text,
        showGenre: dropdownValue,
        showMood: moodValue,
        showYear: int.parse(_yearController.text),
        showStatus: 'pending',
        showSeasons: int.parse(_seasonsController.text),
        showEpisodes: int.parse(_episodesController.text),
        showImage: image != null
            ? image!
            : show!.showImage, // Update path if image is changed
        isFavourite: isFavorite,
      );

      if (_nameController.text.isEmpty) {
        _showSnackbar('Please enter the movie name');
        return;
      }

      if (_yearController.text.isEmpty) {
        _showSnackbar('Please enter the release year');
        return;
      }

      if (int.tryParse(_yearController.text) == null) {
        _showSnackbar('Please enter a valid year');
        return;
      }

      if (show!.showImage == null) {
        _showSnackbar('Please select an image');
        return;
      }

      if (_seasonsController.text.isEmpty) {
        _showSnackbar('Please enter the number of seasons');
        return;
      }

      if (_episodesController.text.isEmpty) {
        _showSnackbar('Please enter the number of episodes');
        return;
      }

      if (int.tryParse(_yearController.text) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid year')),
        );
        return;
      }

      // Check if any fields have changed before proceeding with the update
      if (_nameController.text != show!.showName ||
          dropdownValue != show!.showGenre ||
          moodValue != show!.showMood ||
          int.parse(_yearController.text) != show!.showYear ||
          int.parse(_seasonsController.text) != show!.showSeasons ||
          int.parse(_episodesController.text) != show!.showEpisodes ||
          (image != null && image! != show!.showImage)) {
        // Proceed to update only if any of the fields are changed
        await _showService.updateShow(updatedshow);
        setState(() {
          print('Show updated: ${updatedshow.showId}');
        });

        print('Update id: ${updatedshow.showId}');
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        print('No changes detected. Show not updated.');
      }
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = show?.showName ?? "Show Details";
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          foregroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              title,
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
                    onTap: () => _toggleFavorite(),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite,
                      color: isFavorite
                          ? Colors.deepPurple
                          : const Color.fromARGB(255, 97, 97, 97),
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
                          : show?.showImage != null
                              ? DecorationImage(
                                  image: MemoryImage(
                                      show!.showImage!), // Show existing image
                                  fit: BoxFit.cover,
                                )
                              : null,
                    ),
                    child: image == null && show?.showImage == null
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
                buildDropdown('Genre', genres, dropdownValue, (newGenre) {
                  setState(() {
                    dropdownValue = newGenre!;
                  });
                }),
                const SizedBox(height: 15),
                buildTextField('Year', _yearController),
                const SizedBox(
                  height: 15,
                ),
                buildDropdown('Mood', moods, moodValue, (newMood) {
                  setState(() {
                    moodValue = newMood!;
                  });
                }),
                const SizedBox(
                  height: 15,
                ),
                buildTextField('Seasons', _seasonsController),
                const SizedBox(
                  height: 15,
                ),
                buildTextField('Episodes', _episodesController),
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
                    onPressed: _updateshow,
                    child: const Text(
                      'Update show',
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
