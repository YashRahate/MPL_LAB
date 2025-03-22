import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:sca/screens/home_screen.dart';
import 'package:sca/screens/login_screen.dart';
import 'package:sca/screens/signup_screen.dart';
import 'package:sca/screens/reset_password.dart';
import 'package:sca/screens/features/add_medication_reminder/add_medication_reminder_screen.dart';
import 'package:sca/screens/features/user_search_screen.dart';
import 'package:sca/screens/settings/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Senior Care Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthWrapper(), // Use AuthWrapper to determine initial screen
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/reset_password': (context) => const ResetPassword(),
        '/settings': (context) => const SettingsScreen(),
        '/search_users': (context) => const UserSearchScreen(),
        '/add_medications': (context) => AddMedicationReminderScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If the stream has data, user is logged in
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user != null) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        }
        // Show loading indicator while checking auth state
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
