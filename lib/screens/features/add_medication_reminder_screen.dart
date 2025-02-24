import 'package:flutter/material.dart';

class AddMedicationReminderScreen extends StatefulWidget {
  const AddMedicationReminderScreen({super.key});

  @override
  State<AddMedicationReminderScreen> createState() => _AddMedicationReminderScreenState();
}

class _AddMedicationReminderScreenState extends State<AddMedicationReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medication Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Medicine Name Field
              TextFormField(
                controller: _medicineNameController,
                decoration: const InputDecoration(
                  labelText: 'Medicine Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the medicine name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Dosage Field (Number Input)
              TextFormField(
                controller: _dosageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Dosage (e.g., 2)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the dosage';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Time Field (Time Picker)
              TextFormField(
                controller: _timeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Time (e.g., 8:00 AM)',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                onTap: () async {
                  // Show Time Picker
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    setState(() {
                      _selectedTime = pickedTime;
                      _timeController.text = pickedTime.format(context);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Save Reminder Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process the input data
                    String medicineName = _medicineNameController.text;
                    int dosage = int.parse(_dosageController.text);
                    String time = _timeController.text;

                    // Show confirmation message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Medication Reminder Added:\nMedicine: $medicineName\nDosage: $dosage\nTime: $time',
                        ),
                      ),
                    );

                    // Clear form after submission
                    _medicineNameController.clear();
                    _dosageController.clear();
                    _timeController.clear();
                  }
                },
                child: const Text('Save Reminder', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
