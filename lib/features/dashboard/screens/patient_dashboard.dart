import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_consultation/core/constants/app_colors.dart';
import 'package:smart_health_consultation/core/constants/app_styles.dart';
import 'package:smart_health_consultation/features/auth/providers/auth_provider.dart';
import 'package:smart_health_consultation/features/auth/screens/login_screen.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeTab(),
    const Center(child: Text('Appointments Tab')),
    const Center(child: Text('Prescriptions Tab')),
    const ProfileTab(), // Updated to ProfileTab
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            activeIcon: Icon(Icons.medical_services),
            label: 'Prescriptions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   const Text(
                      'Welcome,',
                      style: AppStyles.bodyMedium,
                    ),
                    Text(
                      authProvider.userEmail?.split('@').first ?? 'User',
                      style: AppStyles.headlineMedium,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Quick Actions',
              style: AppStyles.titleLarge,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildQuickAction(
                  icon: Icons.video_call,
                  label: 'Video Consult',
                  color: AppColors.consultation,
                ),
                _buildQuickAction(
                  icon: Icons.calendar_today,
                  label: 'Book Appointment',
                  color: AppColors.appointment,
                ),
                _buildQuickAction(
                  icon: Icons.message,
                  label: 'Chat with Doctor',
                  color: AppColors.secondary,
                ),
                _buildQuickAction(
                  icon: Icons.medical_services,
                  label: 'My Prescriptions',
                  color: AppColors.prescription,
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Quick logout button for testing
            Center(
              child: ElevatedButton(
                onPressed: () {
                  authProvider.logout();
                  // Navigation will be handled by the auth provider listener
                },
                child: const Text('Logout (Test)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      decoration: AppStyles.cardDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Add ProfileTab class
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.primary.withOpacity(0.1),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.userEmail?.split('@').first ?? 'User',
                        style: AppStyles.headlineMedium,
                      ),
                      Text(
                        authProvider.userEmail ?? '',
                        style: AppStyles.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Edit Profile'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined),
                    title: const Text('Notifications'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.security_outlined),
                    title: const Text('Privacy & Security'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help & Support'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Settings'),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
  leading: const Icon(Icons.logout, color: Colors.red),
  title: const Text('Logout', style: TextStyle(color: Colors.red)),
  onTap: () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Close dialog
              Navigator.pop(context);
              
              // Logout and navigate
              authProvider.logout();
              
              // Navigate to login screen and clear all routes
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  },
),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}