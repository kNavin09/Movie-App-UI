import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/data/repository/movie_repository.dart';
import 'package:movie_app/utils/theme/theme_colors.dart';
import 'package:share_plus/share_plus.dart';
import '../../bloc/movie_bloc/movie_bloc.dart';
import '../../bloc/movie_bloc/movie_event.dart';
import '../../bloc/movie_bloc/movie_state.dart';

class MovieDetailsPage extends StatefulWidget {
  final int movieId;
  const MovieDetailsPage({required this.movieId, Key? key}) : super(key: key);

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(FetchMovieDetails(widget.movieId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.white,
              ),
            );
          }

          if (state is MovieLoadError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is MovieDetailsLoaded) {
            final movie = state.movie;
            return ListView(
              children: [
                AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          "$baseUrl${movie.posterPath}",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 25,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          movie.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.read<MovieBloc>().add(BookmarkMovie(movie));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              dismissDirection: DismissDirection.down,
                              content: Text('${movie.title} added to My List'),
                            ),
                          );
                        },
                        child: Container(
                          width: 100,
                          padding: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.accent,
                          ),
                          child: const Text(
                            "+ Add My List",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Release Date: ${movie.releaseDate}",
                        style: const TextStyle(color: Colors.white54),
                      ),
                      const SizedBox(width: 30),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.red,
                        ),
                        child: Text(
                          "IMDB: ${movie.voteAverage}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          Share.share(
                            'Check out "${movie.title}"!\nIMDB: ${movie.voteAverage}\nhttps://www.themoviedb.org/movie/${movie.id}',
                            subject: movie.title,
                          );
                        },
                        icon: const Icon(Icons.share, color: Colors.white),
                        tooltip: "Share",
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    movie.overview,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
