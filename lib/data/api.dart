import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import '../core/models.dart';

enum AppErrorType {
  noConnection,
  timeout,
  unauthorized,
  rateLimited,
  serverError,
  invalidResponse,
  unknown,
}

class AppException implements Exception {
  const AppException(this.type, this.message);
  final AppErrorType type;
  final String message;
  @override
  String toString() => message;
}

abstract final class ApiErrorMapper {
  static AppException map(Object error) {
    if (error is AppException) return error;
    if (error is FormatException || error is TypeError) {
      return const AppException(
        AppErrorType.invalidResponse,
        'The service returned incomplete data. Please try again.',
      );
    }
    if (error is DioException) {
      final status = error.response?.statusCode;
      if (status == 401 || status == 403) {
        return const AppException(
          AppErrorType.unauthorized,
          'The movie service is unavailable right now.',
        );
      }
      if (status == 429) {
        return const AppException(
          AppErrorType.rateLimited,
          'Too many requests. Please try again shortly.',
        );
      }
      if (status != null && status >= 500) {
        return const AppException(
          AppErrorType.serverError,
          'The movie service is having trouble. Please try again.',
        );
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return const AppException(
          AppErrorType.timeout,
          'The connection is taking too long. Please try again.',
        );
      }
      if (error.type == DioExceptionType.connectionError ||
          error.error is SocketException) {
        return const AppException(
          AppErrorType.noConnection,
          'Check your internet connection and try again.',
        );
      }
    }
    return const AppException(
      AppErrorType.unknown,
      'Something went wrong. Please try again.',
    );
  }
}

class ApiClient {
  ApiClient({required String token, Dio? dio})
    : _token = token,
      _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 10),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      queryParameters: {'language': 'en-US'},
    );
  }

  final Dio _dio;
  final String _token;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) async {
    if (_token.isEmpty) {
      throw const AppException(
        AppErrorType.unauthorized,
        'Add a TMDB token to load the catalog.',
      );
    }
    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        final response = await _dio.get<dynamic>(
          path,
          queryParameters: query,
          cancelToken: cancelToken,
        );
        if (response.data is! Map) {
          throw const FormatException('Expected a JSON object');
        }
        return Map<String, dynamic>.from(response.data as Map);
      } on DioException catch (error) {
        if (CancelToken.isCancel(error)) rethrow;
        final status = error.response?.statusCode;
        final retryable =
            error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.type == DioExceptionType.connectionError ||
            status == 429 ||
            (status != null && status >= 500 && status <= 504);
        if (!retryable || attempt == 2) throw ApiErrorMapper.map(error);
        final delay = status == 429
            ? _retryAfter(error.response?.headers)
            : Duration(seconds: attempt + 1);
        await Future<void>.delayed(delay);
        if (cancelToken?.isCancelled ?? false) {
          throw DioException(
            requestOptions: error.requestOptions,
            type: DioExceptionType.cancel,
          );
        }
      } catch (error) {
        throw ApiErrorMapper.map(error);
      }
    }
    throw const AppException(AppErrorType.unknown, 'Something went wrong.');
  }

  Duration _retryAfter(Headers? headers) {
    final raw = headers?.value('retry-after');
    final seconds = int.tryParse(raw ?? '');
    if (seconds != null) return Duration(seconds: seconds.clamp(1, 30));
    try {
      final date = HttpDate.parse(raw ?? '');
      final delay = date.difference(DateTime.now().toUtc());
      return delay > Duration.zero ? delay : const Duration(seconds: 2);
    } on FormatException {
      return const Duration(seconds: 2);
    }
  }
}

abstract class MediaRepository {
  Future<MediaPage> category(
    CatalogCategory category,
    int page, {
    CancelToken? cancelToken,
  });
  Future<MediaDetail> detail(
    MediaType type,
    int id, {
    CancelToken? cancelToken,
  });
  Future<MediaPage> search(String query, int page, {CancelToken? cancelToken});
  String? imageUrl(String? path, {bool backdrop = false});
}

class TmdbRepository implements MediaRepository {
  TmdbRepository(this._api);
  final ApiClient _api;
  String _secureBase = 'https://image.tmdb.org/t/p/';
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
    } catch (_) {
      // The known TMDB image URL remains available if configuration cannot load.
    }
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
