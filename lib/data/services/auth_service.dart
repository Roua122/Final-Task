// data/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print("🔴 Firebase Error Code: ${e.code}");
      throw Exception(_handleAuthError(e.code));
    }
  }

  // 🔥 تعديل دالة إنشاء الحساب لتستقبل (الاسم) وتقوم بتحديث البروفايل
  Future<UserCredential?> signUp(
      String name, String email, String password) async {
    try {
      // 1. إنشاء الحساب
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // 2. تحديث الاسم في الفايربيس
      await credential.user?.updateDisplayName(name.trim());

      return credential;
    } on FirebaseAuthException catch (e) {
      print("🔴 Firebase Error Code: ${e.code}");
      throw Exception(_handleAuthError(e.code));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 🔥 ترجمة رسائل الخطأ للإنجليزية لتتوافق مع لغة التطبيق الجديدة
  String _handleAuthError(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'An unknown error occurred: $errorCode';
    }
  }
}
