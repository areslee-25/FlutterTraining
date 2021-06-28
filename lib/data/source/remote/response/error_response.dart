import 'dart:io';

import 'package:untitled/data/source/remote/repository/base_repository.dart';

enum AppErrorType {
  network,
  unauthorized,
  server,
  unknown,
  response_null,
}

class ErrorResponse {
  final int statusCode;
  final String message;

  ErrorResponse({
    required this.statusCode,
    required this.message,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        statusCode: jsonDecode(json, "status_code"),
        message: jsonDecode(json, "status_message"),
      );

  AppError toSeverError() {
    return AppError(message: this.message, type: AppErrorType.server);
  }
}

class AppError {
  final String message;
  final AppErrorType type;

  AppError({
    required this.message,
    required this.type,
  });

  factory AppError.network() => AppError(
        message: "Network Exception",
        type: AppErrorType.network,
      );

  factory AppError.toUnknown([Object? exception]) => AppError(
        message: "Unknown Exception: $exception",
        type: AppErrorType.unknown,
      );

  factory AppError.toUnauthorized() => AppError(
        message: "Unauthorized 401",
        type: AppErrorType.unauthorized,
      );

  factory AppError.toResponseNull() => AppError(
        message: "Response Null",
        type: AppErrorType.response_null,
      );

  factory AppError.toError(dynamic body, int statusCode) {
    AppError appError;
    switch (statusCode) {
      case HttpStatus.unauthorized:
        appError = AppError.toUnauthorized();
        break;
      case HttpStatus.networkConnectTimeoutError:
      case HttpStatus.gatewayTimeout:
      case HttpStatus.requestTimeout:
        appError = AppError.network();
        break;
      default:
        try {
          appError = ErrorResponse.fromJson(body).toSeverError();
        } catch (exception) {
          appError = AppError.toUnknown(exception);
        }
        break;
    }
    return appError;
  }
}
