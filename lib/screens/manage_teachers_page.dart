import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ManageTeachersPage extends StatefulWidget {
  const ManageTeachersPage({super.key});

  @override
  State<ManageTeachersPage> createState() => _ManageTeachersPageState();
}

class _ManageTeachersPageState extends State<ManageTeachersPage> {
  final _usernameController = TextEditingController();
  final _pinController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _isAdmin = false;

  List<Map<String, dynamic>> _teachers = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  Future<void> _loadTeachers() async {
    setState(() {
      _loading = true;
    });
    try {
      final data = await supabase
          .from('teachers')
          .select()
          .order('username');
      setState(() {
        _teachers = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      // Optional: show a snackbar
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _addTeacher() async {
    final username = _usernameController.text.trim();
    final pin = _pinController.text.trim();
    final fullName = _fullNameController.text.trim();

    if (username.isEmpty || pin.isEmpty) return;

    try {
      await supabase.from('teachers').insert({
        'username': username,
        'pin': pin,
        'full_name': fullName,
        'is_admin': _isAdmin,
      });

      _usernameController.clear();
      _pinController.clear();
      _fullNameController.clear();
      setState(() {
        _isAdmin = false;
      });

      await _loadTeachers();
    } catch (e) {
      // Optional: show error
    }
  }

  Future<void> _deleteTeacher(dynamic id) async {
    try {
      await supabase.from('teachers').delete().eq('id', id);
      await _loadTeachers();
    } catch (e) {
      // Optional: show error
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _pinController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Teachers'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _pinController,
                  decoration: const InputDecoration(
                    labelText: 'PIN',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full name (optional)',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: _isAdmin,
                      onChanged: (value) {
                        setState(() {
                          _isAdmin = value ?? false;
                        });
                      },
                    ),
                    const Text('Is admin'),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _addTeacher,
                  child: const Text('Add / Save Teacher'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _teachers.isEmpty
                    ? const Center(child: Text('No teachers yet.'))
                    : ListView.builder(
                        itemCount: _teachers.length,
                        itemBuilder: (context, index) {
                          final data = _teachers[index];
                          final id = data['id'];
                          final username = data['username'] ?? '';
                          final fullName = data['full_name'] ?? '';
                          final isAdmin = data['is_admin'] == true;

                          return ListTile(
                            title: Text(username),
                            subtitle: Text(
                              '${(fullName as String).isEmpty ? 'No name' : fullName} • ${isAdmin ? 'Admin' : 'Teacher'}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteTeacher(id),
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
