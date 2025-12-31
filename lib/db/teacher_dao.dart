import 'package:sqflite/sqflite.dart';
import '../models/teacher.dart';
import 'app_database.dart';

class TeacherDao {
  Future<Teacher?> findByUsernamePin(String username, String pin) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(
      'teachers',
      where: 'username = ? AND pin = ?',
      whereArgs: [username, pin],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return Teacher.fromMap(result.first);
  }

  Future<List<Teacher>> getAll() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('teachers', orderBy: 'full_name ASC');
    return result.map((e) => Teacher.fromMap(e)).toList();
  }

  Future<int> insert(Teacher t) async {
    final db = await AppDatabase.instance.database;
    return db.insert('teachers', t.toMap());
  }

  Future<int> update(Teacher t) async {
    final db = await AppDatabase.instance.database;
    return db.update('teachers', t.toMap(), where: 'id = ?', whereArgs: [t.id]);
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;
    return db.delete('teachers', where: 'id = ?', whereArgs: [id]);
  }
}
