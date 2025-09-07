import 'package:movie_app/data/modal/movie.dart';
import 'package:retrofit/retrofit.dart';

import 'package:dio/dio.dart';
part 'tmdb_api_source.g.dart';

@RestApi(baseUrl: "https://api.themoviedb.org/3")
abstract class TMDBApiSource {
  factory TMDBApiSource(Dio dio, {String baseUrl}) = _TMDBApiSource;

  @GET("/trending/movie/day")
  Future<MovieResponse> getTrendingMovies(@Query("api_key") String apiKey);

  @GET("/movie/now_playing")
  Future<MovieResponse> getNowPlayingMovies(@Query("api_key") String apiKey);

  @GET("/search/movie")
  Future<MovieResponse> searchMovies(
    @Query("api_key") String apiKey,
    @Query("query") String query,
  );

  @GET("/movie/{movie_id}")
  Future<Movie> getMovieDetails(
    @Path("movie_id") int movieId,
    @Query("api_key") String apiKey,
  );
}

class MovieResponse {
  final List<Movie> results;

  MovieResponse({required this.results});

  factory MovieResponse.fromJson(Map<String, dynamic> json) => MovieResponse(
    results: (json['results'] as List).map((e) => Movie.fromJson(e)).toList(),
  );
}
