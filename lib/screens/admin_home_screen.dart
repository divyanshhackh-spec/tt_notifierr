import 'package:flutter/material.dart';
import '../models/teacher.dart';
import 'manage_teachers_page.dart';
import 'manage_timetable_page.dart';

class AdminHomeScreen extends StatelessWidget {
  final Teacher admin;

  const AdminHomeScreen({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Welcome back,',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                Text(
                  admin.fullName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'PM SHRI KV No. 2 Jaipur',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),

                const SizedBox(height: 24),

                // Quick stats (dummy for now)
                Row(
                  children: [
                    _StatChip(
                      icon: Icons.person,
                      label: 'Teachers',
                      value: 'Manage',
                      color: Colors.white.withOpacity(0.15),
                    ),
                    const SizedBox(width: 12),
                    _StatChip(
                      icon: Icons.schedule,
                      label: 'Timetable',
                      value: 'Edit',
                      color: Colors.white.withOpacity(0.15),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Action cards
                Expanded(
                  child: GridView.count(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _AdminCard(
                        icon: Icons.people_alt_outlined,
                        title: 'Manage Teachers',
                        subtitle: 'Add, view and remove teachers\nand admins.',
                        color: Colors.blueAccent.withOpacity(0.85),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ManageTeachersPage(),
                            ),
                          );
                        },
                      ),
                      _AdminCard(
                        icon: Icons.grid_view_rounded,
                        title: 'Manage Timetable',
                        subtitle: 'Set periods for each class\nand day.',
                        color: Colors.deepPurpleAccent.withOpacity(0.85),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ManageTimetablePage(),
                            ),
                          );
                        },
                      ),
                      _AdminCard(
                        icon: Icons.notifications_active_outlined,
                        title: 'Upcoming Feature',
                        subtitle: 'Notifications, reports and\nmore coming soon.',
                        color: Colors.orangeAccent.withOpacity(0.85),
                        onTap: () {
                          // placeholder
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _AdminCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.12),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [
                color,
                color.withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(icon, color: Colors.white),
              ),
              const Spacer(),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
