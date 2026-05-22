// data/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔥 دالة "البث المباشر" (Stream) لجلب المنتجات لحظياً
  // التغيير: نستخدم Stream<List<Product>> بدلاً من Future
  static Stream<List<Product>> streamProducts() {
    return _db.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        // دمج الـ ID الخاص بفايربيس في البيانات
        data['id'] = doc.id;
        return Product.fromJson(data);
      }).toList();
    });
  }
}
