import 'package:ecommerce_app/core/router/app_router.dart';
import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ShellScreen extends ConsumerWidget {
  const ShellScreen({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final cartCount = ref.watch(cartItemCountProvider);

    int currentIndex = 0;
    if (location.startsWith('/cart')) currentIndex = 1;
    if (location.startsWith('/profile')) currentIndex = 2;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.surfaceVariant)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go(AppRoutes.home);
              case 1:
                context.go(AppRoutes.cart);
              case 2:
                context.go(AppRoutes.profile);
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                child: const Icon(Icons.shopping_cart_rounded),
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
