import 'package:equatable/equatable.dart';
import 'package:movie_app/data/modal/movie.dart';

abstract class MovieState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}
class MovieLoading extends MovieState {}
class CombinedMoviesLoaded extends MovieState {
  final List<Movie> trending;
  final List<Movie> nowPlaying;

  CombinedMoviesLoaded(this.trending, this.nowPlaying);

  @override
  List<Object?> get props => [trending, nowPlaying];
}


class TrendingMoviesLoaded extends MovieState {
  final List<Movie> movies;
  TrendingMoviesLoaded(this.movies);
}

class NowPlayingMoviesLoaded extends MovieState {
  final List<Movie> movies;
  NowPlayingMoviesLoaded(this.movies);
}

class SearchResultLoaded extends MovieState {
  final List<Movie> movies;
  SearchResultLoaded(this.movies);
}

class MovieDetailsLoaded extends MovieState {
  final Movie movie;
  MovieDetailsLoaded(this.movie);
}
class BookmarksLoaded extends MovieState {
  final List<Movie> bookmarks;
  BookmarksLoaded(this.bookmarks);

  @override
  List<Object?> get props => [bookmarks];
}

class MovieLoadError extends MovieState {
  final String message;

  MovieLoadError(this.message);

  @override
  List<Object?> get props => [message];
}
