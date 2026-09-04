import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_exceptions.dart';
import '../../core/storage/token_storage.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<void> register(String email, String password) async {
    try {
      await _apiClient.dio.post(
        '/register',
        data: {
          'email': email.trim(),
          'password': password,
        },
      );
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException('Đã xảy ra lỗi không xác định: $e');
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        '/login',
        data: {
          'email': email.trim(),
          'password': password,
        },
      );

      final data = response.data;
      final String? token = data['token'];

      if (token != null && token.isNotEmpty) {

        await TokenStorage.saveToken(token);
      } else {
        throw ApiException('Không nhận được token xác thực từ máy chủ.');
      }

      return UserModel.fromJson(data['user'] ?? {});
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException('Đã xảy ra lỗi đăng nhập: $e');
    }
  }

  Future<UserModel> getMe() async {
    try {
      final response = await _apiClient.dio.get('/me');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await TokenStorage.clearToken();
      }
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException('Không thể kiểm tra phiên đăng nhập: $e');
    }
  }

  Future<void> logout() async {
    try {
      // Gọi API báo server thu hồi token
      await _apiClient.dio.post('/logout');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } finally {
      await TokenStorage.clearToken();
    }
  }

  Future<bool> isAuthenticated() async {
    return await TokenStorage.hasToken();
  }
}