import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/timetable_entry.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';

final supabase = Supabase.instance.client;

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  List<TimetableEntry> _todayEntries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadToday();
  }

  Future<void> _loadToday() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final dayOfWeek = now.weekday; // 1 = Monday ... 7 = Sunday [web:455]

    setState(() {
      _loading = true;
    });

    try {
      final data = await supabase
          .from('timetables')
          .select()
          .eq('teacher_username', user.username)
          .eq('day_of_week', dayOfWeek)
          .order('period_number');

      debugPrint(
        'Loaded ${data.length} timetable rows for '
        '${user.username} / day_of_week=$dayOfWeek',
      ); // [web:449]

      final entries = List<Map<String, dynamic>>.from(data)
          .map(
            (d) => TimetableEntry(
              id: null, // or 0 if you prefer,
              teacherId: 0,
              dayOfWeek: d['day_of_week'] as int,
              periodNumber: d['period_number'] as int,
              className: d['class_name'] as String,
              section: d['section'] as String,
              roomNumber: d['room_number'] as String,
              subject: d['subject'] as String,
              startTime: d['start_time'] as String,
              endTime: d['end_time'] as String,
            ),
          )
          .toList();

      setState(() {
        _todayEntries = entries;
        _loading = false;
      });

      for (final e in entries) {
        await NotificationService.instance
            .scheduleNotification(e, minutesBefore: 5);
      }
    } catch (e) {
      debugPrint('Error loading timetable: $e');
      setState(() {
        _todayEntries = [];
        _loading = false;
      });
    }
  }

  String _formatPeriodLabel(TimetableEntry entry) {
    return 'P${entry.periodNumber.toString().padLeft(2, '0')}';
  }

  Widget _buildPeriodCard(TimetableEntry entry) {
    final neonGreen = const Color(0xFF00FF9C);
    final neonPink = const Color(0xFFFF2CFB);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF050716),
            Color(0xFF10142A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: neonGreen.withOpacity(0.6), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: neonGreen.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: neonPink, width: 2),
            gradient: RadialGradient(
              colors: [
                neonPink.withOpacity(0.25),
                Colors.transparent,
              ],
            ),
          ),
          child: Center(
            child: Text(
              _formatPeriodLabel(entry),
              style: TextStyle(
                color: neonPink,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        title: Text(
          '${entry.className}-${entry.section}',
          style: TextStyle(
            color: neonGreen,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: 1.1,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Color(0xFF9FA4FF),
              fontSize: 13,
              fontFamily: 'monospace',
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SUBJ  :: ${entry.subject}'),
                Text('ROOM  :: ${entry.roomNumber}'),
                Text('TIME  :: ${entry.startTime} → ${entry.endTime}'),
              ],
            ),
          ),
        ),
        trailing: Icon(
          Icons.timeline_rounded,
          color: neonGreen.withOpacity(0.8),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await _loadToday();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final username = auth.currentUser?.fullName ?? 'Teacher';
    final neonGreen = const Color(0xFF00FF9C);
    final neonPink = const Color(0xFFFF2CFB);

    return Scaffold(
      backgroundColor: const Color(0xFF02030A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF050716),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TT-Notifier//Teacher',
              style: TextStyle(
                color: neonGreen,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              'SESSION: $username',
              style: TextStyle(
                color: neonPink.withOpacity(0.8),
                fontSize: 12,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: neonGreen),
            onPressed: _refresh,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: neonGreen.withOpacity(0.3),
                  width: 1,
                ),
              ),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF050716),
                  Color(0xFF0C1024),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: DefaultTextStyle(
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Color(0xFF8DE5FF),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('> TODAY\'S SIGNAL FEED'),
                  Text(
                    DateTime.now().toLocal().toString().split('.').first,
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: neonGreen,
              backgroundColor: const Color(0xFF050716),
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Color(0xFF00FF9C)),
                      ),
                    )
                  : _todayEntries.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.shield_moon_outlined,
                                color: neonPink.withOpacity(0.8),
                                size: 40,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'NO ACTIVE PERIODS',
                                style: TextStyle(
                                  color: neonGreen,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'system@tt-notifier:~\$ schedule feed is empty',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  color: Color(0xFF9FA4FF),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _todayEntries.length,
                          itemBuilder: (context, index) {
                            return _buildPeriodCard(_todayEntries[index]);
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
