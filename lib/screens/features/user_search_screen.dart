import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String email) async {
    if (email.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      // Search for users with matching email
      final results = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isGreaterThanOrEqualTo: email)
          .where('email', isLessThanOrEqualTo: email + '\uf8ff')
          .get();

      setState(() {
        _searchResults = results.docs
            .map((doc) => {
                  'id': doc.id,
                  'username': doc.data()['username'] ?? 'No name',
                  'email': doc.data()['email'] ?? 'No email',
                })
            .toList();
        _isSearching = false;
      });
    } catch (e) {
      print("Error searching users: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error searching users: $e")),
      );
      setState(() {
        _isSearching = false;
      });
    }
  }

  void _addCaregiverConnection(String caregiverId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Add to current user's caregivers collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('caregivers')
            .doc(caregiverId)
            .set({
          'connected': true,
          'connectedAt': FieldValue.serverTimestamp(),
          'caregiverId': caregiverId,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Caregiver added successfully!')),
        );

        // Go back to the previous screen
        Navigator.pop(context);
      }
    } catch (e) {
      print("Error adding caregiver: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding caregiver: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Caregivers'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by email',
                hintText: 'Enter email address',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _searchUsers('');
                  },
                ),
              ),
              onChanged: (value) {
                _searchUsers(value);
              },
            ),
            const SizedBox(height: 16),
            _isSearching
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: _searchResults.isEmpty
                        ? const Center(
                            child: Text(
                              'No users found. Try searching by email.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final user = _searchResults[index];
                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.purple.shade200,
                                    child: Text(
                                      user['username'][0].toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(user['username']),
                                  subtitle: Text(user['email']),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.add_circle),
                                    color: Colors.purple.shade700,
                                    onPressed: () {
                                      _addCaregiverConnection(user['id']);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}