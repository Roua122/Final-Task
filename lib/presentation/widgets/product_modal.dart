// presentation/widgets/product_modal.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/product.dart'; // استيراد المودل الأصلي
import '../../data/providers/app_provider.dart';

class ProductModalDetail extends StatelessWidget {
  final Product product;
  const ProductModalDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 15, 25, 25),
      decoration: const BoxDecoration(
        color: Color(0xFFFBFBF9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // زر إغلاق (مقبض)
          Center(
            child: Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // الصورة
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              product.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),

          // العنوان والسعر
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "\$${product.price}",
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A531A)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(product.description,
              style: const TextStyle(fontSize: 16, color: Colors.black54)),
          const SizedBox(height: 30),

          // زر الإضافة للسلة
          SizedBox(
            width: double.infinity,
            height: 60,
            child: FilledButton.icon(
              onPressed: () {
                Provider.of<AppProvider>(context, listen: false)
                    .addToCart(product);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text("Add to Bag", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
