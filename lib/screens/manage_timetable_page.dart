import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ManageTimetablePage extends StatefulWidget {
  const ManageTimetablePage({super.key});

  @override
  State<ManageTimetablePage> createState() => _ManageTimetablePageState();
}

class _ManageTimetablePageState extends State<ManageTimetablePage> {
  final _classController = TextEditingController();
  final _sectionController = TextEditingController();
  final _roomController = TextEditingController();
  final _periodController = TextEditingController();
  final _subjectController = TextEditingController();
  final _teacherUsernameController = TextEditingController();
  final _startTimeController = TextEditingController(); // HH:mm
  final _endTimeController = TextEditingController();   // HH:mm

  int? _selectedDayOfWeek; // 1–7

  List<Map<String, dynamic>> _entries = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    setState(() {
      _loading = true;
    });
    try {
      final data = await supabase
          .from('timetables')
          .select()
          .order('class_name')
          .order('day_of_week')
          .order('period_number');
      setState(() {
        _entries = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      // Optional: show error
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
    );
    if (picked != null) {
      final hh = picked.hour.toString().padLeft(2, '0');
      final mm = picked.minute.toString().padLeft(2, '0');
      setState(() {
        controller.text = '$hh:$mm';
      });
    }
  }

  Future<void> _addEntry() async {
    final className = _classController.text.trim();
    final section = _sectionController.text.trim();
    final room = _roomController.text.trim();
    final periodText = _periodController.text.trim();
    final subject = _subjectController.text.trim();
    final teacherUsername = _teacherUsernameController.text.trim();
    final startTime = _startTimeController.text.trim();
    final endTime = _endTimeController.text.trim();

    if (className.isEmpty ||
        _selectedDayOfWeek == null ||
        periodText.isEmpty ||
        startTime.isEmpty ||
        endTime.isEmpty) return;

    final period = int.tryParse(periodText) ?? 0;
    if (period <= 0) return;

    final dayOfWeek = _selectedDayOfWeek!;

    try {
      await supabase.from('timetables').insert({
        'class_name': className,
        'section': section,
        'room_number': room,
        'day_of_week': dayOfWeek,
        'period_number': period,
        'subject': subject,
        'teacher_username': teacherUsername,
        'start_time': startTime,
        'end_time': endTime,
      });

      _classController.clear();
      _sectionController.clear();
      _roomController.clear();
      _periodController.clear();
      _subjectController.clear();
      _teacherUsernameController.clear();
      _startTimeController.clear();
      _endTimeController.clear();
      setState(() {
        _selectedDayOfWeek = null;
      });

      await _loadEntries();
    } catch (e) {
      // Optional: show error
    }
  }

  Future<void> _deleteEntry(dynamic id) async {
    try {
      await supabase.from('timetables').delete().eq('id', id);
      await _loadEntries();
    } catch (e) {
      // Optional: show error
    }
  }

  @override
  void dispose() {
    _classController.dispose();
    _sectionController.dispose();
    _roomController.dispose();
    _periodController.dispose();
    _subjectController.dispose();
    _teacherUsernameController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Timetable'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _classController,
                  decoration: const InputDecoration(
                    labelText: 'Class (e.g. 11)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _sectionController,
                  decoration: const InputDecoration(
                    labelText: 'Section (e.g. A)',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _roomController,
                  decoration: const InputDecoration(
                    labelText: 'Room number',
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  value: _selectedDayOfWeek,
                  decoration: const InputDecoration(
                    labelText: 'Day of week',
                  ),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Monday')),
                    DropdownMenuItem(value: 2, child: Text('Tuesday')),
                    DropdownMenuItem(value: 3, child: Text('Wednesday')),
                    DropdownMenuItem(value: 4, child: Text('Thursday')),
                    DropdownMenuItem(value: 5, child: Text('Friday')),
                    DropdownMenuItem(value: 6, child: Text('Saturday')),
                    DropdownMenuItem(value: 7, child: Text('Sunday')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedDayOfWeek = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _periodController,
                  decoration: const InputDecoration(
                    labelText: 'Period number (1,2,3...)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _teacherUsernameController,
                  decoration: const InputDecoration(
                    labelText: 'Teacher username',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _startTimeController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Start time (HH:mm)',
                  ),
                  onTap: () => _pickTime(_startTimeController),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _endTimeController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'End time (HH:mm)',
                  ),
                  onTap: () => _pickTime(_endTimeController),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _addEntry,
                  child: const Text('Add / Save Timetable Entry'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _entries.isEmpty
                    ? const Center(child: Text('No timetable entries yet.'))
                    : ListView.builder(
                        itemCount: _entries.length,
                        itemBuilder: (context, index) {
                          final data = _entries[index];
                          final id = data['id'];
                          final className = data['class_name'] ?? '';
                          final section = data['section'] ?? '';
                          final dayOfWeek = data['day_of_week'] ?? 0;
                          final period = data['period_number'] ?? 0;
                          final subject = data['subject'] ?? '';
                          final teacherUsername =
                              data['teacher_username'] ?? '';
                          final room = data['room_number'] ?? '';
                          final startTime = data['start_time'] ?? '';
                          final endTime = data['end_time'] ?? '';

                          return ListTile(
                            title: Text(
                                '$className$section • Day $dayOfWeek • Period $period'),
                            subtitle: Text(
                                '$subject • $teacherUsername • Room $room • $startTime–$endTime'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteEntry(id),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
