import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'teacher_home_screen.dart';
import 'admin_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _pinController = TextEditingController();
  String? _error;

  bool _loading = false;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final auth = Provider.of<AuthService>(context, listen: false);
    final success = await auth.login(
      _usernameController.text.trim(),
      _pinController.text.trim(),
    );

    setState(() {
      _loading = false;
    });

    if (!success) {
      setState(() {
        _error = 'Invalid username or PIN';
      });
      return;
    }

    final user = auth.currentUser!;
    if (user.isAdmin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminHomeScreen(admin: user),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const TeacherHomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              width: 350,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'TT-Notifier',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    const Text('PM SHRI KV No. 2 Jaipur'),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _pinController,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'PIN',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 25),
                    _loading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              icon: const Icon(Icons.login),
                              label: const Text('Login'),
                              onPressed: _login,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
