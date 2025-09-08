import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:movie_app/app.dart';
import 'package:movie_app/data/modal/movie.dart';
import 'package:movie_app/data/repository/movie_repository.dart';
import 'package:movie_app/data/source/local_db_source.dart';
import 'package:movie_app/data/source/tmdb_api_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await Hive.initFlutter();
  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<Movie>('movies');
  await Hive.openBox<Movie>('bookmarks');
  await Hive.openBox('settingsBox');
  final dio = Dio();
  final tmdbApi = TMDBApiSource(dio, baseUrl: "https://api.themoviedb.org/3");
  final localDb = LocalDBSource();
  final movieRepository = MovieRepository(
    remote: tmdbApi,
    local: localDb,
    apiKey: dotenv.env['TMDB_API_KEY'] ?? '',
  );

  runApp(MovieApp(movieRepository: movieRepository));
}
