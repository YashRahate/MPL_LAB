import 'package:flutter/material.dart';
import 'package:sca/screens/features/add_medication_reminder/step_two_days_frequency.dart';
import 'package:sca/screens/features/components/custom_next_button.dart';

class StepOneNameDosage extends StatefulWidget {
  @override
  _StepOneNameDosageState createState() => _StepOneNameDosageState();
}

class _StepOneNameDosageState extends State<StepOneNameDosage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<String> medicationNames = [];
  String? selectedDosage;

  void addMedicationName() {
    if (nameController.text.isNotEmpty) {
      setState(() {
        medicationNames.add(nameController.text);
        nameController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Step 1: Name & Dosage"),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Step 1: Name & Dosage",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name of Medication",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addMedicationName,
                ),
              ),
            ),
            SizedBox(height: 20),
            if (medicationNames.isNotEmpty) ...[
              Text(
                "Added Medications:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: medicationNames.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(medicationNames[index]),
                  ),
                ),
              ),
            ],
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedDosage,
              decoration: InputDecoration(
                labelText: "Dosage",
                border: OutlineInputBorder(),
              ),
              items: ["Pill", "Capsule", "Drops"]
                  .map((dosage) => DropdownMenuItem(
                        value: dosage,
                        child: Text(dosage),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedDosage = value;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
              maxLines: 3, // Multi-line for long descriptions
            ),
            Spacer(),
            CustomNextButton(
              onPressed: () {
                if (medicationNames.isNotEmpty && selectedDosage != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StepTwoDaysFrequency(
                        medicationNames: medicationNames,
                        selectedDosage: selectedDosage!,
                        description: descriptionController.text,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Please add at least one medication and select dosage!")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
