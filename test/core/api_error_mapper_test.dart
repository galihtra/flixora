import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flixora/data/api.dart';

void main() {
  final request = RequestOptions(path: '/movie/popular');

  test('maps offline and timeout to distinct user states', () {
    final offline = ApiErrorMapper.map(
      DioException(
        requestOptions: request,
        type: DioExceptionType.connectionError,
      ),
    );
    final timeout = ApiErrorMapper.map(
      DioException(
        requestOptions: request,
        type: DioExceptionType.receiveTimeout,
      ),
    );
    expect(offline.type, AppErrorType.noConnection);
    expect(timeout.type, AppErrorType.timeout);
  });

  test('maps unauthorized and server responses correctly', () {
    final unauthorized = ApiErrorMapper.map(
      DioException(
        requestOptions: request,
        response: Response(requestOptions: request, statusCode: 401),
      ),
    );
    final server = ApiErrorMapper.map(
      DioException(
        requestOptions: request,
        response: Response(requestOptions: request, statusCode: 503),
      ),
    );
    expect(unauthorized.type, AppErrorType.unauthorized);
    expect(server.type, AppErrorType.serverError);
    expect(unauthorized.message, isNot(contains('token')));
  });
}
