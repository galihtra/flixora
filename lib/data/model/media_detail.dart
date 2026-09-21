import 'package:flixora/data/model/media_item.dart';
import 'package:flixora/data/model/media_type.dart';
import 'package:flixora/resources/strings_app.dart';

class MediaDetail {
  const MediaDetail({
    required this.item,
    required this.genres,
    this.runtime,
    this.seasons,
    this.episodes,
  });
  final MediaItem item;
  final List<String> genres;
  final int? runtime;
  final int? seasons;
  final int? episodes;

  factory MediaDetail.fromJson(Map<String, dynamic> json, MediaType type) {
    final rawGenres = json['genres'];
    return MediaDetail(
      item: MediaItem.fromJson(json, type),
      genres: rawGenres is List
          ? rawGenres
                .whereType<Map>()
                .map((g) => nonEmpty(g['name']))
                .whereType<String>()
                .toList()
          : const [],
      runtime: json['runtime'] is num ? (json['runtime'] as num).toInt() : null,
      seasons: json['number_of_seasons'] is num
          ? (json['number_of_seasons'] as num).toInt()
          : null,
      episodes: json['number_of_episodes'] is num
          ? (json['number_of_episodes'] as num).toInt()
          : null,
    );
  }

  String get durationLabel {
    if (item.type == MediaType.movie && runtime != null && runtime! > 0) {
      return '${runtime! ~/ 60}h ${runtime! % 60}m';
    }
    if (seasons != null && seasons! > 0) {
      return '$seasons ${seasons == 1 ? AppStrings.season : AppStrings.seasons} · ${episodes ?? 0} Episodes';
    }
    return '';
  }
}
