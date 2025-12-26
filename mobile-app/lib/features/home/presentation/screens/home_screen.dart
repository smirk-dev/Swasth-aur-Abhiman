import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Swastha Aur Abhiman'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 35),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.fullName ?? 'User',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    user?.role ?? '',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                context.go('/home');
              },
            ),
            if (user?.role.toUpperCase() == 'ADMIN') ...[
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('Admin Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/admin');
                },
              ),
            ],
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('Medical'),
              onTap: () {
                Navigator.pop(context);
                context.push('/medical');
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Education'),
              onTap: () {
                Navigator.pop(context);
                context.push('/education');
              },
            ),
            ListTile(
              leading: const Icon(Icons.construction),
              title: const Text('Skills & Training'),
              onTap: () {
                Navigator.pop(context);
                context.push('/skills');
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant),
              title: const Text('Nutrition'),
              onTap: () {
                Navigator.pop(context);
                context.push('/nutrition');
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Events'),
              onTap: () {
                Navigator.pop(context);
                context.push('/events');
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('Chat'),
              onTap: () {
                Navigator.pop(context);
                context.push('/chat');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user?.fullName ?? 'User'}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            
            // Feature Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _FeatureCard(
                  icon: Icons.medical_services,
                  title: 'Medical',
                  onTap: () => context.push('/medical'),
                ),
                _FeatureCard(
                  icon: Icons.school,
                  title: 'Education',
                  onTap: () => context.push('/education'),
                ),
                _FeatureCard(
                  icon: Icons.construction,
                  title: 'Skills',
                  onTap: () => context.push('/skills'),
                ),
                _FeatureCard(
                  icon: Icons.restaurant,
                  title: 'Nutrition',
                  onTap: () => context.push('/nutrition'),
                ),
                _FeatureCard(
                  icon: Icons.event,
                  title: 'Events',
                  onTap: () => context.push('/events'),
                ),
                _FeatureCard(
                  icon: Icons.chat,
                  title: 'Chat',
                  onTap: () => context.push('/chat'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
