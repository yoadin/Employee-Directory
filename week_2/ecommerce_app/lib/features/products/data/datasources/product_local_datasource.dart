import 'package:ecommerce_app/core/constants/app_constants.dart';
import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/features/products/data/models/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>> getCachedProducts();
  bool hasCachedProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  ProductLocalDataSourceImpl() : _box = Hive.box<ProductModel>(AppConstants.productsBox);
  final Box<ProductModel> _box;

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      await _box.clear();
      final map = {for (final p in products) p.id.toString(): p};
      await _box.putAll(map);
    } catch (_) {
      throw const CacheException(message: 'Failed to cache products');
    }
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    try {
      return _box.values.toList();
    } catch (_) {
      throw const CacheException(message: 'Failed to read cached products');
    }
  }

  @override
  bool hasCachedProducts() => _box.isNotEmpty;
}
