import 'package:flutter/material.dart';
import 'package:movie_app/prasentation/movie_detail_page/movie_details_screen.dart';
import 'package:movie_app/prasentation/widgets/page_route_builder.dart';
import 'package:movie_app/utils/theme/text_style.dart';
import 'package:movie_app/utils/theme/theme_colors.dart';

class SeeAllMoviesScreen extends StatelessWidget {
  final String title;
  final List movies;
  const SeeAllMoviesScreen({
    Key? key,
    required this.title,
    required this.movies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.white),
        title: Text(
          title,
          style: AppTextStyles.customTextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.65,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
