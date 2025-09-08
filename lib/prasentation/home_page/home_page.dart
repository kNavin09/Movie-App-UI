import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/data/repository/movie_repository.dart';
import 'package:movie_app/prasentation/widgets/comman_refersh.dart';
import 'package:movie_app/prasentation/widgets/comman_tabs.dart';
import 'package:movie_app/prasentation/widgets/cpmman_crousel.dart';
import 'package:movie_app/prasentation/widgets/movie_grid.dart';
import 'package:movie_app/prasentation/widgets/movie_list_item.dart';
import 'package:movie_app/prasentation/widgets/loader/shimmers.dart';
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

    return BlocProvider(
      create: (_) => MovieBloc(repo: movieRepository)
        ..add(FetchTrendingMovies())
        ..add(FetchNowPlayingMovies()),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: true,
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
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.search),
                  ),
                ],
                bottom: const TabBar(
                  isScrollable: true,
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
            ],
            body: BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state is CombinedMoviesLoaded) {
                  return TabBarView(
                    children: [
                      CommanTab(
                        child: CustomRefresher(
                          onRefresh: () async {
                            context.read<MovieBloc>().add(
                              FetchTrendingMovies(),
                            );
                            await Future.delayed(
                              const Duration(milliseconds: 500),
                            );
                          },

                          child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              SliverToBoxAdapter(
                                child: CommonCarousel(
                                  items: state.trending,
                                  height: carouselHeight,
                                  imageUrl: (movie) =>
                                      "$baseUrl${movie.posterPath}",
                                  title: (movie) => movie.title,
                                  onTap: (movie) => Navigator.pushNamed(
                                    context,
                                    AppRoutes.details,
                                    arguments: movie.id,
                                  ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: _buildSectionTitle(
                                  AppStrings.trending,
                                  screenSize,
                                  context,
                                  movies: state.trending,
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: state.trending.isEmpty
                                    ? const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Text(
                                            'No trending movies available',
                                            style: TextStyle(
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : HorizontalMovieList(state.trending, (
                                        movie,
                                      ) {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.details,
                                          arguments: movie.id,
                                        );
                                      }),
                              ),
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  height: screenSize.height * 0.02,
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: _buildSectionTitle(
                                  AppStrings.nowPlaying,
                                  screenSize,
                                  context,
                                  movies: state.nowPlaying,
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: state.nowPlaying.isEmpty
                                    ? const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Text(
                                            'No now playing movies available',
                                            style: TextStyle(
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : HorizontalMovieList(state.nowPlaying, (
                                        movie,
                                      ) {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.details,
                                          arguments: movie.id,
                                        );
                                      }),
                              ),
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  height: screenSize.height * 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CommanTab(
                        child: CustomRefresher(
                          onRefresh: () async {
                            context.read<MovieBloc>().add(
                              FetchNowPlayingMovies(),
                            );
                            await Future.delayed(
                              const Duration(milliseconds: 500),
                            );
                          },
                          child: state.nowPlaying.isEmpty
                              ? SingleChildScrollView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        'No now playing movies available',
                                        style: TextStyle(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : MovieGrid(
                                  movies: state.nowPlaying,
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.65,
                                  padding: const EdgeInsets.all(12),
                                ),
                        ),
                      ),
                    ],
                  );
                }

                if (state is MovieLoading) {
                  return TabBarView(
                    children: [
                      CommanTab(
                        child: ShimmerWidget.buildTrendingTabShimmer(
                          carouselHeight: carouselHeight,
                          movieListHeight: movieListHeight,
                          movieItemWidthFraction: 0.3,
                          titleWidthFraction: 0.25,
                          screenSize: screenSize,
                          carouselItemCount: 3,
                          listItemCount: 5,
                        ),
                      ),
                      CommanTab(
                        child: ShimmerWidget.buildShimmerGrid(
                          itemCount: 6,
                          childAspectRatio: 0.9,
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          borderRadius: 10.0,
                        ),
                      ),
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
      ),
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
}
