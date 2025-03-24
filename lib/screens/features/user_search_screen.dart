// lib/screens/features/user_search_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firestore_service.dart';

class UserSearchScreen extends StatelessWidget {
  const UserSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final FirestoreService _firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Search Users')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Enter email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final email = _emailController.text.trim();
                if (email.isNotEmpty) {
                  try {
                    final userDoc = await FirebaseFirestore.instance
                        .collection('users')
                        .where('email', isEqualTo: email)
                        .get();

                    if (userDoc.docs.isNotEmpty) {
                      final userId = userDoc.docs.first.id;
                      await _firestoreService.addOrUpdateCaregiver(userId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Caregiver added successfully')),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No user found with this email')),
                      );
                    }
                  } catch (e) {
                    print("Error adding caregiver: $e");
                  }
                }
              },
              child: const Text('Add Caregiver'),
            ),
          ],
        ),
      ),
    );
  }
}
