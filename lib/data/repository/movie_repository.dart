import 'dart:developer';

import 'package:movie_app/data/modal/movie.dart';
import 'package:movie_app/data/source/local_db_source.dart';
import 'package:movie_app/data/source/tmdb_api_source.dart';

const String baseUrl = "https://image.tmdb.org/t/p/w500";

class MovieRepository {
  final TMDBApiSource remote;
  final LocalDBSource local;
  final String apiKey;

  MovieRepository({
    required this.remote,
    required this.local,
    required this.apiKey,
  });

  Future<List<Movie>> fetchTrendingMovies() async {
    try {
      final response = await remote.getTrendingMovies(apiKey);
      log(apiKey);
      final movies = response.results;
      await local.cacheTrendingMovies(movies);
      return movies;
    } catch (_) {
      return await local.getCachedTrendingMovies();
    }
  }

  Future<List<Movie>> fetchNowPlayingMovies() async {
    try {
      final response = await remote.getNowPlayingMovies(apiKey);
      final nowPlaying = response.results;

      await local.cacheNowPlayingMovies(nowPlaying);
      return nowPlaying;
    } catch (_) {
      return await local.getCachedNowPlayingMovies();
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await remote.searchMovies(apiKey, query);
    final searchResults = response.results;

    return searchResults;
  }

  Future<Movie?> fetchMovieDetails(int id) async {
    try {
      final movieDetails = await remote.getMovieDetails(id, apiKey);

      await local.cacheMovieDetails(movieDetails);
      return movieDetails;
    } catch (_) {
      return await local.getCachedMovieDetails(id);
    }
  }
}
