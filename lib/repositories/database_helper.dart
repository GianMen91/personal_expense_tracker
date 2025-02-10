import 'package:path/path.dart'; // Path utility for handling database file paths
import 'package:sqflite/sqflite.dart'; // Sqflite package for SQLite database management

import '../models/expense.dart'; // Importing the Expense model

// DatabaseHelper class manages the SQLite database operations for the expense tracker.
class DatabaseHelper {
  // Singleton pattern: A single instance of the DatabaseHelper to avoid multiple database connections.
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // Private constructor to ensure only one instance of DatabaseHelper is created.
  DatabaseHelper._init();

  // Lazy loading of the database: Returns the existing database if available, otherwise initializes it.
  Future<Database> get database async {
    if (_database != null) {
      return _database!; // Return existing database if it exists
    }
    _database = await _initDB(
        'personal_expense_tracker.db'); // Initialize the database if it doesn't exist
    return _database!;
  }

  // Initializes the database by opening it at the given file path and calling _createDB if it doesn't exist.
  Future<Database> _initDB(String filePath) async {
    final dbPath =
        await getDatabasesPath(); // Get the default path for the database
    final path =
        join(dbPath, filePath); // Join the path with the database filename

    // Open the database, and create it if it doesn't exist, with version 1 and _createDB as the creation callback.
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB, // Callback to create the DB schema
    );
  }

  // Creates the database schema: A table for storing expenses.
  Future<void> _createDB(Database db, int version) async {
    // Execute the SQL query to create the 'expense' table with the necessary fields.
    await db.execute('''
      CREATE TABLE expense(
        id INTEGER PRIMARY KEY AUTOINCREMENT,  // Auto-incrementing ID
        category TEXT NOT NULL,                // Expense category (e.g., food, transportation)
        description TEXT NOT NULL,             // Description of the expense
        cost REAL  NOT NULL,                   // Cost of the expense
        date TEXT NOT NULL                     // Date of the expense
      )
    ''');
  }

  // Adds a new expense to the database.
  Future<int> addExpense(Expense expense) async {
    final db = await database; // Get the database instance
    // Insert the expense into the 'expense' table, returning the ID of the inserted record
    return await db.insert('expense', expense.toMap());
  }

  // Retrieves all expenses from the database.
  Future<List<Expense>> getExpenses() async {
    final db = await database; // Get the database instance
    final List<Map<String, dynamic>> maps =
        await db.query('expense'); // Query all expenses from the table
    // Convert the list of maps to a list of Expense objects
    return List.generate(maps.length, (i) => Expense.fromMap(maps[i]));
  }

  // Deletes an expense by its ID.
  Future<int> deleteExpense(int id) async {
    final db = await database; // Get the database instance
    // Delete the expense record where the ID matches
    return await db.delete(
      'expense',
      where: 'id = ?', // Specify the condition to match the expense ID
      whereArgs: [id], // Provide the argument for the condition
    );
  }
}
