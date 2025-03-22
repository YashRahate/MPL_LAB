import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MedicationRemindersScreen extends StatefulWidget {
  const MedicationRemindersScreen({super.key});

  @override
  State<MedicationRemindersScreen> createState() =>
      _MedicationRemindersScreenState();
}

class _MedicationRemindersScreenState extends State<MedicationRemindersScreen> {
  final _auth = FirebaseAuth.instance;
  late final String userId;

  @override
  void initState() {
    super.initState();
    userId = _auth.currentUser?.uid ?? '';
  }

  Future<void> markAsTaken(
    String documentId,
    int currentInventory,
    Map<String, dynamic> scheduleItem,
    List history,
  ) async {
    final now = DateTime.now();
    final scheduledTime = DateFormat('hh:mm a').parse(scheduleItem['time']);
    final currentTime = DateTime(
        now.year, now.month, now.day, scheduledTime.hour, scheduledTime.minute);
    final difference = now.difference(currentTime).inMinutes.abs();

    if (difference > 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'You can only mark medication within 30 minutes of the scheduled time.')),
      );
      return;
    }

    final hasAlreadyMarked = history.any((entry) =>
        entry['date'] == DateFormat('yyyy-MM-dd').format(now) &&
        entry['time'] == scheduleItem['time'] &&
        entry['status'] == 'completed');
    if (hasAlreadyMarked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('This medication has already been marked as taken.')),
      );
      return;
    }

    if (currentInventory <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Not enough inventory to mark this reminder as taken.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('medications')
          .doc(documentId)
          .update({
        "current_no_of_inventory": currentInventory - 1,
        "schedule": FieldValue.arrayUnion([
          {"time": scheduleItem['time'], "status": true}
        ]),
        "updatedAt": now.toIso8601String(),
        "history": FieldValue.arrayUnion([
          {
            "date": DateFormat('yyyy-MM-dd').format(now),
            "time": scheduleItem['time'],
            "status": "completed",
          }
        ]),
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reminder marked as taken')));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  Future<void> undoMarkAsTaken(
    String documentId,
    Map<String, dynamic> scheduleItem,
    List history,
    BuildContext context,
  ) async {
    final now = DateTime.now();

    // Ensure the predicate explicitly returns a boolean value.
    final latestEntry = history.lastWhere(
      (entry) =>
          entry['status'] == 'completed' &&
          entry['time'] == scheduleItem['time'],
      orElse: () => null,
    );

    if (latestEntry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No matching entry found to undo.')),
      );
      return;
    }

    final timestamp = latestEntry['timestamp'];
    if (timestamp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Timestamp is missing. Undo not allowed.'),
        ),
      );
    } else {
      try {
        final parsedTimestamp = DateTime.parse(timestamp);
        if (now.difference(parsedTimestamp).inMinutes > 30) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Undo is only allowed within 30 minutes of marking as taken.',
              ),
            ),
          );
        } else {
          // Proceed with the undo operation.
          // Your undo logic here.
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid timestamp format. Undo not allowed.'),
          ),
        );
        // Optionally log the error for debugging.
        debugPrint('Error parsing timestamp: $e');
      }
    }

    try {
      await FirebaseFirestore.instance
          .collection('medications')
          .doc(documentId)
          .update({
        "schedule": FieldValue.arrayRemove([
          {"time": scheduleItem['time'], "status": true}
        ]),
        "history": FieldValue.arrayRemove([latestEntry]),
        "current_no_of_inventory": FieldValue.increment(1),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Undo successful')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  Future<void> deleteReminder(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('medications')
          .doc(documentId)
          .update({
        "isActive": false,
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Reminder deleted')));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Reminders'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/add_medications');
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Add Medication',
                style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('medications')
            .where('userId', isEqualTo: userId)
            .where('isActive', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No reminders available.'));
          }
          final reminders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              final reminder = reminders[index];
              final data = reminder.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(data['name']?.join(', ') ?? 'Unnamed Medication'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dosage: ${data['dosage']}'),
                      Text('Frequency: ${data['frequency']} times/day'),
                      Text(
                          'Schedule: ${data['schedule']?.map((e) => e['time'])?.join(', ') ?? ''}'),
                      Text('Inventory: ${data['current_no_of_inventory']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final scheduleItem = data['schedule'].firstWhere(
                            (item) => !item['status'],
                            orElse: () => null,
                          );
                          if (scheduleItem != null) {
                            markAsTaken(
                                reminder.id,
                                data['current_no_of_inventory'],
                                scheduleItem,
                                data['history']);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Mark as Taken'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.undo, color: Colors.orange),
                        onPressed: () {
                          // Safely find the last schedule item with 'status' as true.
                          final scheduleItem = data['schedule'].lastWhere(
                            (item) =>
                                item['status'] ==
                                true, // Explicitly check for true.
                            orElse: () =>
                                null, // Provide a fallback in case no item matches.
                          );

                          if (scheduleItem != null) {
                            // Call undoMarkAsTaken with the required parameters.
                            undoMarkAsTaken(
                              reminder.id,
                              scheduleItem,
                              data['history'],
                              context, // Pass the context if needed.
                            );
                          } else {
                            // Show a message if no matching item is found.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('No schedule item found to undo.')),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteReminder(reminder.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
