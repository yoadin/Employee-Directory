import 'package:ecommerce_app/core/utils/result.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/repositories/product_repository.dart';

class GetAllProductsUseCase {
  const GetAllProductsUseCase(this._repository);
  final ProductRepository _repository;

  Future<Result<List<Product>>> call() => _repository.getAllProducts();
}

class GetProductByIdUseCase {
  const GetProductByIdUseCase(this._repository);
  final ProductRepository _repository;

  Future<Result<Product>> call(int id) => _repository.getProductById(id);
}

class GetProductsByCategoryUseCase {
  const GetProductsByCategoryUseCase(this._repository);
  final ProductRepository _repository;

  Future<Result<List<Product>>> call(String category) =>
      _repository.getProductsByCategory(category);
}
