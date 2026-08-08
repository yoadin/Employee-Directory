import 'package:ecommerce_app/features/auth/domain/entities/auth_token.dart';
import 'package:ecommerce_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:ecommerce_app/features/auth/presentation/screens/login_screen.dart';
import 'package:ecommerce_app/features/cart/presentation/screens/cart_screen.dart';
import 'package:ecommerce_app/features/products/presentation/screens/product_detail_screen.dart';
import 'package:ecommerce_app/features/products/presentation/screens/product_list_screen.dart';
import 'package:ecommerce_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:ecommerce_app/features/shell/presentation/screens/shell_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Route name constants
class AppRoutes {
  AppRoutes._();
  static const String login = '/login';
  static const String home = '/';
  static const String productDetail = '/product/:id';
  static const String cart = '/cart';
  static const String profile = '/profile';
}

final routerProvider = Provider<GoRouter>((ref) {
  // We use a ValueNotifier so GoRouter can react to auth state changes.
  final authState = _AuthStateNotifier(ref);
  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: authState,
    redirect: (BuildContext context, GoRouterState state) {
      final authValue = ref.read(authNotifierProvider);
      final isLoggedIn =
          authValue is AsyncData<AuthToken?> && authValue.value != null;
      final isAuthLoading = authValue is AsyncLoading;
      final isOnLogin = state.matchedLocation == AppRoutes.login;

      if (isAuthLoading) return null; // don't redirect while loading
      if (!isLoggedIn && !isOnLogin) return AppRoutes.login;
      if (isLoggedIn && isOnLogin) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const ProductListScreen(),
          ),
          GoRoute(
            path: AppRoutes.cart,
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.productDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProductDetailScreen(productId: id);
        },
      ),
    ],
  );
});

/// Bridges Riverpod auth state changes into ChangeNotifier for GoRouter.
class _AuthStateNotifier extends ChangeNotifier {
  _AuthStateNotifier(Ref ref) {
    ref.listen(authNotifierProvider, (_, _) => notifyListeners());
  }
}
