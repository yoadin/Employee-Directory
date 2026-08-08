import 'package:ecommerce_app/core/utils/result.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Result<List<Product>>> getAllProducts();
  Future<Result<Product>> getProductById(int id);
  Future<Result<List<Product>>> getProductsByCategory(String category);
}
