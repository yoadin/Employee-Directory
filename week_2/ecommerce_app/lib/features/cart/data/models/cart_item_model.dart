import 'package:ecommerce_app/features/cart/domain/entities/cart_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 0)
class CartItemModel extends HiveObject {
  CartItemModel({
    required this.productId,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  @HiveField(0)
  final int productId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  int quantity;

  CartItem toEntity() => CartItem(
        productId: productId,
        title: title,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity,
      );

  static CartItemModel fromEntity(CartItem item) => CartItemModel(
        productId: item.productId,
        title: item.title,
        price: item.price,
        imageUrl: item.imageUrl,
        quantity: item.quantity,
      );
}
