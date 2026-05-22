// presentation/screens/category_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/app_provider.dart';
import 'category_products_page.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  // قائمة الأقسام الثابتة بأيقوناتك وألوانك الأصلية
  final List<Map<String, dynamic>> categories = const [
    {
      'title': 'Cleansers',
      'icon': Icons.water_drop_rounded,
      'color': Color(0xFFBBDEFB), // أزرق فاتح
    },
    {
      'title': 'Serums',
      'icon': Icons.science_rounded,
      'color': Color(0xFFE1BEE7), // بنفسجي فاتح
    },
    {
      'title': 'Moisturizers',
      'icon': Icons.spa_rounded,
      'color': Color(0xFFC8E6C9), // أخضر فاتح
    },
    {
      'title': 'Masks',
      'icon': Icons.face_retouching_natural_rounded,
      'color': Color(0xFFFFE0B2), // برتقالي فاتح
    },
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Collections",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.products.isEmpty
              ? const Center(child: Text('loading...'))
              : GridView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (ctx, i) {
                    final cat = categories[i];
                    return InkWell(
                      onTap: () {
                        // عند الضغط على القسم، نمرر عنوان القسم (Cleansers, إلخ)
                        // في صفحة المنتجات سنقرر كيف نفلتر (حالياً سنعرض جميع المنتجات أو يمكن تخصيص فلتر لاحقاً)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryProductsPage(
                              category: cat['title'] as String,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: cat['color'] as Color,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              cat['icon'] as IconData,
                              size: 50,
                              color: const Color(0xFF1A531A),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              cat['title'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
