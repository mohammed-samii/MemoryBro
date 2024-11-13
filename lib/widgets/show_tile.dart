import 'dart:io';
import 'package:flutter/material.dart';

class ShowTile extends StatelessWidget {
  const ShowTile({
    super.key,
    required this.title,
  required this.genre,
    required this.mood,
        this.showImage,
  });

  final String title;
  final String genre;
  final String mood;
  final String? showImage;

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
            Container(
              height: 80,
              width: 140,
              decoration: BoxDecoration(
                color: const Color.fromARGB(62, 123, 122, 122),
                borderRadius: BorderRadius.circular(6),
              ),
              child: showImage != null
                  ? FutureBuilder<bool>(
                      future: File(showImage!).exists(),
                      builder: (context, snapshot) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image(
                              image: FileImage(File(showImage!)),
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
                        
                      },
                    )
                  : const Icon(
                      Icons.image,
                      color: Colors.white54,
                      size: 50,
                    ),
            ),
            const SizedBox(height: 8),
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
            Text(
              mood,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color.fromARGB(255, 255, 214, 10),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
