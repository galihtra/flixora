import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flixora/resources/strings_app.dart';

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
        AppStrings.invalidResponse,
      );
    }
    if (error is DioException) {
      final status = error.response?.statusCode;
      if (status == 401 || status == 403) {
        return const AppException(
          AppErrorType.unauthorized,
          AppStrings.serviceUnavailable,
        );
      }
      if (status == 429) {
        return const AppException(
          AppErrorType.rateLimited,
          AppStrings.rateLimited,
        );
      }
      if (status != null && status >= 500) {
        return const AppException(
          AppErrorType.serverError,
          AppStrings.serverError,
        );
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return const AppException(AppErrorType.timeout, AppStrings.timeout);
      }
      if (error.type == DioExceptionType.connectionError ||
          error.error is SocketException) {
        return const AppException(
          AppErrorType.noConnection,
          AppStrings.noConnection,
        );
      }
    }
    return const AppException(AppErrorType.unknown, AppStrings.unknownError);
  }
}
