import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StepThreeInventoryThreshold extends StatefulWidget {
  final List<String> medicationNames;
  final String selectedDosage;
  final String description;
  final List<String> selectedDays;
  final int frequency;
  final List<TimeOfDay> reminderTimes;

  StepThreeInventoryThreshold({
    required this.medicationNames,
    required this.selectedDosage,
    required this.description,
    required this.selectedDays,
    required this.frequency,
    required this.reminderTimes,
  });

  @override
  _StepThreeInventoryThresholdState createState() =>
      _StepThreeInventoryThresholdState();
}

class _StepThreeInventoryThresholdState
    extends State<StepThreeInventoryThreshold> {
  final TextEditingController inventoryController = TextEditingController();
  final TextEditingController thresholdController = TextEditingController();
  bool isLoading = false;

  Future<void> saveMedicationDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not logged in!")),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final now = DateTime.now().toUtc();
      final times = widget.reminderTimes
          .map((time) => {
                "time": time.format(context),
                "status": false,
              })
          .toList();

      await FirebaseFirestore.instance.collection('medications').add({
        "userId": user.uid,
        "name": widget.medicationNames,
        "dosage": widget.selectedDosage,
        "days": widget.selectedDays,
        "frequency": widget.frequency,
        "schedule": times,
        "current_no_of_inventory": int.tryParse(inventoryController.text) ?? 0,
        "threshold": int.tryParse(thresholdController.text) ?? 0,
        "isActive": true,
        "description": widget.description,
        "createdAt": now.toIso8601String(),
        "updatedAt": now.toIso8601String(),
        "history": [],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Medication details saved successfully!")),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving medication: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Step 3: Inventory & Threshold"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Current Inventory",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: inventoryController,
              decoration: InputDecoration(
                labelText: "Enter current inventory",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text(
              "Threshold",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: thresholdController,
              decoration: InputDecoration(
                labelText: "Enter inventory threshold",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            Spacer(),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              )
            else
              ElevatedButton(
                onPressed: saveMedicationDetails,
                child: Text("Save Medication"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
