import 'package:flutter/material.dart';
import 'package:sca/screens/features/components/custom_next_button.dart';
import 'step_three_inventory_threshold.dart';

class StepTwoDaysFrequency extends StatefulWidget {
  final List<String> medicationNames;
  final String selectedDosage;
  final String description;

  StepTwoDaysFrequency({
    required this.medicationNames,
    required this.selectedDosage,
    required this.description,
  });
  @override
  _StepTwoDaysFrequencyState createState() => _StepTwoDaysFrequencyState();
}

class _StepTwoDaysFrequencyState extends State<StepTwoDaysFrequency> {
  final List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  final List<bool> selectedDays = List.generate(7, (index) => false);
  final TextEditingController frequencyController = TextEditingController();
  List<TimeOfDay?> selectedTimes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Step 2: Days & Frequency"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Days",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: List.generate(days.length, (index) {
                return FilterChip(
                  label: Text(days[index]),
                  selected: selectedDays[index],
                  onSelected: (isSelected) {
                    setState(() {
                      selectedDays[index] = isSelected;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20),
            TextField(
              controller: frequencyController,
              decoration: InputDecoration(
                labelText: "Frequency (e.g., 2 times daily)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int? frequency = int.tryParse(value);
                if (frequency != null) {
                  setState(() {
                    selectedTimes = List.generate(frequency, (_) => null);
                  });
                }
              },
            ),
            SizedBox(height: 20),
            if (selectedTimes.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Reminder Times",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ...List.generate(selectedTimes.length, (index) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedTimes[index] != null
                                ? "Time ${index + 1}: ${selectedTimes[index]!.format(context)}"
                                : "Select Time ${index + 1}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setState(() {
                                selectedTimes[index] = time;
                              });
                            }
                          },
                          child: Text("Pick Time ${index + 1}"),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            Spacer(),
            CustomNextButton(
              onPressed: () {
                int? frequency = int.tryParse(frequencyController.text);

                if (frequency == null || frequency <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text("Please enter a valid numeric frequency!")),
                  );
                  return;
                }

                if (!selectedDays.contains(true)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select at least one day!")),
                  );
                  return;
                }

                if (selectedTimes.any((time) => time == null)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Please select all reminder times!")),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StepThreeInventoryThreshold(
                      medicationNames: widget.medicationNames,
                      selectedDosage:
                          widget.selectedDosage, // Changed from widget.dosage
                      description: widget.description,
                      selectedDays: days
                          .asMap()
                          .entries
                          .where((entry) => selectedDays[entry.key])
                          .map((entry) => entry.value)
                          .toList(), // Fixed the days selection
                      frequency: frequency,
                      reminderTimes: selectedTimes
                          .whereType<TimeOfDay>()
                          .toList(), // Convert to List<TimeOfDay>
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
