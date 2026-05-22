// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// استيرادات الفايربيس الأساسية
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🔥 أضفنا استيراد المصادقة
import 'firebase_options.dart';

import 'data/providers/app_provider.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/screens/login_screen.dart'; // 🔥 أضفنا استيراد شاشة تسجيل الدخول الجديدة
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الفايربيس عند إقلاع التطبيق
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,

        // 🔥 التعديل الجوهري: إضافة الـ StreamBuilder (شرطي المرور الذكي)
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance
              .authStateChanges(), // الاستماع اللحظي لحالة تسجيل الدخول
          builder: (context, snapshot) {
            // 1. إذا كان الفايربيس لا يزال يتحقق ويحمل البيانات
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(color: Colors.teal),
                ),
              );
            }

            // 2. إذا وجد الفايربيس مستخدم مسجل دخول (snapshot يحتوي على بيانات)
            if (snapshot.hasData) {
              return const MainScreen(); // افتح واجهة المتجر الرئيسية فوراً
            }

            // 3. إذا لم يجد مستخدم مسجل دخول (أول مرة يفتح التطبيق أو سجل خروج)
            return const LoginScreen(); // يوجهه لشاشة تسجيل الدخول/الاشتراك
          },
        ),
      ),
    );
  }
}
