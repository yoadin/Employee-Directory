import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'product_model.g.dart';

/// Data transfer object for a product from the Fake Store API.
/// Also doubles as a Hive-persistable cached product.
@HiveType(typeId: 1)
class ProductModel extends HiveObject {
  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.ratingRate,
    required this.ratingCount,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String image;

  @HiveField(6)
  final double ratingRate;

  @HiveField(7)
  final int ratingCount;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final ratingMap = json['rating'] as Map<String, dynamic>;
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      ratingRate: (ratingMap['rate'] as num).toDouble(),
      ratingCount: ratingMap['count'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'image': image,
        'rating': {'rate': ratingRate, 'count': ratingCount},
      };

  Product toEntity() => Product(
        id: id,
        title: title,
        price: price,
        description: description,
        category: category,
        imageUrl: image,
        rating: Rating(rate: ratingRate, count: ratingCount),
      );

  static ProductModel fromEntity(Product p) => ProductModel(
        id: p.id,
        title: p.title,
        price: p.price,
        description: p.description,
        category: p.category,
        image: p.imageUrl,
        ratingRate: p.rating.rate,
        ratingCount: p.rating.count,
      );
}
