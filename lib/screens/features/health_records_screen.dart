import 'package:flutter/material.dart';
import 'package:sca/screens/features/add_health_records/add_health_record_screen.dart';

class HealthRecordsScreen extends StatefulWidget {
  const HealthRecordsScreen({super.key});
  @override
  State<HealthRecordsScreen> createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.health_and_safety,
            size: 80,
            color: Colors.green.shade700,
          ),
          const SizedBox(height: 16),
          const Text(
            'Health Records',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddHealthRecordScreen()),
              );
            },
            icon: const Icon(Icons.add),
            label:
                const Text('Add Health Record', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
