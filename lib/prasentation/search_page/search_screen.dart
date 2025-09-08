import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/prasentation/movie_detail_page/movie_details_screen.dart';
import 'package:movie_app/prasentation/widgets/comman_textform.dart';
import 'package:movie_app/utils/constant/app_content.dart';
import '../../bloc/movie_bloc/movie_bloc.dart';
import '../../bloc/movie_bloc/movie_event.dart';
import '../../bloc/movie_bloc/movie_state.dart';
import 'package:movie_app/utils/theme/theme_colors.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MovieBloc>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          AppStrings.searchMovie,
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: CustomTextField(
              hintText: AppStrings.searchType,
              onChanged: (query) {
                bloc.add(SearchMovies(query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state is SearchResultLoaded) {
                  if (state.movies.isEmpty) {
                    return const Center(
                      child: Text(
                        "Movie is not available",
                        style: TextStyle(color: AppColors.white, fontSize: 18),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.movies.length,
                    itemBuilder: (_, idx) {
                      final movie = state.movies[idx];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          title: Text(
                            movie.title,
                            style: const TextStyle(color: AppColors.white),
                          ),
                          leading: movie.posterPath.isNotEmpty
                              ? Image.network(
                                  'https://image.tmdb.org/t/p/w185${movie.posterPath}',
                                  width: 48,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                      ),
                                )
                              : Container(
                                  width: 48,
                                  height: 72,
                                  color: Colors.grey,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.white70,
                                  ),
                                ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MovieDetailsPage(movieId: movie.id),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
                if (state is MovieInitial) {
                  return const Center(
                    child: Text(
                      AppStrings.searchType,
                      style: TextStyle(color: AppColors.white),
                    ),
                  );
                }
                if (state is MovieLoading) {
                  return _buildShimmerList();
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.grey[800],
                ),
                const SizedBox(height: 8),
                Container(width: 150, height: 14, color: Colors.grey[800]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[600]!,
          child: _buildShimmerItem(),
        );
      },
    );
  }
}
