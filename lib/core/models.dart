enum MediaType { movie, tv }

extension MediaTypePath on MediaType {
  String get label => this == MediaType.movie ? 'Movie' : 'TV Show';
}

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
            'Untitled',
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
      title: nonEmpty(json['title']) ?? 'Untitled',
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
      return '$seasons ${seasons == 1 ? 'Season' : 'Seasons'} · ${episodes ?? 0} Episodes';
    }
    return '';
  }
}

class MediaPage {
  const MediaPage(this.items, this.page, this.totalPages);
  final List<MediaItem> items;
  final int page;
  final int totalPages;
}

class CatalogCategory {
  const CatalogCategory(this.title, this.path, this.type);
  final String title;
  final String path;
  final MediaType type;
}

abstract final class Categories {
  static const popularMovies = CatalogCategory(
    'Popular Movies',
    '/movie/popular',
    MediaType.movie,
  );
  static const topMovies = CatalogCategory(
    'Top Rated Movies',
    '/movie/top_rated',
    MediaType.movie,
  );
  static const nowPlaying = CatalogCategory(
    'Now Playing',
    '/movie/now_playing',
    MediaType.movie,
  );
  static const upcoming = CatalogCategory(
    'Coming Soon',
    '/movie/upcoming',
    MediaType.movie,
  );
  static const popularTv = CatalogCategory(
    'Popular TV Shows',
    '/tv/popular',
    MediaType.tv,
  );
  static const topTv = CatalogCategory(
    'Top Rated TV Shows',
    '/tv/top_rated',
    MediaType.tv,
  );
  static const home = [
    popularMovies,
    topMovies,
    nowPlaying,
    upcoming,
    popularTv,
    topTv,
  ];
  static const movies = [popularMovies, topMovies, nowPlaying, upcoming];
  static const tv = [popularTv, topTv];
}
