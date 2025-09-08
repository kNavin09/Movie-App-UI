import 'package:flutter/material.dart';
import 'package:movie_app/data/repository/movie_repository.dart';
import 'package:movie_app/prasentation/movie_detail_page/movie_details_screen.dart';
import 'package:movie_app/prasentation/widgets/movie_dialog.dart';
import 'package:movie_app/prasentation/widgets/page_route_builder.dart';

class MovieGrid extends StatelessWidget {
  final List movies;
  final int crossAxisCount;
  final double childAspectRatio;
  final EdgeInsetsGeometry padding;

  const MovieGrid({
    super.key,
    required this.movies,
    this.crossAxisCount = 3,
    this.childAspectRatio = 0.9,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              SlidePageRoute(page: MovieDetailsPage(movieId: movie.id)),
            );
          },
          onLongPress: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) {
                return MovieDialog(
                  imageUrl: "$baseUrl${movie.posterPath}",
                  rating: movie.voteAverage?.toString(),
                  overview: movie.overview ?? '',
                  onClose: () => Navigator.of(ctx).pop(),
                );
              },
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              "https://image.tmdb.org/t/p/w500${movie.posterPath}",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey,
                child: const Icon(Icons.error, color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
