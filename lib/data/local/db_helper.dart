// data/local/db_helper.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    return _database ??= await _initDB('cart.db');
  }

  Future<Database> _initDB(String filePath) async {
    final path = join(await getDatabasesPath(), filePath);
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cart_items (
            id TEXT,
            userId TEXT,
            title TEXT,
            price REAL,
            imageUrl TEXT,
            quantity INTEGER,
            PRIMARY KEY (id, userId)
          )
        ''');
      },
    );
  }

  Future<void> insertOrUpdateCartItem(Map<String, dynamic> item) async {
    final db = await database;
    await db.insert(
      'cart_items',
      item,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getCartItems(String userId) async {
    final db = await database;
    return await db.query(
      'cart_items',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<void> removeCartItem(String id, String userId) async {
    final db = await database;
    await db.delete(
      'cart_items',
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );
  }

  Future<void> clearCart(String userId) async {
    final db = await database;
    await db.delete('cart_items', where: 'userId = ?', whereArgs: [userId]);
  }
}
