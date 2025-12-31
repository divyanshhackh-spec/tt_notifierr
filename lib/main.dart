import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://wedgayascpjmncqwxnrs.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndlZGdheWFzY3BqbW5jcXd4bnJzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQyNTYwNDIsImV4cCI6MjA3OTgzMjA0Mn0.FxZFEmAeM-mOuDUUgzIVsqvzY3VJg1eP9Ux9MUNxJKQ',
  );

  // Initialize local notifications
  await NotificationService.instance.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const TTNotifierApp(),
    ),
  );
}

class TTNotifierApp extends StatelessWidget {
  const TTNotifierApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'TT-Notifier',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}
