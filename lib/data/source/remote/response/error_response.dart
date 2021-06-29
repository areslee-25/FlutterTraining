import 'dart:io';

import 'package:untitled/data/source/remote/core/json_format.dart';

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
        statusCode: json.decode<int>('status_code'),
        message: json.decode('status_message'),
      );

  AppError toSeverError() {
    return AppError(
      statusCode: statusCode,
      message: this.message,
      type: AppErrorType.server,
    );
  }
}

class AppError {
  final int statusCode;
  final String message;
  final AppErrorType type;

  AppError({
    required this.statusCode,
    required this.message,
    required this.type,
  });

  factory AppError.network(int statusCode) => AppError(
        statusCode: statusCode,
        message: statusCode.getHttpErrorMessage(),
        type: AppErrorType.network,
      );

  factory AppError.toUnknown(int statusCode, [Object? exception]) => AppError(
        statusCode: statusCode,
        message: "Unknown Exception: $exception",
        type: AppErrorType.unknown,
      );

  factory AppError.toUnauthorized() => AppError(
        statusCode: HttpStatus.unauthorized,
        message: "Unauthorized 401",
        type: AppErrorType.unauthorized,
      );

  factory AppError.toResponseNull() => AppError(
        statusCode: 0,
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
        appError = AppError.network(statusCode);
        break;
      default:
        try {
          appError = ErrorResponse.fromJson(body).toSeverError();
        } catch (exception) {
          appError = AppError.toUnknown(statusCode, exception);
        }
        break;
    }
    return appError;
  }
}

extension HttpErrorMessage on int {
  String getHttpErrorMessage() {
    if (this >= 300 && this <= 308) {
      // Redirection
      return "It was transferred to a different URL. I'm sorry for causing you trouble";
    }
    if (this >= 400 && this <= 451) {
      // Client error
      return "An error occurred on the application side. Please try again later!";
    }
    if (this >= 500 && this <= 511) {
      // Server error
      return "A server error occurred. Please try again later!";
    }
    // Unofficial error
    return "An error occurred. Please try again later!";
  }
}
