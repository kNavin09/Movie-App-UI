import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_app/bloc/movie_bloc/movie_event.dart';
import 'package:movie_app/bloc/movie_bloc/movie_state.dart';
import 'package:movie_app/utils/constant/app_content.dart';
import 'package:movie_app/utils/theme/text_style.dart';
import 'package:movie_app/utils/theme/theme_colors.dart';

class BookmarkScreen extends StatefulWidget {
const   BookmarkScreen({Key? key}) : super(key: key);
  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(LoadBookmarks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        titleTextStyle: AppTextStyles.customTextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
        title: Text(AppStrings.myBookMarks),
      ),
      backgroundColor: AppColors.background,
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is BookmarksLoaded) {
            if (state.bookmarks.isEmpty) {
              return Center(
                child: Text(
                  'No movies added yet.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return ListView.builder(
              itemCount: state.bookmarks.length,
              itemBuilder: (context, index) {
                final movie = state.bookmarks[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                      fit: BoxFit.cover,
                      width: 48,
                      height: 72,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image, color: Colors.white),
                    ),
                  ),
                  title: Text(
                    movie.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    "IMDB: ${movie.voteAverage}",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.redAccent,
                    ),
                    tooltip: "Remove from My List",
                    onPressed: () {
                      context.read<MovieBloc>().add(UnbookmarkMovie(movie.id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Removed "${movie.title}" from My List',
                          ),
                        ),
                      );
                    },
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 12,
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
