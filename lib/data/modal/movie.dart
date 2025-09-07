import 'package:hive/hive.dart';
part 'movie.g.dart';

@HiveType(typeId: 0)
class Movie extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String overview;

  @HiveField(3)
  final String posterPath;

  @HiveField(4)
  final String releaseDate;

  @HiveField(5)
  final String originalLanguage;

  @HiveField(6)
  final String voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.originalLanguage,
    required this.voteAverage,
  });
  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        overview: json['overview'] ?? '',
        posterPath: json['poster_path'] ?? '',
        releaseDate: json['release_date'] ?? '',
        originalLanguage: json['original_language'] ?? '',
        voteAverage: (json['vote_average']?.toString()) ?? '0.0',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'overview': overview,
        'poster_path': posterPath,
        'release_date': releaseDate,
        'original_language': originalLanguage,
        'vote_average': voteAverage,
      };
}
