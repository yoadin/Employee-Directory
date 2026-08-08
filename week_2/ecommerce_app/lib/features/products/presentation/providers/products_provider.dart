import 'package:ecommerce_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ecommerce_app/features/categories/data/datasources/category_remote_datasource.dart';
import 'package:ecommerce_app/features/categories/data/repositories/category_repository_impl.dart';
import 'package:ecommerce_app/features/categories/domain/repositories/category_repository.dart';
import 'package:ecommerce_app/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_local_datasource.dart';
import 'package:ecommerce_app/features/products/data/datasources/product_remote_datasource.dart';
import 'package:ecommerce_app/features/products/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:ecommerce_app/features/products/domain/repositories/product_repository.dart';
import 'package:ecommerce_app/features/products/domain/usecases/product_usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Products data sources & repository ──────────────────────────────────────

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>(
  (ref) => ProductRemoteDataSourceImpl(ref.watch(authedDioProvider)),
);

final productLocalDataSourceProvider = Provider<ProductLocalDataSource>(
  (ref) => ProductLocalDataSourceImpl(),
);

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(
    remoteDataSource: ref.watch(productRemoteDataSourceProvider),
    localDataSource: ref.watch(productLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  ),
);

// ─── Product use cases ────────────────────────────────────────────────────────

final getAllProductsUseCaseProvider = Provider<GetAllProductsUseCase>(
  (ref) => GetAllProductsUseCase(ref.watch(productRepositoryProvider)),
);

final getProductByIdUseCaseProvider = Provider<GetProductByIdUseCase>(
  (ref) => GetProductByIdUseCase(ref.watch(productRepositoryProvider)),
);

final getProductsByCategoryUseCaseProvider =
    Provider<GetProductsByCategoryUseCase>(
      (ref) =>
          GetProductsByCategoryUseCase(ref.watch(productRepositoryProvider)),
    );

// ─── Categories ───────────────────────────────────────────────────────────────

final categoryRemoteDataSourceProvider = Provider<CategoryRemoteDataSource>(
  (ref) => CategoryRemoteDataSourceImpl(ref.watch(authedDioProvider)),
);

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepositoryImpl(
    remoteDataSource: ref.watch(categoryRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  ),
);

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>(
  (ref) => GetCategoriesUseCase(ref.watch(categoryRepositoryProvider)),
);

// ─── Selected category state ──────────────────────────────────────────────────

/// null means "All" (no category filter)
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// ─── Search query state ───────────────────────────────────────────────────────

final searchQueryProvider = StateProvider<String>((ref) => '');

// ─── Products AsyncNotifier ───────────────────────────────────────────────────

class ProductsNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  ProductsNotifier({
    required GetAllProductsUseCase getAllProducts,
    required GetProductsByCategoryUseCase getByCategory,
  }) : _getAllProducts = getAllProducts,
       _getByCategory = getByCategory,
       super(const AsyncValue.loading()) {
    loadProducts();
  }

  final GetAllProductsUseCase _getAllProducts;
  final GetProductsByCategoryUseCase _getByCategory;

  Future<void> loadProducts({String? category}) async {
    state = const AsyncValue.loading();
    final result = category == null
        ? await _getAllProducts()
        : await _getByCategory(category);

    result.when(
      onSuccess: (products) => state = AsyncValue.data(products),
      onFailure: (failure) =>
          state = AsyncValue.error(failure, StackTrace.current),
    );
  }

  Future<void> refresh({String? category}) => loadProducts(category: category);
}

final productsNotifierProvider =
    StateNotifierProvider<ProductsNotifier, AsyncValue<List<Product>>>((ref) {
      return ProductsNotifier(
        getAllProducts: ref.watch(getAllProductsUseCaseProvider),
        getByCategory: ref.watch(getProductsByCategoryUseCaseProvider),
      );
    });

// ─── Filtered products (search applied) ──────────────────────────────────────

final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final allAsync = ref.watch(productsNotifierProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();

  return allAsync.when(
    data: (products) {
      if (query.isEmpty) return AsyncValue.data(products);
      final filtered = products
          .where((p) => p.title.toLowerCase().contains(query))
          .toList();
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
  );
});

// ─── Single product ───────────────────────────────────────────────────────────

final productByIdProvider = FutureProvider.family<Product, int>((
  ref,
  id,
) async {
  final useCase = ref.watch(getProductByIdUseCaseProvider);
  final result = await useCase(id);
  return result.when(onSuccess: (p) => p, onFailure: (f) => throw f);
});
