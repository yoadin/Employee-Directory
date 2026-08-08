import 'package:ecommerce_app/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:ecommerce_app/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:ecommerce_app/features/cart/domain/entities/cart_item.dart';
import 'package:ecommerce_app/features/cart/domain/repositories/cart_repository.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Cart data source & repository ───────────────────────────────────────────

final cartLocalDataSourceProvider = Provider<CartLocalDataSource>(
  (ref) => CartLocalDataSourceImpl(),
);

final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => CartRepositoryImpl(ref.watch(cartLocalDataSourceProvider)),
);

// ─── Cart state ───────────────────────────────────────────────────────────────

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier(this._repository) : super([]) {
    _loadFromStorage();
  }

  final CartRepository _repository;
  bool _isLoading = false;

  Future<void> _loadFromStorage() async {
    final result = await _repository.getCartItems();
    result.when(
      onSuccess: (items) => state = items,
      onFailure: (_) {}, // silently fall back to empty cart
    );
  }

  Future<void> _persist() async {
    if (_isLoading) return;
    await _repository.saveCartItems(state);
  }

  /// Adds product to cart or increments qty if already present.
  /// Uses a mutex-style guard (_isLoading) to prevent double-add race conditions.
  Future<void> addItem(Product product) async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      final existing = state.indexWhere((i) => i.productId == product.id);
      if (existing >= 0) {
        final updated = List<CartItem>.from(state);
        updated[existing] = updated[existing].copyWith(
          quantity: updated[existing].quantity + 1,
        );
        state = updated;
      } else {
        state = [
          ...state,
          CartItem(
            productId: product.id,
            title: product.title,
            price: product.price,
            imageUrl: product.imageUrl,
            quantity: 1,
          ),
        ];
      }
      await _persist();
    } finally {
      _isLoading = false;
    }
  }

  Future<void> removeItem(int productId) async {
    state = state.where((i) => i.productId != productId).toList();
    await _persist();
  }

  /// Decrements quantity. Removes item when quantity reaches 0 (auto-remove).
  Future<void> decrementItem(int productId) async {
    final index = state.indexWhere((i) => i.productId == productId);
    if (index < 0) return;

    if (state[index].quantity <= 1) {
      await removeItem(productId);
    } else {
      final updated = List<CartItem>.from(state);
      updated[index] = updated[index].copyWith(
        quantity: updated[index].quantity - 1,
      );
      state = updated;
      await _persist();
    }
  }

  Future<void> incrementItem(int productId) async {
    final index = state.indexWhere((i) => i.productId == productId);
    if (index < 0) return;
    final updated = List<CartItem>.from(state);
    updated[index] = updated[index].copyWith(
      quantity: updated[index].quantity + 1,
    );
    state = updated;
    await _persist();
  }

  Future<void> clearCart() async {
    state = [];
    await _repository.clearCart();
  }

  double get total => state.fold(0, (sum, item) => sum + item.subtotal);
  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);
  bool containsProduct(int productId) =>
      state.any((i) => i.productId == productId);
}

final cartNotifierProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
      return CartNotifier(ref.watch(cartRepositoryProvider));
    });

// Derived providers for convenience
final cartTotalProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartNotifierProvider);
  return cartItems.fold(0, (sum, item) => sum + item.subtotal);
});

final cartItemCountProvider = Provider<int>((ref) {
  final cartItems = ref.watch(cartNotifierProvider);
  return cartItems.fold(0, (sum, item) => sum + item.quantity);
});
