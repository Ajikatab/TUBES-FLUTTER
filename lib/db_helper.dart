import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  // Fungsi untuk mendapatkan database
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Inisialisasi database
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'shop.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          '''CREATE TABLE products (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              description TEXT,
              price REAL
          )''',
        );
      },
    );
  }

  // Menambahkan produk baru
  static Future<void> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    await db.insert('products', product,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Mengambil semua produk
  static Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('products');
  }

  // Memperbarui produk
  static Future<void> updateProduct(
      int id, Map<String, dynamic> product) async {
    final db = await database;
    await db.update('products', product, where: 'id = ?', whereArgs: [id]);
  }

  // Menghapus produk
  static Future<void> deleteProduct(int id) async {
    final db = await database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
