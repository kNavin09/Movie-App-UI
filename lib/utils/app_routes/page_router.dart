import 'package:flutter/material.dart';
import 'package:movie_app/data/repository/movie_repository.dart';
import 'package:movie_app/prasentation/home_page/all_movie_screen.dart';
import 'package:movie_app/prasentation/movie_detail_page/movie_details_screen.dart';
import 'package:movie_app/prasentation/search_page/search_screen.dart';
import 'package:movie_app/prasentation/splash/splash_screen.dart';
import 'package:movie_app/prasentation/widgets/bottom_navigatiopnbar.dart';
import 'package:movie_app/prasentation/widgets/page_route_builder.dart';
import 'package:movie_app/utils/app_routes/page_routes.dart';

class AppRouter {
  final MovieRepository movieRepository;
  AppRouter({required this.movieRepository});
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(movieRepository: movieRepository),
        );
      case AppRoutes.base:
        return MaterialPageRoute(
          builder: (_) => Base(movieRepository: movieRepository),
        );
      case AppRoutes.search:
        return SlidePageRoute(
          page: SearchScreen(),
          beginOffset: Offset(0.0, 1.0),
        );
      case AppRoutes.viewAll:
        final args = settings.arguments as Map<String, dynamic>;
        return SlidePageRoute(
          page: SeeAllMoviesScreen(
            title: args['title'] as String,
            movies: args['movies'] as List,
          ),
        );
      case AppRoutes.details:
        final movieId = settings.arguments as int;
        return SlidePageRoute(page: MovieDetailsPage(movieId: movieId));
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Route not found"))),
        );
    }
  }
}
