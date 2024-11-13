import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WatchlistDatedTile extends StatelessWidget {
  const WatchlistDatedTile({
    super.key,
    required this.watchlistname,
    this.date,
    this.itemImage,
  });

  final String watchlistname;
  final DateTime? date;
  final String? itemImage;

  @override
  Widget build(BuildContext context) {
    String formattedDate = date != null
        ? DateFormat('MMM d, yyyy').format(date!)
        : 'No date provided';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 28, 28, 28),
      ),
      height: 180,
      width: 180,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 100,
              width: 160,
              decoration: BoxDecoration(
                color: const Color.fromARGB(23, 123, 122, 122),
                borderRadius: BorderRadius.circular(6),
              ),
              child: itemImage != null
                  ? (kIsWeb
                  ? Image.network(
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
                future: File(itemImage!).exists(),
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
                        image: FileImage(File(itemImage!)),
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
              formattedDate,
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
