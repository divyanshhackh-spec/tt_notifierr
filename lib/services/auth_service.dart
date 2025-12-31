import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/teacher.dart';

final supabase = Supabase.instance.client;

class AuthService extends ChangeNotifier {
  Teacher? _currentUser;
  Teacher? get currentUser => _currentUser;

  // Local offline admin
  static final Teacher _offlineAdmin = Teacher(
    id: '0', // string id to match Supabase UUID style
    username: 'admin',
    pin: '1234',
    fullName: 'Offline Admin',
    isAdmin: true,
  );

  Future<bool> login(String username, String pin) async {
    final u = username.trim();
    final p = pin.trim();

    // 1) Offline hard-coded admin
    if (u == _offlineAdmin.username && p == _offlineAdmin.pin) {
      _currentUser = _offlineAdmin;
      notifyListeners();
      return true;
    }

    // 2) Online admins / teachers from Supabase
    try {
      final response = await supabase
          .from('teachers')
          .select()
          .eq('username', u)
          .eq('pin', p)
          .limit(1)
          .maybeSingle();

      debugPrint('Login response for "$u": $response'); // [web:449]

      if (response == null) {
        return false;
      }

      _currentUser = Teacher(
        id: response['id']?.toString(), // safely convert UUID to String [web:452]
        username: response['username'] as String,
        pin: response['pin'] as String,
        fullName: (response['full_name'] ?? '') as String,
        isAdmin: (response['is_admin'] ?? false) as bool,
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
