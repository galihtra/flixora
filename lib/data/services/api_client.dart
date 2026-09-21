import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flixora/data/services/api_error_mapper.dart';
import 'package:flixora/resources/strings_app.dart';
import 'package:flixora/resources/values_app.dart';

class ApiClient {
  ApiClient({required String token, Dio? dio})
    : _token = token,
      _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: AppValues.apiBaseUrl,
      connectTimeout: AppValues.connectTimeout,
      receiveTimeout: AppValues.receiveTimeout,
      sendTimeout: AppValues.sendTimeout,
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
        AppStrings.tokenMissing,
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
    throw const AppException(AppErrorType.unknown, AppStrings.unknownShort);
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
