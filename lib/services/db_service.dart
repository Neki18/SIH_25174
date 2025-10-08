import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';

class DBService {
  static Database? _db;
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fish_mvp.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        phone TEXT,
        password TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imagePath TEXT,
        species TEXT,
        confidence REAL,
        timestamp TEXT
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUser(String email, String password) async {
    final db = await database;
    final res = await db.query('users', where: 'email = ? AND password = ?', whereArgs: [email, password]);
    if (res.isNotEmpty) return User.fromMap(res.first);
    return null;
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (res.isNotEmpty) return User.fromMap(res.first);
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> clearAllHistory() async {
    final db = await database;
    return await db.delete('history');
  }

  Future<int> insertHistory(String imagePath, String species, double confidence) async {
    final db = await database;
    return await db.insert('history', {
      'imagePath': imagePath,
      'species': species,
      'confidence': confidence,
      'timestamp': DateTime.now().toIso8601String()
    });
  }

  Future<List<Map<String, dynamic>>> getAllHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'id DESC');
  }
}
