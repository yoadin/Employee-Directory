import 'package:ecommerce_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ecommerce_app/features/categories/data/datasources/category_remote_datasource.dart';
import 'package:ecommerce_app/features/categories/data/repositories/category_repository_impl.dart';
import 'package:ecommerce_app/features/categories/domain/repositories/category_repository.dart';
import 'package:ecommerce_app/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// (data source & repository moved here to avoid circular imports)

final _categoryRemoteDataSourceProvider = Provider<CategoryRemoteDataSource>((ref) =>
    CategoryRemoteDataSourceImpl(ref.watch(authedDioProvider)));

final _categoryRepositoryProvider = Provider<CategoryRepository>((ref) =>
    CategoryRepositoryImpl(
      remoteDataSource: ref.watch(_categoryRemoteDataSourceProvider),
      networkInfo: ref.watch(networkInfoProvider),
    ));

final _getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) =>
    GetCategoriesUseCase(ref.watch(_categoryRepositoryProvider)));

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final useCase = ref.watch(_getCategoriesUseCaseProvider);
  final result = await useCase();
  return result.when(
    onSuccess: (cats) => cats,
    onFailure: (f) => throw f,
  );
});
