class Teacher {
  final String? id;
  final String username;
  final String pin;
  final String fullName;
  final bool isAdmin;

  Teacher({
    this.id,
    required this.username,
    required this.pin,
    required this.fullName,
    required this.isAdmin,
  });

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      id: map['id']?.toString(), // UUID -> String
      username: map['username'] as String,
      pin: map['pin'] as String,
      fullName: map['full_name'] as String,
      isAdmin: map['is_admin'] as bool, // Supabase bool column [web:449]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'pin': pin,
      'full_name': fullName,
      'is_admin': isAdmin, // store as bool, not 0/1 [web:448]
    };
  }
}
