import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/data/modal/movie.dart';
import 'package:movie_app/data/repository/movie_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository? repo;

  List<Movie> trendingMovies = [];
  List<Movie> nowPlayingMovies = [];
  MovieBloc({this.repo}) : super(MovieInitial()) {
    on<FetchTrendingMovies>((event, emit) async {
      emit(MovieLoading());
      try {
        trendingMovies = await repo!.fetchTrendingMovies();
        emit(CombinedMoviesLoaded(trendingMovies, nowPlayingMovies));
      } catch (e) {
        emit(MovieLoadError('Error loading trending: $e'));
      }
    });

    on<FetchNowPlayingMovies>((event, emit) async {
      emit(MovieLoading());
      try {
        nowPlayingMovies = await repo!.fetchNowPlayingMovies();
        emit(CombinedMoviesLoaded(trendingMovies, nowPlayingMovies));
      } catch (e) {
        emit(MovieLoadError('Error loading now playing: $e'));
      }
    });
    on<SearchMovies>(
      (event, emit) async {
        emit(MovieLoading());
        try {
          final movies = await repo!.searchMovies(event.query);
          emit(SearchResultLoaded(movies));
        } catch (e) {
          emit(MovieLoadError('Search failed: $e'));
        }
      },
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 500))
          .asyncExpand(mapper),
    );

    on<FetchMovieDetails>((event, emit) async {
      emit(MovieLoading());
      try {
        if (repo == null) {
          emit(MovieLoadError('Movie repository not initialized'));
          return;
        }
        final movie = await repo!.fetchMovieDetails(event.id);
        emit(MovieDetailsLoaded(movie));
      } catch (e) {
        emit(MovieLoadError('Failed to load movie details: $e'));
      }
    });

    on<BookmarkMovie>((event, emit) async {
      await repo!.local.bookmarkMovie(event.movie);
    });

    on<UnbookmarkMovie>((event, emit) async {
      await repo!.local.unbookmarkMovie(event.movieId);
      emit(BookmarksLoaded(repo!.local.getBookmarkedMovies()));
    });

    on<LoadBookmarks>((event, emit) async {
      emit(BookmarksLoaded(repo!.local.getBookmarkedMovies()));
    });
  }
}
