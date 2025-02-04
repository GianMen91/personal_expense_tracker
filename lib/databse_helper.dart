import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'expense.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('personal_expense_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expense(
        id INTEGER PRIMARY KEY AUTOINCREMENT,       
        category TEXT NOT NULL,
        description TEXT NOT NULL,
        cost REAL  NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<int> addExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expense', expense.toMap());
  }

  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('expense');
    return List.generate(maps.length, (i) => Expense.fromMap(maps[i]));
  }
}
