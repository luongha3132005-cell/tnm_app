import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exceptions.dart';
import '../../../core/storage/token_storage.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ApiClient _client = ApiClient();

  Future<List<ProductModel>> getProducts({
    String? status,
    CancelToken? cancelToken,
  }) async {
    try {
      // 1. Lấy token đã lưu từ TokenStorage
      final token = await TokenStorage.getToken();

      // 2. Thiết lập query parameters (chỉ gửi khi status khác null)
      final Map<String, dynamic> queryParams = {};
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      // 3. Thực hiện gọi GET /products kèm token trong Authorization header
      final response = await _client.dio.get(
        '/products',
        queryParameters: queryParams,
        cancelToken: cancelToken,
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );

      final rawData = response.data;
      List listJson = [];

      // 4. Bóc tách dữ liệu từ API (Server trả về dạng {items: [...]})
      if (rawData is Map<String, dynamic>) {
        if (rawData['items'] is List) {
          listJson = rawData['items'];
        } else if (rawData['data'] is List) {
          listJson = rawData['data'];
        }
      } else if (rawData is List) {
        listJson = rawData;
      }

      // 5. Chuyển đổi JSON thành danh sách Model
      return listJson
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      // Bỏ qua nếu request bị huỷ chủ động do đổi Filter
      if (CancelToken.isCancel(e)) {
        rethrow;
      }
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException('Không thể xử lý dữ liệu sản phẩm: $e');
    }
  }
}