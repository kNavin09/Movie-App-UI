import 'package:hive/hive.dart';
import 'package:movie_app/data/modal/movie.dart';

class LocalDBSource {
  final Box<Movie> movieBox = Hive.box<Movie>('movies');
  final Box<Movie> bookmarkBox = Hive.box<Movie>('bookmarks');

  // Save movies to the main box
  Future<void> saveMovies(List<Movie> movies) async {
    for (var movie in movies) {
      await movieBox.put(movie.id, movie);
    }
  }

  // Retrieve all movies from the main box
  List<Movie> getMovies() => movieBox.values.toList();

  // Add a movie to bookmarks (box)
  Future<void> bookmarkMovie(Movie movie) async {
    if (!bookmarkBox.containsKey(movie.id)) {
      await bookmarkBox.put(movie.id, movie);
    }
  }

  // Remove a movie from bookmarks (box)
  Future<void> unbookmarkMovie(int id) async {
    await bookmarkBox.delete(id);
  }

  // Retrieve all bookmarked movies (from box)
  List<Movie> getBookmarkedMovies() => bookmarkBox.values.toList();

  // Check if a movie is bookmarked
  bool isBookmarked(int id) => bookmarkBox.containsKey(id);
}
