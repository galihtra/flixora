import 'package:dio/dio.dart';
import 'package:flixora/data/model/models.dart';
import 'package:flixora/data/services/api_client.dart';
import 'package:flixora/data/repositories/media_repository.dart';
import 'package:flixora/resources/values_app.dart';

class TmdbRepository implements MediaRepository {
  TmdbRepository(this._api);
  final ApiClient _api;
  String _secureBase = AppValues.imageBaseUrl;
  String _posterSize = 'w500';
  String _backdropSize = 'w1280';

  Future<void> loadImageConfiguration() async {
    try {
      final response = await _api.get('/configuration');
      final images = response['images'];
      if (images is! Map) return;
      _secureBase = nonEmpty(images['secure_base_url']) ?? _secureBase;
      final posters = images['poster_sizes'];
      final backdrops = images['backdrop_sizes'];
      if (posters is List && posters.contains('w500')) _posterSize = 'w500';
      if (backdrops is List && backdrops.contains('w1280')) {
        _backdropSize = 'w1280';
      }
    } catch (_) {}
  }

  @override
  String? imageUrl(String? path, {bool backdrop = false}) {
    if (path == null || path.isEmpty) return null;
    return '$_secureBase${backdrop ? _backdropSize : _posterSize}$path';
  }

  @override
  Future<MediaPage> category(
    CatalogCategory category,
    int page, {
    CancelToken? cancelToken,
  }) async {
    final response = await _api.get(
      category.path,
      query: {'page': page},
      cancelToken: cancelToken,
    );
    return _page(
      response,
      page,
      (json) => MediaItem.fromJson(json, category.type),
    );
  }

  @override
  Future<MediaDetail> detail(
    MediaType type,
    int id, {
    CancelToken? cancelToken,
  }) async {
    final response = await _api.get(
      '/${type.name}/$id',
      cancelToken: cancelToken,
    );
    return MediaDetail.fromJson(response, type);
  }

  @override
  Future<MediaPage> search(
    String query,
    int page, {
    CancelToken? cancelToken,
  }) async {
    final response = await _api.get(
      '/search/multi',
      query: {'query': query, 'page': page, 'include_adult': false},
      cancelToken: cancelToken,
    );
    return _page(response, page, (json) {
      final type = json['media_type'];
      if (type != 'movie' && type != 'tv') return null;
      return MediaItem.fromJson(
        json,
        type == 'movie' ? MediaType.movie : MediaType.tv,
      );
    });
  }

  MediaPage _page(
    Map<String, dynamic> response,
    int fallbackPage,
    MediaItem? Function(Map<String, dynamic>) parse,
  ) {
    final results = response['results'];
    if (results is! List) throw const FormatException('Missing results');
    final items = <MediaItem>[];
    for (final raw in results) {
      if (raw is! Map) continue;
      final item = parse(Map<String, dynamic>.from(raw));
      if (item != null && item.id > 0) items.add(item);
    }
    return MediaPage(
      items,
      asInt(response['page']) == 0 ? fallbackPage : asInt(response['page']),
      asInt(response['total_pages']),
    );
  }
}
