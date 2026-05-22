// data/providers/app_provider.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;
  CartItem({required this.id, required this.product, this.quantity = 1});
}

class AppProvider with ChangeNotifier {
  List<Product> _products = [];
  bool isLoading = true;
  bool isOfflineMode = false; 
  final Map<String, CartItem> _cartItems = {};
  List<String> _favoriteIds = []; 
  
  StreamSubscription<QuerySnapshot>? _productsSubscription;
  StreamSubscription<DocumentSnapshot>? _favoritesSubscription; 
  StreamSubscription<User?>? _authSubscription;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Product> get products => _products;
  bool get loading => isLoading;
  Map<String, CartItem> get cartItems => _cartItems;

  AppProvider() {
    init(); // 🔥 نستدعي init عند إنشاء البروفايدر لأول مرة
  }

  // ================= 🔥 الدالة المفقودة التي تسبب الخطأ =================
  Future<void> init() async {
    listenToProducts();
    
    // نراقب الفايربيس: هل دخل مستخدم؟
    _authSubscription?.cancel();
    _authSubscription = _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        listenToFavorites();
      } else {
        _favoritesSubscription?.cancel();
        _favoriteIds.clear();
        _cartItems.clear();
        notifyListeners();
      }
    });
  }

  // ================= ☁️ FIREBASE PRODUCTS =================
  void listenToProducts() {
    isLoading = true;
    notifyListeners();

    _productsSubscription?.cancel();
    _productsSubscription = FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen((snapshot) {
      _products = snapshot.docs.map((doc) {
        return Product.fromMap(doc.data(), doc.id);
      }).toList();
      isLoading = false;
      notifyListeners();
    });
  }

  // ================= ❤️ FAVORITES =================
  void listenToFavorites() {
    User? user = _auth.currentUser;
    if (user == null) return;

    _favoritesSubscription?.cancel();
    _favoritesSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        _favoriteIds = List<String>.from(snapshot.data()?['favorites'] ?? []);
      } else {
        _favoriteIds = [];
      }
      notifyListeners(); 
    });
  }

  Future<void> toggleFavorite(String id) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    if (_favoriteIds.contains(id)) {
      await userRef.set({
        'favorites': FieldValue.arrayRemove([id])
      }, SetOptions(merge: true));
    } else {
      await userRef.set({
        'favorites': FieldValue.arrayUnion([id])
      }, SetOptions(merge: true));
    }
  }

  // ================= 🛒 CART OPERATIONS =================
  void addToCart(Product product) {
    final id = product.id.toString();
    if (_cartItems.containsKey(id)) {
      _cartItems[id]!.quantity++;
    } else {
      _cartItems[id] = CartItem(id: id, product: product);
    }
    notifyListeners();
  }

  void increaseQty(String id) {
    if (_cartItems.containsKey(id)) {
      _cartItems[id]!.quantity++;
      notifyListeners();
    }
  }

  void decreaseQty(String id) {
    if (_cartItems.containsKey(id)) {
      if (_cartItems[id]!.quantity > 1) {
        _cartItems[id]!.quantity--;
      } else {
        _cartItems.remove(id);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String id) {
    _cartItems.remove(id);
    notifyListeners();
  }

  @override
  void dispose() {
    _productsSubscription?.cancel();
    _favoritesSubscription?.cancel(); 
    _authSubscription?.cancel();
    super.dispose();
  }

  // دوال إضافية للسلة والمفضلة
  int get cartCount => _cartItems.values.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => _cartItems.values.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  List<Product> get favoriteProducts => _products.where((p) => _favoriteIds.contains(p.id.toString())).toList();
  bool isProductFavorite(String id) => _favoriteIds.contains(id);
}