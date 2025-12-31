import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tt_notifier.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE teachers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        pin TEXT NOT NULL,
        full_name TEXT,
        is_admin INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE timetable_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        teacher_id INTEGER NOT NULL,
        day_of_week INTEGER NOT NULL,
        period_number INTEGER NOT NULL,
        class_name TEXT NOT NULL,
        section TEXT NOT NULL,
        room_number TEXT NOT NULL,
        subject TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT NOT NULL
      )
    ''');

    // Insert default admin
    await db.insert('teachers', {
      'username': 'admin',
      'pin': '1234',
      'full_name': 'Administrator',
      'is_admin': 1
    });
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
