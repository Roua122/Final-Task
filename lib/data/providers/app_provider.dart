// data/providers/app_provider.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/product.dart';
import '../local/db_helper.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
  });
}

class AppProvider with ChangeNotifier {
  List<Product> _products = [];

  bool isLoading = true;

  final Map<String, CartItem> _cartItems = {};

  List<String> _favoriteIds = [];

  StreamSubscription<QuerySnapshot>? _productsSubscription;

  StreamSubscription<DocumentSnapshot>? _favoritesSubscription;

  StreamSubscription<User?>? _authSubscription;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Product> get products => _products;

  bool get loading => isLoading;

  Map<String, CartItem> get cartItems => _cartItems;

  // 🔥 المنتجات المفضلة
  List<Product> get favoriteProducts => _products
      .where(
        (product) => _favoriteIds.contains(product.id.toString()),
      )
      .toList();

  AppProvider() {
    // 🔥 تحميل المنتجات
    listenToProducts();

    // 🔥 مراقبة تسجيل الدخول والخروج
    _authSubscription = _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        // 🔥 تحميل المفضلة
        listenToFavorites();

        // 🔥 تحميل السلة الخاصة بالمستخدم
        await loadCartFromDB();
      } else {
        _favoritesSubscription?.cancel();

        _favoriteIds.clear();

        _cartItems.clear();

        notifyListeners();
      }
    });
  }

  // ==============================
  // 🔥 المنتجات من فايربيس
  // ==============================

  void listenToProducts() {
    isLoading = true;

    _productsSubscription?.cancel();

    _productsSubscription = FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((snapshot) {
      _products = snapshot.docs
          .map(
            (doc) => Product.fromMap(
              doc.data(),
              doc.id,
            ),
          )
          .toList();

      isLoading = false;

      notifyListeners();
    });
  }

  // ==============================
  // 🔥 المفضلة
  // ==============================

  void listenToFavorites() {
    User? user = _auth.currentUser;

    if (user == null) return;

    _favoritesSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((snapshot) {
      _favoriteIds = snapshot.exists
          ? List<String>.from(
              snapshot.data()?['favorites'] ?? [],
            )
          : [];

      notifyListeners();
    });
  }

  bool isProductFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  Future<void> toggleFavorite(String productId) async {
    User? user = _auth.currentUser;

    if (user == null) return;

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }

    notifyListeners();

    await userRef.set({
      'favorites': _favoriteIds,
    }, SetOptions(merge: true));
  }

  // ==============================
  // 🔥 تحميل السلة من SQLite
  // ==============================

  Future<void> loadCartFromDB() async {
    try {
      final userId = _auth.currentUser?.uid;

      if (userId == null) return;

      final data = await DatabaseHelper.instance.getCartItems(userId);

      _cartItems.clear();

      for (var item in data) {
        _cartItems[item['id']] = CartItem(
          id: item['id'],
          quantity: item['quantity'],
          product: Product(
            id: item['id'],
            title: item['title'],
            price: item['price'],
            imageUrl: item['imageUrl'],
            description: '',
            category: '',
          ),
        );
      }

      notifyListeners();
    } catch (e) {
      print("خطأ في جلب السلة: $e");
    }
  }

  // ==============================
  // 🔥 حفظ عنصر في SQLite
  // ==============================

  void _saveItemToDB(CartItem item) {
    final userId = _auth.currentUser?.uid;

    if (userId == null) return;

    DatabaseHelper.instance.insertOrUpdateCartItem({
      'id': item.id,
      'userId': userId,
      'title': item.product.title,
      'price': item.product.price,
      'imageUrl': item.product.imageUrl,
      'quantity': item.quantity,
    });
  }

  // ==============================
  // 🔥 إضافة للسلة
  // ==============================

  void addToCart(Product product) {
    final id = product.id.toString();

    if (_cartItems.containsKey(id)) {
      _cartItems[id]!.quantity++;
    } else {
      _cartItems[id] = CartItem(
        id: id,
        product: product,
      );
    }

    _saveItemToDB(_cartItems[id]!);

    notifyListeners();
  }

  // ==============================
  // 🔥 زيادة الكمية
  // ==============================

  void increaseQty(String id) {
    if (_cartItems.containsKey(id)) {
      _cartItems[id]!.quantity++;

      _saveItemToDB(_cartItems[id]!);

      notifyListeners();
    }
  }

  // ==============================
  // 🔥 تقليل الكمية
  // ==============================

  void decreaseQty(String id) {
    final userId = _auth.currentUser?.uid;

    if (userId == null) return;

    if (_cartItems.containsKey(id)) {
      if (_cartItems[id]!.quantity > 1) {
        _cartItems[id]!.quantity--;

        _saveItemToDB(_cartItems[id]!);
      } else {
        _cartItems.remove(id);

        DatabaseHelper.instance.removeCartItem(
          id,
          userId,
        );
      }

      notifyListeners();
    }
  }

  // ==============================
  // 🔥 حذف منتج من السلة
  // ==============================

  void removeFromCart(String id) {
    final userId = _auth.currentUser?.uid;

    if (userId == null) return;

    _cartItems.remove(id);

    DatabaseHelper.instance.removeCartItem(
      id,
      userId,
    );

    notifyListeners();
  }

  // ==============================
  // 🔥 الإحصائيات
  // ==============================

  int get cartCount => _cartItems.values.fold(
        0,
        (sum, item) => sum + item.quantity,
      );

  double get totalPrice => _cartItems.values.fold(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );

  // ==============================
  // 🔥 تنظيف الذاكرة
  // ==============================

  @override
  void dispose() {
    _productsSubscription?.cancel();

    _favoritesSubscription?.cancel();

    _authSubscription?.cancel();

    super.dispose();
  }
}
