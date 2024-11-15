import 'package:flutter/material.dart';

import 'package:movie_watchlist/services/movie_service.dart';
import 'package:movie_watchlist/services/show_service.dart';

class FullListPage extends StatelessWidget {
  final String title;
  final List<int> items; // Using a List of IDs as type instead of dynamic
  final ShowService showService = ShowService();
  final MovieService movieService = MovieService();
  
  FullListPage({required this.title, required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.grey[900],
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final itemId = items[index];
            if (title == 'Movies') {
              final movie = movieService.getMovieById(itemId);
              if (movie == null) return Container(); 

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        movie.movieName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        movieService.deleteMovie(movie.movieId);
                        items.removeAt(index);
                        (context as Element).markNeedsBuild(); // Trigger rebuild
                      },
                    ),
                  ],
                ),
              );
            } else if (title == 'Shows') {
              final show = showService.getShowById(itemId);
              if (show == null) return Container(); // Skip if show not found

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        show.showName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showService.deleteShow(show.showId);
                        items.removeAt(index);
                        (context as Element).markNeedsBuild(); // Trigger rebuild
                      },
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}