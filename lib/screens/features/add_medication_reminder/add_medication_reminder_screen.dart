import 'package:flutter/material.dart';
import 'package:sca/screens/features/add_medication_reminder/step_one_name_dosage.dart';


class AddMedicationReminderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Medication Reminder"),
      ),
      body: StepOneNameDosage(),
    );
  }
}
