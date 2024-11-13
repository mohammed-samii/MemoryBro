// Movie Section Widget
import 'package:flutter/material.dart';
import 'package:movie_watchlist/services/movie_service.dart';
import 'package:movie_watchlist/services/show_service.dart';
import 'package:movie_watchlist/views/watchlist/full_list_screen.dart';
import 'package:movie_watchlist/widgets/items_builder.dart';

class MovieSection extends StatefulWidget {
  final List<int> movieIds;

  const MovieSection({Key? key, required this.movieIds}) : super(key: key);

  @override
  _MovieSectionState createState() => _MovieSectionState();
}

class _MovieSectionState extends State<MovieSection> {
  final MovieService movieService = MovieService();

  void _deleteMovie(int movieId) {
    setState(() {
      widget.movieIds.remove(movieId);
      movieService.deleteMovie(movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Added Movies:',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.builder(
            itemCount: widget.movieIds.length > 2 ? 2 : widget.movieIds.length,
            itemBuilder: (context, index) {
              final movieId = widget.movieIds[index];
              final movie = movieService.getMovieById(movieId);

              if (movie == null) return Container(); // Skip if movie not found

              return buildMovieItem(movie.movieName, index, () {
                _deleteMovie(movieId); // Call delete function
              });
            },
          ),
        ),
        if (widget.movieIds.length > 2)
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullListPage(
                    title: 'Movies',
                    items: List.from(widget.movieIds), // Pass a copy of IDs
                  ),
                ),
              );
            },
            child: const Text(
              'See more',
              style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            ),
          ),
      ],
    );
  }
}

// Show Section Widget
class ShowSection extends StatefulWidget {
  final List<int> showIds;

  const ShowSection({Key? key, required this.showIds}) : super(key: key);

  @override
  _ShowSectionState createState() => _ShowSectionState();
}

class _ShowSectionState extends State<ShowSection> {
  final ShowService showService = ShowService();

  void _deleteShow(int showId) {
    setState(() {
      widget.showIds.remove(showId);
      showService.deleteShow(showId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Added Shows:',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.builder(
            itemCount: widget.showIds.length > 2 ? 2 : widget.showIds.length,
            itemBuilder: (context, index) {
              final showId = widget.showIds[index];
              final show = showService.getShowById(showId);

              if (show == null) return Container(); // Skip if show not found

              return buildShowItem(show.showName, index, () {
                _deleteShow(showId); // Call delete function
              });
            },
          ),
        ),
        if (widget.showIds.length > 2)
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullListPage(
                    title: 'Shows',
                    items: List.from(widget.showIds), // Pass a copy of IDs
                  ),
                ),
              );
            },
            child: const Text(
              'See more',
              style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            ),
          ),
      ],
    );
  }
}