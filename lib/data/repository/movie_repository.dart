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
      print('Trending Movies Response: ${response.results}');
      await local.saveMovies(response.results);
      return response.results;
    } catch (e) {
      print('Error fetching trending movies: $e');
      return local.getMovies();
    }
  }

  Future<List<Movie>> fetchNowPlayingMovies() async {
    try {
      final response = await remote.getNowPlayingMovies(apiKey);
      print('Now Playing Movies Response: ${response.results}');
      await local.saveMovies(response.results);
      return response.results;
    } catch (e) {
      print('Error fetching now playing movies: $e');
      return local.getMovies();
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await remote.searchMovies(apiKey, query);
    return response.results;
  }

  Future<Movie> fetchMovieDetails(int id) async {
    try {
      return await remote.getMovieDetails(id, apiKey);
    } catch (_) {
      return local.getMovies().firstWhere((m) => m.id == id);
    }
  }
}
