import 'package:flutter/material.dart';
import 'package:sca/screens/features/add_medication_reminder_screen.dart';
import 'package:sca/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:sca/screens/home_screen.dart';
import 'package:sca/screens/signup_screen.dart';
import 'package:sca/screens/reset_password.dart';
import 'package:sca/screens/features/user_search_screen.dart';
import 'package:sca/screens/settings/settings_screen.dart';

void main() async {
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
      initialRoute: '/login',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/reset_password': (context) => const ResetPassword(),
        '/settings': (context) => const SettingsScreen(),
        '/search_users': (context) => const UserSearchScreen(),
        '/add_medications': (context) => const AddMedicationReminderScreen() ,
      },
    );
  }
}