import 'package:equatable/equatable.dart';
import 'package:movie_app/data/modal/movie.dart';

abstract class MovieEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTrendingMovies extends MovieEvent {}

class FetchNowPlayingMovies extends MovieEvent {}

class SearchMovies extends MovieEvent {
  final String query;
  SearchMovies(this.query);
  @override
  List<Object?> get props => [query];
}

class FetchMovieDetails extends MovieEvent {
  final int id;
  FetchMovieDetails(this.id);
}

class BookmarkMovie extends MovieEvent {
  final Movie movie;
  BookmarkMovie(this.movie);
}

class UnbookmarkMovie extends MovieEvent {
  final int movieId;
  UnbookmarkMovie(this.movieId);
}

class LoadBookmarks extends MovieEvent {}
