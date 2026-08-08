import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/error/exceptions.dart';

abstract class CategoryRemoteDataSource {
  Future<List<String>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  const CategoryRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get<List<dynamic>>('/products/categories');
      final data = response.data;
      if (data == null) return [];
      return data.cast<String>();
    } on DioException catch (e) {
      final inner = e.error;
      if (inner is NetworkException) throw inner;
      throw ServerException(message: e.message ?? 'Failed to load categories');
    }
  }
}
