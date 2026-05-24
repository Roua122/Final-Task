// presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/app_provider.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final AnimationController _loaderController =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))
        ..repeat();

  late final AnimationController _fadeController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 600));

  @override
  void initState() {
    super.initState();
    // 🔥 تشغيل التحميل عند فتح الشاشة لأول مرة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AppProvider>();
      // استدعاء دالة الاستماع للمنتجات
      provider.listenToProducts();

      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _loaderController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // ================= SKELETON =================
  Widget _buildSkeletonCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  // ================= LOADER =================
  Widget _buildLoader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RotationTransition(
          turns: _loaderController,
          child: Container(
            width: 70,
            height: 70,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF1A531A).withOpacity(0.2),
                width: 3,
              ),
            ),
            child: const DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFF1A531A),
                    width: 3,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        const Text(
          "Loading products",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A531A),
          ),
        ),
      ],
    );
  }

  // ================= REFRESH =================
  Future<void> _refresh(AppProvider provider) async {
    provider.listenToProducts();
  }

  // ================= ANIMATED GRID =================
  Widget _buildAnimatedGrid(List products) {
    return FadeTransition(
      opacity: _fadeController,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(_fadeController),
        child: GridView.builder(
          padding: const EdgeInsets.all(20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (ctx, i) {
            return AnimatedOpacity(
              duration: Duration(milliseconds: 300 + (i * 80)),
              opacity: 1,
              child: ProductCard(product: products[i]),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final products = provider.products;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => _refresh(provider),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // ================= BANNER =================
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              "https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=1200",
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFF1A531A).withOpacity(0.8),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                              ),
                              padding: const EdgeInsets.all(35),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("BOTANICAL SERIES",
                                      style: TextStyle(
                                          color: Color(0xFFD4AF37),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12)),
                                  SizedBox(height: 10),
                                  Text("Pure Ingredients.\nProven Results.",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ================= PRODUCTS =================
                    provider.isLoading
                        ? GridView.builder(
                            padding: const EdgeInsets.all(20),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 6,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemBuilder: (ctx, i) => _buildSkeletonCard(),
                          )
                        : _buildAnimatedGrid(products),
                  ],
                ),
              ),
            ),

            // ================= LOADER OVERLAY =================
            if (provider.isLoading && provider.products.isEmpty)
              Container(
                color: Colors.white.withOpacity(0.9),
                child: Center(child: _buildLoader()),
              ),
          ],
        ),
      ),
    );
  }
}
