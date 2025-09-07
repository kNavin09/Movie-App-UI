import 'package:flutter/material.dart';
import 'package:movie_app/data/modal/movie.dart';

typedef MovieTapCallback = void Function(Movie movie);

class HorizontalMovieList extends StatelessWidget {
  final List<Movie> movies;
  final MovieTapCallback onMovieTap;

  const HorizontalMovieList(this.movies, this.onMovieTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () => onMovieTap(movie),
            child: Container(
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(
                    "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            /*         Container(
              width: 120,
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  movie.posterPath.isNotEmpty
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w185${movie.posterPath}',
                          fit: BoxFit.cover,
                          height: 160,
                          width: 120,
                        )
                      : Container(
                          color: Colors.grey,
                          height: 160,
                          width: 120,
                          child: Icon(Icons.movie),
                        ),
                  SizedBox(height: 4),
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
      */
          );
        },
      ),
    );
  }
}
