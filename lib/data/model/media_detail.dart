import 'package:flixora/data/model/media_item.dart';
import 'package:flixora/data/model/media_type.dart';
import 'package:flixora/resources/strings_app.dart';

class MediaSeason {
  const MediaSeason({
    required this.name,
    this.episodeCount,
    this.airDate,
    this.overview,
    this.posterPath,
    this.seasonNumber,
    this.voteAverage,
  });
  final String name;
  final int? episodeCount;
  final String? airDate;
  final String? overview;
  final String? posterPath;
  final int? seasonNumber;
  final double? voteAverage;

  factory MediaSeason.fromJson(Map<String, dynamic> json) {
    return MediaSeason(
      name: nonEmpty(json['name']) ?? 'Unknown Season',
      episodeCount: json['episode_count'] is num
          ? (json['episode_count'] as num).toInt()
          : null,
      airDate: nonEmpty(json['air_date']),
      overview: nonEmpty(json['overview']),
      posterPath: nonEmpty(json['poster_path']),
      seasonNumber: json['season_number'] is num
          ? (json['season_number'] as num).toInt()
          : null,
      voteAverage: json['vote_average'] is num
          ? (json['vote_average'] as num).toDouble()
          : null,
    );
  }
}

class ProductionCompany {
  const ProductionCompany({required this.name, this.logoPath});
  final String name;
  final String? logoPath;

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
      name: nonEmpty(json['name']) ?? 'Unknown',
      logoPath: nonEmpty(json['logo_path']),
    );
  }
}

class MediaDetail {
  const MediaDetail({
    required this.item,
    required this.genres,
    required this.adult,
    required this.productionCompanies,
    required this.seasonList,
    this.runtime,
    this.seasons,
    this.episodes,
  });
  final MediaItem item;
  final List<String> genres;
  final bool adult;
  final List<ProductionCompany> productionCompanies;
  final List<MediaSeason> seasonList;
  final int? runtime;
  final int? seasons;
  final int? episodes;

  factory MediaDetail.fromJson(Map<String, dynamic> json, MediaType type) {
    final rawGenres = json['genres'];
    final rawProd = json['production_companies'];
    final rawSeasons = json['seasons'];

    return MediaDetail(
      item: MediaItem.fromJson(json, type),
      genres: rawGenres is List
          ? rawGenres
                .whereType<Map>()
                .map((g) => nonEmpty(g['name']))
                .whereType<String>()
                .toList()
          : const [],
      adult: json['adult'] == true,
      productionCompanies: rawProd is List
          ? rawProd
                .whereType<Map>()
                .map(
                  (p) =>
                      ProductionCompany.fromJson(Map<String, dynamic>.from(p)),
                )
                .toList()
          : const [],
      seasonList: rawSeasons is List
          ? rawSeasons
                .whereType<Map>()
                .map((s) => MediaSeason.fromJson(Map<String, dynamic>.from(s)))
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
