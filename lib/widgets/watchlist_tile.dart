import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WatchlistTile extends StatelessWidget {
  const WatchlistTile({
    super.key,
    required this.watchlistname,
    this.mood,
    this.itemImage, // This now accepts Uint8List?
  });

  final String watchlistname;
  final String? mood;
  final Uint8List? itemImage; // Changed to Uint8List?

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 39, 38, 38),
      ),
      height: 150,
      width: 140,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 80,
              width: 140,
              decoration: BoxDecoration(
                color: const Color.fromARGB(62, 123, 122, 122),
                borderRadius: BorderRadius.circular(6),
              ),
              child: itemImage != null
                  ? (kIsWeb
                  ? Image.memory( // Use Image.memory for Uint8List
                itemImage!,
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
                future: File(itemImage.toString()).exists(),
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
                    // The file exists, so display the image
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.memory( // Use Image.memory for Uint8List
                        itemImage!,
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
            Text(
              watchlistname,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              mood ?? '',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Color.fromARGB(140, 255, 255, 255),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
