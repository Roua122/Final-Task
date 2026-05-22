// presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_theme.dart'; // استيراد ثيم التطبيق

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // جلب بيانات المستخدم الحالي من الفايربيس
    final User? user = FirebaseAuth.instance.currentUser;
    final String userEmail = user?.email ?? 'No email provided';
    final String userName =
        user?.displayName ?? userEmail.split('@')[0].toUpperCase();

    // سحب اللون الأخضر الأساسي من الثيم
    final Color primaryColor = AppTheme.lightTheme.primaryColor;

    return Container(
      decoration:
          AppTheme.backgroundGradient, // تفعيل الخلفية المتدرجة الفخمة للمتجر
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // جعل السكافولد شفافاً لكي يظهر التدرج
        appBar: AppBar(
          title: const Text(
            "My Account",
            style: TextStyle(letterSpacing: 0.8, fontSize: 20),
          ),
          centerTitle: true,
          actions: [],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 15),

              // ================= 🟢 بطاقة المستخدم الفخمة (User Info Card) =================
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white
                      .withOpacity(0.85), // خلفية بيضاء ناعمة شبه شفافة
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Row(
                  children: [
                    // الصورة الشخصية مع إطار متناسق مع الثيم
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: primaryColor.withOpacity(0.2), width: 3),
                          ),
                          child: const CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage("https://i.pravatar.cc/300"),
                          ),
                        ),
                        // رقعة صغيرة جمالية (شارة خضراء تفاعلية)
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: primaryColor,
                          child: const Icon(Icons.check,
                              size: 12, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(width: 18),
                    // نصوص معلومات المستخدم
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userEmail,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          // لمسة جمالية: تصنيف المستخدم داخل المتجر
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Skincare Lover 💚",
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // ================= 🟢 القائمة الرئيسية بالإنجليزية واللمسات الخضراء =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(
                        "Dashboard",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                            letterSpacing: 0.5),
                      ),
                    ),
                    _buildProfileOption(
                        Icons.shopping_bag_outlined, "My Orders", primaryColor),
                    _buildProfileOption(Icons.location_on_outlined,
                        "Shipping Addresses", primaryColor),
                    _buildProfileOption(Icons.favorite_border_outlined,
                        "My Favorites", primaryColor),
                    _buildProfileOption(Icons.credit_card_outlined,
                        "Payment Methods", primaryColor),
                    const SizedBox(height: 15),
                    const Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(
                        "Support & Settings",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                            letterSpacing: 0.5),
                      ),
                    ),
                    _buildProfileOption(Icons.notifications_none_outlined,
                        "Notifications", primaryColor),
                    _buildProfileOption(Icons.help_outline_rounded,
                        "Help & Support", primaryColor),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Divider(thickness: 1, color: Colors.black12),
              ),

              // ================= 🔴 زر تسجيل الخروج الأنيق =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.logout_rounded,
                          color: Colors.red, size: 22),
                    ),
                    title: const Text(
                      "Sign Out",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: Colors.red),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // دالة بناء عناصر القائمة مدمجة بألوان الثيم والتنسيق العصري
  Widget _buildProfileOption(IconData icon, String title, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6), // خلفية بيضاء خفيفة للعناصر
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primaryColor
                .withOpacity(0.08), // هالة ناعمة بلون المتجر الأساسي
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon,
              color: primaryColor,
              size: 22), // الأيقونة بلون الأخضر الغامق الخاص بكِ
        ),
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            size: 14, color: Colors.black26),
        onTap: () {
          // ربط الشاشات مستقبلاً
        },
      ),
    );
  }
}
