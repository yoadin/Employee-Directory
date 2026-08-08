/// Domain entity representing a single item in the cart.
/// Pure Dart.
class CartItem {
  const CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  final int productId;
  final String title;
  final double price;
  final String imageUrl;
  final int quantity;

  double get subtotal => price * quantity;

  CartItem copyWith({int? quantity}) => CartItem(
        productId: productId,
        title: title,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity ?? this.quantity,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem && runtimeType == other.runtimeType && productId == other.productId;

  @override
  int get hashCode => productId.hashCode;
}
