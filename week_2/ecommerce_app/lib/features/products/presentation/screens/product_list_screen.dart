import 'package:ecommerce_app/core/constants/app_constants.dart';
import 'package:ecommerce_app/core/error/failures.dart';
import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/features/categories/presentation/providers/categories_provider.dart';
import 'package:ecommerce_app/features/products/presentation/providers/products_provider.dart';
import 'package:ecommerce_app/features/products/presentation/widgets/product_card.dart';
import 'package:ecommerce_app/features/products/presentation/widgets/product_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Debounce handled by setting the provider state.
    // A more thorough debounce would use a Timer — kept simple here.
    ref.read(searchQueryProvider.notifier).state = value;
  }

  void _onCategorySelected(String? category) {
    ref.read(selectedCategoryProvider.notifier).state = category;
    ref
        .read(productsNotifierProvider.notifier)
        .loadProducts(category: category);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth >= AppConstants.tabletBreakpoint
        ? AppConstants.tabletGridColumns
        : AppConstants.phoneGridColumns;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopSphere'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () {
                final cat = ref.read(selectedCategoryProvider);
                ref
                    .read(productsNotifierProvider.notifier)
                    .refresh(category: cat);
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          final cat = ref.read(selectedCategoryProvider);
          await ref
              .read(productsNotifierProvider.notifier)
              .refresh(category: cat);
        },
        child: CustomScrollView(
          slivers: [
            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ),

            // Category chips
            SliverToBoxAdapter(
              child: _CategoryChipsRow(onSelected: _onCategorySelected),
            ),

            // Products grid
            _ProductGrid(crossAxisCount: crossAxisCount),
          ],
        ),
      ),
    );
  }
}

// ─── Category Chips ───────────────────────────────────────────────────────────

class _CategoryChipsRow extends ConsumerWidget {
  const _CategoryChipsRow({required this.onSelected});
  final void Function(String?) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selected = ref.watch(selectedCategoryProvider);

    return categoriesAsync.when(
      data: (categories) => SizedBox(
        height: 52,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            _CategoryChip(
              label: 'All',
              selected: selected == null,
              onSelected: () => onSelected(null),
            ),
            ...categories.map(
              (cat) => _CategoryChip(
                label: cat,
                selected: selected == cat,
                onSelected: () => onSelected(cat),
              ),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox(height: 52),
      error: (_, _) => const SizedBox(height: 52),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
        showCheckmark: false,
      ),
    );
  }
}

// ─── Products Grid ────────────────────────────────────────────────────────────

class _ProductGrid extends ConsumerWidget {
  const _ProductGrid({required this.crossAxisCount});
  final int crossAxisCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(filteredProductsProvider);

    return productsAsync.when(
      loading: () => SliverFillRemaining(
        child: ProductSkeletonGrid(crossAxisCount: crossAxisCount),
      ),
      error: (error, _) => SliverFillRemaining(
        child: _ErrorState(
          message: error is Failure ? error.message : error.toString(),
          onRetry: () =>
              ref.read(productsNotifierProvider.notifier).loadProducts(),
        ),
      ),
      data: (products) {
        if (products.isEmpty) {
          return const SliverFillRemaining(child: _EmptyState());
        }
        return SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final product = products[index];
              return ProductCard(
                key: ValueKey(product.id),
                product: product,
                onTap: () =>
                    context.push('/product/${product.id}', extra: product),
              );
            }, childCount: products.length),
          ),
        );
      },
    );
  }
}

// ─── State widgets ────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: AppColors.error.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(160, 48)),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: AppColors.textHint),
          SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try a different search or category',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
