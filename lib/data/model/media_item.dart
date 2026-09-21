import 'package:flixora/data/model/media_type.dart';
import 'package:flixora/resources/strings_app.dart';

String? nonEmpty(Object? value) =>
    value is String && value.trim().isNotEmpty ? value : null;
int asInt(Object? value) => value is num ? value.toInt() : 0;
double asDouble(Object? value) => value is num ? value.toDouble() : 0;

class MediaItem {
  const MediaItem({
    required this.id,
    required this.type,
    required this.title,
    this.posterPath,
    this.backdropPath,
    this.overview = '',
    this.rating = 0,
    this.voteCount = 0,
    this.releaseDate,
  });

  final int id;
  final MediaType type;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final String overview;
  final double rating;
  final int voteCount;
  final String? releaseDate;

  String get key => '${type.name}:$id';
  String get year =>
      (releaseDate?.length ?? 0) >= 4 ? releaseDate!.substring(0, 4) : '—';

  factory MediaItem.fromJson(Map<String, dynamic> json, MediaType type) =>
      MediaItem(
        id: asInt(json['id']),
        type: type,
        title:
            nonEmpty(json[type == MediaType.movie ? 'title' : 'name']) ??
            AppStrings.untitled,
        posterPath: nonEmpty(json['poster_path']),
        backdropPath: nonEmpty(json['backdrop_path']),
        overview: nonEmpty(json['overview']) ?? '',
        rating: asDouble(json['vote_average']),
        voteCount: asInt(json['vote_count']),
        releaseDate: nonEmpty(
          json[type == MediaType.movie ? 'release_date' : 'first_air_date'],
        ),
      );

  factory MediaItem.fromStorage(Map<String, dynamic> json) {
    final type = json['type'] == 'tv' ? MediaType.tv : MediaType.movie;
    return MediaItem(
      id: asInt(json['id']),
      type: type,
      title: nonEmpty(json['title']) ?? AppStrings.untitled,
      posterPath: nonEmpty(json['posterPath']),
      rating: asDouble(json['rating']),
    );
  }

  Map<String, dynamic> toStorage() => {
    'id': id,
    'type': type.name,
    'title': title,
    'posterPath': posterPath,
    'rating': rating,
  };
}
