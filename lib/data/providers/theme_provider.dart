import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool _isLoaded = false;

  bool get isDarkMode => _isDarkMode;

  bool get isLoaded => _isLoaded;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  ThemeProvider() {
    _loadTheme();

    // 🔥 مراقبة المستخدم الحالي
    _auth.authStateChanges().listen((user) async {
      await _loadTheme();
    });
  }

  // ============================
  // 🔥 تحميل الثيم الخاص بالمستخدم
  // ============================

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = _auth.currentUser?.uid;

    // 🔥 لو لم يوجد مستخدم
    if (userId == null) {
      _isDarkMode = false;

      _isLoaded = true;

      notifyListeners();

      return;
    }

    // 🔥 مفتاح خاص بكل مستخدم
    final key = 'isDarkMode_$userId';

    _isDarkMode = prefs.getBool(key) ?? false;

    _isLoaded = true;

    notifyListeners();
  }

  // ============================
  // 🔥 تغيير الثيم
  // ============================

  Future<void> toggleTheme() async {
    final userId = _auth.currentUser?.uid;

    if (userId == null) return;

    _isDarkMode = !_isDarkMode;

    final prefs = await SharedPreferences.getInstance();

    final key = 'isDarkMode_$userId';

    await prefs.setBool(key, _isDarkMode);

    notifyListeners();
  }
}