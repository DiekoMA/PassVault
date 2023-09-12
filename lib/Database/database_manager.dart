import 'package:passvault/models/creditcard.dart';
import 'package:passvault/models/password.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  static final DatabaseManager instance = DatabaseManager._init();
  static Database? _database;

  DatabaseManager._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users_store.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE passwords (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        username TEXT,
        password TEXT,
        website TEXT,
        notes TEXT,
        tags TEXT
      )
''');
    await db.execute('''
CREATE TABLE cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cardNumber INTEGER,
        cvv INTEGER,
        expirationDate TEXT,
        ownerName TEXT
      )
''');

//     await db.execute('''
// CREATE TABLE loyalty_cards (
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         serviceName TEXT,
//         username TEXT,
//         password TEXT
//       )
// ''');
  }

  /// Insert
  Future<int> insertPassword(Password password) async {
    final db = await instance.database;
    return await db.insert('passwords', password.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Password>> getPasswords() async {
    final db = await instance.database;
    final maps = await db.query('passwords');
    return List.generate(maps.length, (i) {
      return Password.fromMap(maps[i]);
    });
  }

  Future<int> updatePassword(Password password) async {
    final db = await instance.database;
    return await db.update(
      'passwords',
      password.toMap(),
      where: 'id = ?',
      whereArgs: [password.id],
    );
  }

  Future<int> deletePassword(int id) async {
    final db = await instance.database;
    return await db.delete(
      'passwords',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertCard(CreditCard creditCard) async {
    final db = await instance.database;
    return await db.insert('cards', creditCard.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CreditCard>> getCards() async {
    final db = await instance.database;
    final maps = await db.query('cards');
    return List.generate(maps.length, (i) {
      return CreditCard.fromMap(maps[i]);
    });
  }

  Future<int> updateCard(CreditCard creditCard) async {
    final db = await instance.database;
    return await db.update(
      'passwords',
      creditCard.toMap(),
      where: 'id = ?',
      whereArgs: [creditCard.id],
    );
  }

  Future<int> deleteCard(int id) async {
    final db = await instance.database;
    return await db.delete(
      'cards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
