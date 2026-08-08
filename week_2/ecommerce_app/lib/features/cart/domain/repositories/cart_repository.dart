import 'package:ecommerce_app/core/utils/result.dart';
import 'package:ecommerce_app/features/cart/domain/entities/cart_item.dart';

abstract class CartRepository {
  Future<Result<List<CartItem>>> getCartItems();
  Future<Result<void>> saveCartItems(List<CartItem> items);
  Future<Result<void>> clearCart();
}
