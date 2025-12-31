import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import '../models/timetable_entry.dart';

class NotificationService {
  NotificationService._privateConstructor();

  static final NotificationService instance =
      NotificationService._privateConstructor();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz_data.initializeTimeZones();

    const androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'tt_notifier_channel',
      'TT Notifier Notifications',
      description: 'Period start and end notifications',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  int _getNotificationId(TimetableEntry entry, {bool end = false}) {
    // separate IDs for start and end
    final base = (entry.teacherId * 10000) +
        (entry.dayOfWeek * 100) +
        entry.periodNumber;
    return end ? base + 1 : base;
  }

  tz.TZDateTime _buildTimeForToday(String hhmm) {
    final now = tz.TZDateTime.now(tz.local);
    final parts = hhmm.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  }

  Future<void> scheduleNotification(
    TimetableEntry entry, {
    int minutesBefore = 5,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    // START notification (minutesBefore before startTime)
    final start = _buildTimeForToday(entry.startTime);
    final notifyStart = start.subtract(Duration(minutes: minutesBefore));
    if (!notifyStart.isBefore(now)) {
      final startDetails = AndroidNotificationDetails(
        'tt_notifier_channel',
        'TT Notifier Notifications',
        channelDescription: 'Period start notifications',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'Period Reminder',
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        _getNotificationId(entry, end: false),
        'Upcoming Class: ${entry.className} – Section ${entry.section}',
        'Room ${entry.roomNumber} • ${entry.subject}',
        notifyStart,
        NotificationDetails(android: startDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }

    // END notification at endTime
    final end = _buildTimeForToday(entry.endTime);
    if (!end.isBefore(now)) {
      final endDetails = AndroidNotificationDetails(
        'tt_notifier_channel',
        'TT Notifier Notifications',
        channelDescription: 'Period end notifications',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'Period End',
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        _getNotificationId(entry, end: true),
        'Period Ended: ${entry.className} – Section ${entry.section}',
        'Subject: ${entry.subject}',
        end,
        NotificationDetails(android: endDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> cancelNotification(TimetableEntry entry) async {
    await flutterLocalNotificationsPlugin
        .cancel(_getNotificationId(entry, end: false));
    await flutterLocalNotificationsPlugin
        .cancel(_getNotificationId(entry, end: true));
  }

  Future<void> cancelAllForTeacherDay(int teacherId, int dayOfWeek) async {
    // optional: iterate possible periodNumbers and cancel both start/end IDs
  }
}
