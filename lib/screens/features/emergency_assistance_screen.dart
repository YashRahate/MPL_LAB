import 'package:flutter/material.dart';
import '../../services/emergency_service.dart';

class EmergencyAssistanceScreen extends StatefulWidget {
  const EmergencyAssistanceScreen({super.key});

  @override
  State<EmergencyAssistanceScreen> createState() => _EmergencyAssistanceScreenState();
}

class _EmergencyAssistanceScreenState extends State<EmergencyAssistanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emergency,
              size: 80,
              color: Colors.red.shade700,
            ),
            const SizedBox(height: 16),
            const Text(
              'Emergency Assistance',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                _showEmergencyConfirmation(context);
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade700,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'SOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Tap the SOS button to alert your emergency contacts',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmergencyConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Send Emergency Alert?'),
          content: const Text(
            'This will notify all your emergency contacts with your current location.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _triggerEmergencyAlert(context);
              },
              child: const Text('Send Alert'),
            ),
          ],
        );
      },
    );
  }

void _triggerEmergencyAlert(BuildContext context) async {
  try {
    final emergencyAlertService = EmergencyAlertService();

    // Send emergency alert
    await emergencyAlertService.sendEmergencyAlert();

    // Check if the widget is still mounted before showing a SnackBar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Emergency alert sent to your contacts',
            style: TextStyle(fontSize: 16),
          ),
          duration: Duration(seconds: 5),
        ),
      );
    }
  } catch (e) {
    // Check if the widget is still mounted before showing a SnackBar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Failed to send emergency alert: $e',
            style: TextStyle(fontSize: 16),
          ),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }
}

}