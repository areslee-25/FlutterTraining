import '../remote.dart';

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
