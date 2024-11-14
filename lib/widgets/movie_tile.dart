import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MovieTile extends StatelessWidget {
  const MovieTile({
    super.key,
    required this.title,
    required this.genre,
    required this.mood,
    this.movieImage,
  });

  final String title;
  final String genre;
  final String mood;
  final Uint8List? movieImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 35, 35, 35),
      ),
      height: 172,
      width: 140,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Movie Image
            Container(
              height: 80,
              width: 140,
              decoration: BoxDecoration(
                color: const Color.fromARGB(62, 123, 122, 122),
                borderRadius: BorderRadius.circular(6),
              ),
              child: movieImage != null
                  ? (kIsWeb
                  ? Image.memory(
                movieImage!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image,
                    color: Colors.white54,
                    size: 50,
                  );
                },
              )
                  : FutureBuilder<bool>(
                future: File(movieImage! as String).exists(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError || !(snapshot.data ?? false)) {
                    return const Icon(
                      Icons.image,
                      color: Colors.white54,
                      size: 50,
                    );
                  } else {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image(
                        image: MemoryImage(movieImage!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image,
                            color: Colors.white54,
                            size: 50,
                          );
                        },
                      ),
                    );
                  }
                },
              ))
                  : const Icon(
                Icons.image,
                color: Colors.white54,
                size: 50,
              ),
            ),
            const SizedBox(height: 8),
            // Movie Title
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis, // Prevent overflow text
            ),
            const SizedBox(height: 2),
            // Movie Genre
            Text(
              genre,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color.fromARGB(140, 255, 255, 255),
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // Movie Mood
            Text(
              mood,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color.fromARGB(255, 255, 214, 10), // Customize mood color
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
