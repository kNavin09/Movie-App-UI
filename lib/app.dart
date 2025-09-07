import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/movie_bloc/movie_bloc.dart';
import 'package:movie_app/data/repository/movie_repository.dart';
import 'package:movie_app/prasentation/splash/splash_screen.dart';
import 'package:movie_app/utils/app_routes/page_router.dart';
import 'package:movie_app/utils/app_routes/page_routes.dart';

class MovieApp extends StatelessWidget {
  final MovieRepository movieRepository;
  const MovieApp({required this.movieRepository, super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: movieRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => MovieBloc(repo: movieRepository)),
        ],
        child: MaterialApp(
          title: "Movie App",
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRouter(
            movieRepository: movieRepository,
          ).onGenerateRoute,
        ),
      ),
    );
  }
}
