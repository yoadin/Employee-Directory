import 'package:ecommerce_app/core/utils/result.dart';

abstract class CategoryRepository {
  Future<Result<List<String>>> getCategories();
}
