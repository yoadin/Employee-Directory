import 'package:ecommerce_app/core/error/error_mapper.dart';
import 'package:ecommerce_app/core/utils/result.dart';
import 'package:ecommerce_app/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:ecommerce_app/features/cart/data/models/cart_item_model.dart';
import 'package:ecommerce_app/features/cart/domain/entities/cart_item.dart';
import 'package:ecommerce_app/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl(this._local);
  final CartLocalDataSource _local;

  @override
  Future<Result<List<CartItem>>> getCartItems() async {
    try {
      final models = await _local.getCartItems();
      return ok(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return mapExceptionToFailure(e);
    }
  }

  @override
  Future<Result<void>> saveCartItems(List<CartItem> items) async {
    try {
      final models = items.map(CartItemModel.fromEntity).toList();
      await _local.saveCartItems(models);
      return ok(null);
    } catch (e) {
      return mapExceptionToFailure(e);
    }
  }

  @override
  Future<Result<void>> clearCart() async {
    try {
      await _local.clearCart();
      return ok(null);
    } catch (e) {
      return mapExceptionToFailure(e);
    }
  }
}
