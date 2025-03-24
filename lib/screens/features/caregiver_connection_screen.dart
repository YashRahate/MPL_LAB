// lib/screens/features/caregiver_connection_screen.dart
import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import 'user_search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CaregiverConnectionScreen extends StatefulWidget {
  const CaregiverConnectionScreen({Key? key}) : super(key: key);

  @override
  _CaregiverConnectionScreenState createState() =>
      _CaregiverConnectionScreenState();
}

class _CaregiverConnectionScreenState extends State<CaregiverConnectionScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _caregivers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCaregivers();
  }

  Future<void> _loadCaregivers() async {
    setState(() => _isLoading = true);
    try {
      final caregivers = await _firestoreService.getCaregivers();
      setState(() => _caregivers = caregivers);
    } catch (e) {
      print("Error loading caregivers: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caregiver Connection')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _caregivers.isEmpty
              ? Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add Caregiver'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserSearchScreen()),
                    ).then((_) => _loadCaregivers()),
                  ),
                )
              : ListView.builder(
                  itemCount: _caregivers.length,
                  itemBuilder: (context, index) {
                    final caregiver = _caregivers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(caregiver['username'][0].toUpperCase()),
                      ),
                      title: Text(caregiver['username']),
                      subtitle: Text(caregiver['email']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            try {
                              // Get the user's caregivers document
                              final caregiverDoc = await FirebaseFirestore
                                  .instance
                                  .collection('caregivers')
                                  .doc(user.uid)
                                  .get();

                              if (caregiverDoc.exists) {
                                // Retrieve the caregiver IDs array
                                final caregivers = List<String>.from(
                                    caregiverDoc.data()?['caregiver_Id'] ?? []);

                                // Remove the selected caregiver from the list
                                caregivers.remove(caregiver['id']);

                                // Update the Firestore document with the new list
                                await FirebaseFirestore.instance
                                    .collection('caregivers')
                                    .doc(user.uid)
                                    .update({'caregiver_Id': caregivers});

                                setState(() {
                                  _caregivers.removeWhere(
                                      (c) => c['id'] == caregiver['id']);
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Caregiver removed successfully')),
                                );
                              }
                            } catch (e) {
                              print("Error removing caregiver: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Failed to remove caregiver')),
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserSearchScreen()),
        ).then((_) => _loadCaregivers()),
      ),
    );
  }
}
