import 'package:dio/dio.dart';
import '../domain/product_model.dart';
import '../../../core/network/dio_client.dart';

class ProductService {
  Future<List<Product>> getProducts() async {
    try {
      final response = await DioClient.instance.get('/products');
      final List data = response.data;
      return data
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Gagal mengambil data: ${e.message}');
    } catch (e) {
      throw Exception('Gagal mengambil data');
    }
  }
}
