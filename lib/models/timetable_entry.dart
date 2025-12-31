class TimetableEntry {
  final int? id;                // keep as int?
  final int teacherId;
  final int dayOfWeek; // 1=Mon..7=Sun
  final int periodNumber;
  final String className;
  final String section;
  final String roomNumber;
  final String subject;
  final String startTime; // 'HH:mm'
  final String endTime;   // 'HH:mm'

  TimetableEntry({
    this.id,
    required this.teacherId,
    required this.dayOfWeek,
    required this.periodNumber,
    required this.className,
    required this.section,
    required this.roomNumber,
    required this.subject,
    required this.startTime,
    required this.endTime,
  });

  factory TimetableEntry.fromMap(Map<String, dynamic> map) {
    return TimetableEntry(
      id: null, // Supabase uses UUID string; ignore for now
      teacherId: map['teacher_id'] as int,
      dayOfWeek: map['day_of_week'] as int,
      periodNumber: map['period_number'] as int,
      className: map['class_name'] as String,
      section: map['section'] as String,
      roomNumber: map['room_number'] as String,
      subject: map['subject'] as String,
      startTime: map['start_time'] as String,
      endTime: map['end_time'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // do not send id when inserting, Supabase will generate UUID
      'teacher_id': teacherId,
      'day_of_week': dayOfWeek,
      'period_number': periodNumber,
      'class_name': className,
      'section': section,
      'room_number': roomNumber,
      'subject': subject,
      'start_time': startTime,
      'end_time': endTime,
    };
  }
}
