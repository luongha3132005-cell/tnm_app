import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  factory ApiException.fromDioError(DioException error) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      return ApiException('Không thể kết nối đến máy chủ. Vui lòng kiểm tra lại mạng.');
    }

    final response = error.response;
    if (response != null) {
      final statusCode = response.statusCode;
      String? serverMessage;
      if (response.data is Map && response.data['message'] != null) {
        serverMessage = response.data['message'].toString();
      }

      switch (statusCode) {
        case 400:
          return ApiException(serverMessage ?? 'Dữ liệu không hợp lệ.', statusCode: 400);
        case 401:
          return ApiException(serverMessage ?? 'Tài khoản hoặc mật khẩu không chính xác.', statusCode: 401);
        case 409:
          return ApiException(serverMessage ?? 'Email này đã tồn tại trong hệ thống.', statusCode: 409);
        case 500:
          return ApiException('Lỗi máy chủ nội bộ. Vui lòng thử lại sau.', statusCode: 500);
        default:
          return ApiException(serverMessage ?? 'Đã xảy ra lỗi không xác định ($statusCode).', statusCode: statusCode);
      }
    }

    return ApiException('Đã xảy ra sự cố mạng. Vui lòng thử lại.');
  }

  @override
  String toString() => message;
}