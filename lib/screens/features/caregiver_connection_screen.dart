import 'package:flutter/material.dart';

class CaregiverConnectionScreen extends StatefulWidget {
  const CaregiverConnectionScreen({super.key});

  @override
  State<CaregiverConnectionScreen> createState() => _CaregiverConnectionScreenState();
}

class _CaregiverConnectionScreenState extends State<CaregiverConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people,
            size: 80,
            color: Colors.purple.shade700,
          ),
          const SizedBox(height: 16),
          const Text(
            'Caregiver Connection',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              // Navigate to add caregiver screen
              // To be implemented
            },
            icon: const Icon(Icons.person_add),
            label: const Text('Add Caregiver', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}