import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'user_logs.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE logs (id INTEGER PRIMARY KEY, temperature REAL, gasLevel INTEGER, heartbeat INTEGER, timestamp TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertLog(Map<String, dynamic> log) async {
    final db = await database;
    await db.insert('logs', log);
  }
}
