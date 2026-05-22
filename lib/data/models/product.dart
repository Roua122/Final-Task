// data/models/product.dart
class Product {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String category; // 🔥 أضفنا التصنيف هنا
  final String description; // تأكدي من وجود هذا السطر
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.category, // 🔥
    required this.description, // تأكدي من وجوده هنا أيضاً

    this.isFavorite = false,
  });

  factory Product.fromMap(Map<String, dynamic> map, String documentId) {
    return Product(
      id: documentId,
      title: map['title'] ?? 'بدون اسم',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ??
          'عام', // 🔥 أضفناه لدالة الفايربيس (عام كقيمة افتراضية)
      description: map['description'] ?? 'بدون وصف',
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'category': category, // 🔥
      'isFavorite': isFavorite,
    };
  }

  // دوال التحويل القديمة
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'imageUrl': imageUrl,
        'category': category,
        'isFavorite': isFavorite,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'].toString(),
        title: json['title'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        imageUrl: json['imageUrl'] ?? '',
        category: json['category'] ?? 'عام',
        isFavorite: json['isFavorite'] ?? false,
        description: json['description'] ?? 'بدون وصف',
      );
}
