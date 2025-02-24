import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sca/screens/login_screen.dart';
import 'package:sca/screens/settings/language_settings.dart';
import 'package:sca/screens/settings/font_size_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF283593), // Deep indigo
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const _SettingsHeader(title: 'Accessibility'),
          _SettingsItem(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'Change application language',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LanguageSettingsScreen()),
              );
            },
          ),
          _SettingsItem(
            icon: Icons.text_fields,
            title: 'Font Size',
            subtitle: 'Adjust text size for better readability',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FontSizeSettingsScreen()),
              );
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode, color: Color(0xFF283593)),
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle between light and dark theme'),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
              // Implement theme change logic here
            },
          ),
          const Divider(),
          const _SettingsHeader(title: 'Account'),
          _SettingsItem(
            icon: Icons.person,
            title: 'Profile',
            subtitle: 'View and edit your profile',
            onTap: () {
              // Navigate to profile screen
            },
          ),
          _SettingsItem(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            onTap: () {
              // Navigate to notifications settings
            },
          ),
          const Divider(),
          const _SettingsHeader(title: 'Others'),
          _SettingsItem(
            icon: Icons.info,
            title: 'About',
            subtitle: 'App information and version',
            onTap: () {
              // Show about dialog
            },
          ),
          _SettingsItem(
            icon: Icons.help,
            title: 'Help & Support',
            subtitle: 'Get assistance and view FAQs',
            onTap: () {
              // Navigate to help screen
            },
          ),
          _SettingsItem(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out from your account',
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: _confirmLogout,
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
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
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pop(context); // Close dialog
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  final String title;

  const _SettingsHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color iconColor;
  final Color textColor;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor = const Color(0xFF283593),
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(subtitle),
      onTap: onTap,
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),
    );
  }
}