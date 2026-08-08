import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(int id);
  Future<List<ProductModel>> getProductsByCategory(String category);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  const ProductRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await _dio.get<List<dynamic>>('/products');
      final data = response.data;
      if (data == null) return [];
      return data
          .cast<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();
    } on DioException catch (e) {
      _rethrow(e);
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response =
          await _dio.get<Map<String, dynamic>>('/products/$id');
      final data = response.data;
      if (data == null) throw const NotFoundException();
      return ProductModel.fromJson(data);
    } on DioException catch (e) {
      _rethrow(e);
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response =
          await _dio.get<List<dynamic>>('/products/category/$category');
      final data = response.data;
      if (data == null) return [];
      return data
          .cast<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();
    } on DioException catch (e) {
      _rethrow(e);
    }
  }

  Never _rethrow(DioException e) {
    final inner = e.error;
    if (inner is NetworkException) throw inner;
    if (inner is UnauthorizedException) throw inner;
    if (inner is NotFoundException) throw inner;
    if (inner is ServerException) throw inner;
    throw ServerException(message: e.message ?? 'Product request failed');
  }
}
