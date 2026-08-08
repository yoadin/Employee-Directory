import 'package:ecommerce_app/core/error/error_mapper.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/core/utils/result.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_local_datasource.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_remote_datasource.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl({
    required ProductRemoteDataSource remoteDataSource,
    required ProductLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remote = remoteDataSource,
       _local = localDataSource,
       _networkInfo = networkInfo;

  final ProductRemoteDataSource _remote;
  final ProductLocalDataSource _local;
  final NetworkInfo _networkInfo;

  @override
  Future<Result<List<Product>>> getAllProducts() async {
    if (!await _networkInfo.isConnected) {
      // Serve from cache when offline
      if (_local.hasCachedProducts()) {
        try {
          final cached = await _local.getCachedProducts();
          return ok(cached.map((m) => m.toEntity()).toList());
        } catch (e) {
          return mapExceptionToFailure(e);
        }
      }
      return err(const NetworkFailure());
    }
    try {
      final models = await _remote.getAllProducts();
      await _local.cacheProducts(models); // best-effort cache
      return ok(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      // Network failed mid-session? Fall back to cache if available
      if (_local.hasCachedProducts()) {
        try {
          final cached = await _local.getCachedProducts();
          return ok(cached.map((m) => m.toEntity()).toList());
        } catch (_) {}
      }
      return mapExceptionToFailure(e);
    }
  }

  @override
  Future<Result<Product>> getProductById(int id) async {
    if (!await _networkInfo.isConnected) {
      return err(const NetworkFailure());
    }
    try {
      final model = await _remote.getProductById(id);
      return ok(model.toEntity());
    } catch (e) {
      return mapExceptionToFailure(e);
    }
  }

  @override
  Future<Result<List<Product>>> getProductsByCategory(String category) async {
    if (!await _networkInfo.isConnected) {
      // Filter cached products by category
      if (_local.hasCachedProducts()) {
        try {
          final cached = await _local.getCachedProducts();
          final filtered = cached
              .where((m) => m.category == category)
              .map((m) => m.toEntity())
              .toList();
          return ok(filtered);
        } catch (e) {
          return mapExceptionToFailure(e);
        }
      }
      return err(const NetworkFailure());
    }
    try {
      final models = await _remote.getProductsByCategory(category);
      return ok(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return mapExceptionToFailure(e);
    }
  }
}
