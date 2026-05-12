// data/services/local_storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class LocalStorageService {
  static const String _favKey = 'favorite_products';
  static const String _cacheKey = 'products_cache';

  // 1. حفظ المفضلات (تستخدم الشيرد بريفرنس لتعمل في الويب والموبايل)
  static Future<void> saveFavorites(List<Product> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = jsonEncode(
        favorites.map((p) => p.toJson()).toList(),
      );
      await prefs.setString(_favKey, encodedData);
      print("✅ تم حفظ المفضلات في التخزين المحلي");
    } catch (e) {
      print("❌ خطأ أثناء حفظ المفضلات: $e");
    }
  }

  // 2. تحميل المفضلات
  static Future<List<Product>> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedData = prefs.getString(_favKey);

      if (savedData != null) {
        final List<dynamic> decodedData = jsonDecode(savedData);
        return decodedData.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      print("❌ خطأ أثناء تحميل المفضلات: $e");
    }
    return [];
  }

  // 3. حفظ Cache المنتجات (للوضع الأوفلاين)
  static Future<void> cacheProducts(String jsonString) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonString);
      print("✅ تم تحديث كاش المنتجات");
    } catch (e) {
      print("❌ خطأ أثناء تخزين الكاش: $e");
    }
  }

  // 4. تحميل Cache المنتجات
  static Future<String?> loadCachedProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_cacheKey);
    } catch (e) {
      print("❌ خطأ أثناء تحميل الكاش: $e");
    }
    return null;
  }
}
