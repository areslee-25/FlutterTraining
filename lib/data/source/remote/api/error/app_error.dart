import 'dart:async';
import 'dart:io';

import '../../../remote.dart';

class AppError {
  final int statusCode;
  final String message;
  final AppErrorType type;

  const AppError({
    required this.statusCode,
    required this.message,
    required this.type,
  });

  factory AppError.toError(dynamic body, int statusCode) {
    AppError appError;
    try {
      appError = ErrorResponse.fromJson(body).toSeverError();
    } catch (exception) {
      switch (statusCode) {
        case HttpStatus.unauthorized:
          appError = AppError.toUnauthorized();
          break;
        case HttpStatus.networkConnectTimeoutError:
        case HttpStatus.gatewayTimeout:
        case HttpStatus.requestTimeout:
          appError = AppError.network(statusCode);
          break;
        case HttpStatus.notFound:
          appError = AppError(
            statusCode: statusCode,
            message: 'HttpStatus NotFound',
            type: AppErrorType.network,
          );
          break;
        default:
          if (exception is TimeoutException || exception is IOException) {
            appError = AppError.network(statusCode, exception);
          } else {
            appError = AppError.toUnknown(statusCode, exception);
          }
          break;
      }
    }
    return appError;
  }

  factory AppError.network(int statusCode, [Object? exception]) => AppError(
        statusCode: statusCode,
        message: statusCode.getHttpErrorMessage(),
        type: AppErrorType.network,
      );

  factory AppError.toUnknown(int statusCode, Object exception) => AppError(
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
