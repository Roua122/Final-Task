// presentation/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/providers/app_provider.dart';
import '../../data/providers/theme_provider.dart';
import '../../core/theme/app_theme.dart';

import 'home_screen.dart';
import 'category_screen.dart';
import 'favorites_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  // 🔥 مهم جداً لمنع الرجوع للهوم عند تغيير الثيم
  static int _currentIndex = 0;

  late AnimationController _heartController;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0.9,
      upperBound: 1.2,
    );

    _heartController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _heartController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    CategoryScreen(),
    FavoritesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    final primaryColor = AppTheme.lightTheme.primaryColor;

    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final cartCount = provider.cartCount;

        final hasFav = provider.favoriteProducts.isNotEmpty;

        return Container(
          decoration: isDark
              ? AppTheme.darkBackgroundGradient
              : AppTheme.lightBackgroundGradient,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
            bottomNavigationBar: NavigationBar(
              backgroundColor: isDark
                  ? Colors.black.withOpacity(0.5)
                  : Colors.white.withOpacity(0.7),
              indicatorColor: primaryColor.withOpacity(0.15),
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              destinations: [
                // 🏠 الرئيسية
                const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),

                // 📂 التصنيفات
                const NavigationDestination(
                  icon: Icon(Icons.category_outlined),
                  selectedIcon: Icon(Icons.category_rounded),
                  label: 'Explore',
                ),

                // ❤️ المفضلة
                NavigationDestination(
                  icon: AnimatedBuilder(
                    animation: _heartController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _heartController.value,
                        child: Icon(
                          hasFav ? Icons.favorite : Icons.favorite_border,
                          color: hasFav
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).iconTheme.color,
                        ),
                      );
                    },
                  ),
                  label: 'Wishlist',
                ),

                // 🛍️ السلة
                NavigationDestination(
                  icon: Badge(
                    label: Text('$cartCount'),
                    isLabelVisible: cartCount > 0,
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                    ),
                  ),
                  selectedIcon: Badge(
                    label: Text('$cartCount'),
                    isLabelVisible: cartCount > 0,
                    child: const Icon(
                      Icons.shopping_bag_rounded,
                    ),
                  ),
                  label: 'Cart',
                ),

                // 👤 البروفايل
                const NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
