import 'package:flutter/material.dart';

class MedicationRemindersScreen extends StatefulWidget {
  const MedicationRemindersScreen({super.key});

  @override
  State<MedicationRemindersScreen> createState() => _MedicationRemindersScreenState();
}

class _MedicationRemindersScreenState extends State<MedicationRemindersScreen> {
  void _navigateToAddMedications() {
    Navigator.pushNamed(context, '/add_medications');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _navigateToAddMedications, // Tap to navigate
        onLongPress: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Long Press Detected!")),
          );
        },
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            _navigateToAddMedications(); // Swipe Left to Navigate
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medication,
              size: 80,
              color: Colors.blue.shade700,
            ),
            const SizedBox(height: 16),
            const Text(
              'Medication Reminders',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: _navigateToAddMedications,
              icon: const Icon(Icons.add),
              label: const Text('Add Medication Reminder', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
