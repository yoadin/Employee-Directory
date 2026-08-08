/// Domain entity representing a product rating.
class Rating {
  const Rating({required this.rate, required this.count});
  final double rate;
  final int count;
}

/// Domain entity representing a single product.
/// Pure Dart — no Flutter or external package imports.
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
  });

  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final Rating rating;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Product(id: $id, title: $title)';
}
