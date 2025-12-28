import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/admin_provider.dart';
import 'content_management_screen.dart';
import 'event_management_screen.dart';
import 'user_management_screen.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Periwinkle/Light Blue-Purple theme color
  static const Color _actionCardColor = Color(0xFF7B8CDE);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminProvider.notifier).loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adminState = ref.watch(adminProvider);
    final stats = adminState.stats;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      // ========== DRAWER ==========
      drawer: _buildDrawer(),
      body: SafeArea(
        child: adminState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => ref.read(adminProvider.notifier).loadDashboard(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ========== CUSTOM TOP BAR ==========
                      _buildTopBar(),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),

                            // ========== OUR USERS SECTION ==========
                            Text(
                              'Our Users',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[900],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 2x2 Stats Grid
                            _buildUsersGrid(stats),
                            const SizedBox(height: 28),

                            // ========== ACTION AREA ==========
                            // Add Event Details - Full Width Card
                            _buildAddEventCard(),
                            const SizedBox(height: 16),

                            // Bottom Row - Two Equal Cards
                            Row(
                              children: [
                                Expanded(
                                  child: _buildActionSquareCard(
                                    icon: Icons.cloud_upload_outlined,
                                    label: 'Go to\nUploads',
                                    onTap: () => _openContentManagement('MEDICAL'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildActionSquareCard(
                                    icon: Icons.visibility_outlined,
                                    label: 'View Uploaded\nData',
                                    onTap: () => _openUserManagement(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
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

  // ========== TOP BAR ==========
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Hamburger Menu
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black, size: 28),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          // Center Title
          const Text(
            'Home',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          // Add Person/Register Icon
          IconButton(
            icon: const Icon(Icons.person_add_alt_1, color: Colors.black, size: 28),
            onPressed: () => _showAddUserDialog(),
          ),
        ],
      ),
    );
  }

  // ========== DRAWER ==========
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: _actionCardColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.admin_panel_settings, size: 35, color: Color(0xFF7B8CDE)),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Swastha Aur Abhimaan',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.local_hospital),
            title: const Text('Medical Content'),
            onTap: () {
              Navigator.pop(context);
              _openContentManagement('MEDICAL');
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Education Content'),
            onTap: () {
              Navigator.pop(context);
              _openContentManagement('EDUCATION');
            },
          ),
          ListTile(
            leading: const Icon(Icons.construction),
            title: const Text('Skills Training'),
            onTap: () {
              Navigator.pop(context);
              _openContentManagement('SKILL');
            },
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Nutrition Content'),
            onTap: () {
              Navigator.pop(context);
              _openContentManagement('NUTRITION');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Event Management'),
            onTap: () {
              Navigator.pop(context);
              _openEventManagement();
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('User Management'),
            onTap: () {
              Navigator.pop(context);
              _openUserManagement();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  // ========== USERS GRID (2x2) ==========
  Widget _buildUsersGrid(stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildUserStatCard(
          title: 'Total Users',
          count: stats.totalUsers,
          icon: Icons.people,
          iconColor: Colors.blue,
        ),
        _buildUserStatCard(
          title: 'Total Doctors',
          count: stats.totalDoctors,
          icon: Icons.medical_services,
          iconColor: Colors.green,
        ),
        _buildUserStatCard(
          title: 'Total Teachers',
          count: stats.totalTeachers,
          icon: Icons.school,
          iconColor: Colors.orange,
        ),
        _buildUserStatCard(
          title: 'Total Trainers',
          count: stats.totalTrainers,
          icon: Icons.fitness_center,
          iconColor: Colors.purple,
        ),
      ],
    );
  }

  // ========== USER STAT CARD ==========
  Widget _buildUserStatCard({
    required String title,
    required int count,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const Spacer(),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // ========== ADD EVENT CARD (Full Width) ==========
  Widget _buildAddEventCard() {
    return GestureDetector(
      onTap: () => _openEventManagement(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _actionCardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _actionCardColor.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Event Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Create and manage community events',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.calendar_month,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== ACTION SQUARE CARD ==========
  Widget _buildActionSquareCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _actionCardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _actionCardColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== ADD USER DIALOG ==========
  void _showAddUserDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person_add_alt_1, size: 28, color: Color(0xFF7B8CDE)),
                const SizedBox(width: 12),
                const Text(
                  'Register New User',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Select the role for the new user',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            _buildRoleOption(
              icon: Icons.person,
              title: 'User',
              subtitle: 'Regular community member',
              onTap: () {
                Navigator.pop(context);
                context.push('/register');
              },
            ),
            _buildRoleOption(
              icon: Icons.medical_services,
              title: 'Doctor',
              subtitle: 'Healthcare professional',
              onTap: () {
                Navigator.pop(context);
                context.push('/register');
              },
            ),
            _buildRoleOption(
              icon: Icons.school,
              title: 'Teacher',
              subtitle: 'Education professional',
              onTap: () {
                Navigator.pop(context);
                context.push('/register');
              },
            ),
            _buildRoleOption(
              icon: Icons.fitness_center,
              title: 'Trainer',
              subtitle: 'Skills trainer',
              onTap: () {
                Navigator.pop(context);
                context.push('/register');
              },
            ),
            _buildRoleOption(
              icon: Icons.admin_panel_settings,
              title: 'Admin',
              subtitle: 'System administrator',
              onTap: () {
                Navigator.pop(context);
                context.push('/register');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _actionCardColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: _actionCardColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // ========== NAVIGATION METHODS ==========
  void _openContentManagement(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContentManagementScreen(category: category),
      ),
    );
  }

  void _openEventManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EventManagementScreen(),
      ),
    );
  }

  void _openUserManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const UserManagementScreen(),
      ),
    );
  }
}
