import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/data/modal/movie.dart';
import 'package:movie_app/data/repository/movie_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repo;

  List<Movie> trendingMovies = [];
  List<Movie> nowPlayingMovies = [];

  MovieBloc({required this.repo}) : super(MovieInitial()) {
    on<FetchTrendingMovies>((event, emit) async {
      emit(MovieLoading());
      try {
        trendingMovies = await repo.fetchTrendingMovies();
        emit(CombinedMoviesLoaded(trendingMovies, nowPlayingMovies));
      } catch (e) {
        emit(MovieLoadError('Error loading trending movies: $e'));
      }
    });

    on<FetchNowPlayingMovies>((event, emit) async {
      emit(MovieLoading());
      try {
        nowPlayingMovies = await repo.fetchNowPlayingMovies();
        emit(CombinedMoviesLoaded(trendingMovies, nowPlayingMovies));
      } catch (e) {
        emit(MovieLoadError('Error loading now playing movies: $e'));
      }
    });

    on<SearchMovies>(
      (event, emit) async {
        emit(MovieLoading());
        try {
          final movies = await repo.searchMovies(event.query);
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
        final movie = await repo.fetchMovieDetails(event.id);
        if (movie == null) {
          emit(MovieLoadError("Movie details not found"));
        } else {
          emit(MovieDetailsLoaded(movie));
        }
      } catch (e) {
        emit(MovieLoadError('Failed to load movie details: $e'));
      }
    });

    on<BookmarkMovie>((event, emit) async {
      await repo.local.bookmarkMovie(event.movie);
      await repo.local.bookmarkMovie(event.movie);
      //   emit(BookmarksLoaded(repo!.local.getBookmarkedMovies()));
    });

    on<UnbookmarkMovie>((event, emit) async {
      await repo.local.unbookmarkMovie(event.movieId);
      final bookmarkedMovies = await repo.local.getBookmarkedMovies();
      emit(BookmarksLoaded(bookmarkedMovies));
    });

    on<LoadBookmarks>((event, emit) async {
      final bookmarkedMovies = await repo.local
          .getBookmarkedMovies(); 
      emit(BookmarksLoaded(bookmarkedMovies));
    });
  }
}
