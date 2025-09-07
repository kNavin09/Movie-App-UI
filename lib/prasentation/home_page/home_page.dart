import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/data/repository/movie_repository.dart';
import 'package:movie_app/prasentation/widgets/movie_list_item.dart';
import 'package:movie_app/prasentation/widgets/shimmers.dart';
import 'package:movie_app/utils/app_routes/page_routes.dart';
import 'package:movie_app/utils/constant/app_content.dart';
import 'package:movie_app/utils/theme/text_style.dart';
import 'package:movie_app/utils/theme/theme_colors.dart';
import '../../bloc/movie_bloc/movie_bloc.dart';
import '../../bloc/movie_bloc/movie_event.dart';
import '../../bloc/movie_bloc/movie_state.dart';

class HomeScreen extends StatelessWidget {
  final MovieRepository movieRepository;
  HomeScreen({required this.movieRepository, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final carouselHeight = screenSize.height * 0.15;
    final movieListHeight = screenSize.height * 0.28;
    final movieItemWidth = screenSize.width * 0.3;

    return BlocProvider(
      create: (_) => MovieBloc(repo: movieRepository)
        ..add(FetchTrendingMovies())
        ..add(FetchNowPlayingMovies()),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              AppStrings.home,
              style: AppTextStyles.customTextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.white),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
              ),
            ],
            bottom: const TabBar(
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.grey,
              indicatorColor: Colors.transparent,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(),
              tabs: [
                Tab(text: AppStrings.trending),
                Tab(text: AppStrings.nowPlaying),
              ],
            ),
          ),
          body: BlocBuilder<MovieBloc, MovieState>(
            builder: (context, state) {
              if (state is CombinedMoviesLoaded) {
                return TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCarousel(context, state, carouselHeight),
                          _buildSectionTitle(
                            AppStrings.trending,
                            screenSize,
                            context,
                            movies: state.trending,
                          ),
                          HorizontalMovieList(state.trending, (movie) {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.details,
                              arguments: movie.id,
                            );
                          }),
                          SizedBox(height: screenSize.height * 0.02),
                          _buildSectionTitle(
                            AppStrings.nowPlaying,
                            screenSize,
                            context,
                            movies: state.nowPlaying,
                          ),
                          HorizontalMovieList(state.nowPlaying, (movie) {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.details,
                              arguments: movie.id,
                            );
                          }),
                        ],
                      ),
                    ),
                    _buildMovieGrid(state.nowPlaying, context),
                  ],
                );
              }

              if (state is MovieLoading) {
                return TabBarView(
                  children: [
                    ShimmerUtils.buildTrendingTabShimmer(
                      carouselHeight: carouselHeight,
                      movieListHeight: movieListHeight,
                      movieItemWidthFraction: 0.3,
                      titleWidthFraction: 0.25,
                      screenSize: screenSize,
                      carouselItemCount: 3,
                      listItemCount: 5,
                    ),
                    _buildNowPlayingTabLoadingState(movieItemWidth, screenSize),
                  ],
                );
              }
              if (state is MovieLoadError) {
                return Center(
                  child: Text(
                    state.message,
                    style: AppTextStyles.customTextStyle(
                      color: AppColors.white,
                      fontSize: screenSize.width * 0.04,
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  _buildCarousel(
    BuildContext context,
    CombinedMoviesLoaded state,
    double carouselHeight,
  ) {
    return CarouselSlider(
      options: CarouselOptions(
        height: carouselHeight,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.7,
      ),
      items: state.trending.map((movie) {
        return GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.details,
            arguments: movie.id,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(
                    "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  movie.title,
                  style: AppTextStyles.customTextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  _buildSectionTitle(
    String title,
    Size screenSize,
    BuildContext context, {
    required List movies,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.customTextStyle(
              fontSize: screenSize.width * 0.05,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.viewAll,
                arguments: {'title': title, 'movies': movies},
              );
            },
            child: Text(
              "See All",
              style: AppTextStyles.customTextStyle(
                fontSize: 16,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildMovieGrid(List movies, BuildContext context) {
    return ShimmerUtils.buildShimmerGrid(
      itemCount: movies.length,
      childAspectRatio: 0.9,
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      borderRadius: 10.0,
    );
  }

  _buildNowPlayingTabLoadingState(double movieItemWidth, Size screenSize) {
    return ShimmerUtils.buildShimmerGrid(
      itemCount: 6,
      childAspectRatio: 0.9,
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      borderRadius: 10.0,
    );
  }
}