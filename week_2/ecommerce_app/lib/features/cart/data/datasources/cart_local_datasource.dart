import 'package:ecommerce_app/core/constants/app_constants.dart';
import 'package:ecommerce_app/core/error/exceptions.dart';
import 'package:ecommerce_app/features/cart/data/models/cart_item_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> saveCartItems(List<CartItemModel> items);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  CartLocalDataSourceImpl() : _box = Hive.box<CartItemModel>(AppConstants.cartBox);
  final Box<CartItemModel> _box;

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      return _box.values.toList();
    } catch (_) {
      throw const CacheException(message: 'Failed to read cart');
    }
  }

  @override
  Future<void> saveCartItems(List<CartItemModel> items) async {
    try {
      await _box.clear();
      final map = {
        for (final item in items) item.productId.toString(): item,
      };
      await _box.putAll(map);
    } catch (_) {
      throw const CacheException(message: 'Failed to save cart');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await _box.clear();
    } catch (_) {
      throw const CacheException(message: 'Failed to clear cart');
    }
  }
}
