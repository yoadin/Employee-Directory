import 'package:ecommerce_app/core/utils/result.dart';
import 'package:ecommerce_app/features/categories/domain/repositories/category_repository.dart';

class GetCategoriesUseCase {
  const GetCategoriesUseCase(this._repository);
  final CategoryRepository _repository;

  Future<Result<List<String>>> call() => _repository.getCategories();
}
