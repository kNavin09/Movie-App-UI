import 'package:flutter/material.dart';
import 'package:movie_app/prasentation/widgets/movie_grid.dart';
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
      body: MovieGrid(
        movies: movies,
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
