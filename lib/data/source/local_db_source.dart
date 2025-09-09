import 'package:hive/hive.dart';
import 'package:movie_app/data/modal/movie.dart';

class LocalDBSource {
 
  static const trendingBox = 'trending_movies';
  static const nowPlayingBox = 'now_playing_movies';
  static const movieDetailsBox = 'movie_details';
    static const bookmarksBox = 'bookmarked_movies';


  Future<void> cacheTrendingMovies(List<Movie> movies) async {
    var box = await Hive.openBox<Movie>(trendingBox);
    await box.clear();
    await box.addAll(movies);
  }

  Future<List<Movie>> getCachedTrendingMovies() async {
    var box = await Hive.openBox<Movie>(trendingBox);
    return box.values.toList();
  }

  Future<void> cacheNowPlayingMovies(List<Movie> movies) async {
    var box = await Hive.openBox<Movie>(nowPlayingBox);
    await box.clear();
    await box.addAll(movies);
  }

  Future<List<Movie>> getCachedNowPlayingMovies() async {
    var box = await Hive.openBox<Movie>(nowPlayingBox);
    return box.values.toList();
  }

  Future<void> cacheMovieDetails(Movie movie) async {
    var box = await Hive.openBox<Movie>(movieDetailsBox);
    await box.put(movie.id, movie);
  }

  Future<Movie?> getCachedMovieDetails(int id) async {
    var box = await Hive.openBox<Movie>(movieDetailsBox);
    return box.get(id);
  }

  Future<List<Movie>> getBookmarkedMovies() async {
    var box = await Hive.openBox<Movie>(bookmarksBox);
    return box.values.toList();
  }

  Future<void> bookmarkMovie(Movie movie) async {
    var box = await Hive.openBox<Movie>(bookmarksBox);
    await box.put(movie.id, movie);
  }

  Future<void> unbookmarkMovie(int movieId) async {
    var box = await Hive.openBox<Movie>(bookmarksBox);
    await box.delete(movieId);
  }
}








