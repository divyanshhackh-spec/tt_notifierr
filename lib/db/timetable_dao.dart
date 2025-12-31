import 'package:sqflite/sqflite.dart';
import '../models/timetable_entry.dart';
import 'app_database.dart';

class TimetableDao {
  Future<List<TimetableEntry>> getForTeacherToday(int teacherId, int dayOfWeek) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(
      'timetable_entries',
      where: 'teacher_id = ? AND day_of_week = ?',
      whereArgs: [teacherId, dayOfWeek],
      orderBy: 'period_number ASC',
    );
    return result.map((e) => TimetableEntry.fromMap(e)).toList();
  }

  Future<int> insert(TimetableEntry e) async {
    final db = await AppDatabase.instance.database;
    return db.insert('timetable_entries', e.toMap());
  }

  Future<void> clearForTeacherDay(int teacherId, int dayOfWeek) async {
    final db = await AppDatabase.instance.database;
    await db.delete('timetable_entries',
        where: 'teacher_id = ? AND day_of_week = ?', whereArgs: [teacherId, dayOfWeek]);
  }
}
