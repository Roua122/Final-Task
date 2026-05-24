// core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1A531A);

  // ================= 1. الثيم الفاتح (Light Theme) =================
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: Colors.transparent, // مهم نخليه شفاف لظهور التدرج
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: Colors.white,
  );

  // ================= 2. الثيم الداكن (Dark Theme) =================
  static ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: Colors.transparent, // مهم نخليه شفاف لظهور التدرج
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardColor: const Color(0xFF1E1E1E), // لون كروت داكن وأنيق
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );

  // ================= 3. الخلفية المتدرجة للوضع الفاتح =================
  static BoxDecoration lightBackgroundGradient = const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFFFFFFFF), // أبيض
        Color(0xFFF5F1E8), // بيج
        Color(0xFFE8F3EA), // أخضر فاتح
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  // ================= 4. الخلفية المتدرجة للوضع الداكن =================
  static BoxDecoration darkBackgroundGradient = const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFF121212), // أسود مطفي
        Color(0xFF1A261E), // أخضر داكن جداً (يتماشى مع لون التطبيق)
        Color(0xFF0F1712), // أسود مائل للون الغابات
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}
