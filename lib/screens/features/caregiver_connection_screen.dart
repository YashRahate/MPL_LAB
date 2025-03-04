import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_search_screen.dart';

class CaregiverConnectionScreen extends StatefulWidget {
  const CaregiverConnectionScreen({super.key});

  @override
  State<CaregiverConnectionScreen> createState() => _CaregiverConnectionScreenState();
}

class _CaregiverConnectionScreenState extends State<CaregiverConnectionScreen> {
  List<Map<String, dynamic>> _caregivers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCaregivers();
  }

  Future<void> _loadCaregivers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final caregiverDocs = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('caregivers')
            .get();

        final caregivers = await Future.wait(caregiverDocs.docs.map((doc) async {
          final caregiverId = doc.data()['caregiverId'];
          final caregiverData = await FirebaseFirestore.instance
              .collection('users')
              .doc(caregiverId)
              .get();

          return {
            'id': caregiverId,
            'username': caregiverData.data()?['username'] ?? 'Unknown',
            'email': caregiverData.data()?['email'] ?? 'No email',
            'connectedAt': doc.data()['connectedAt'],
          };
        }));

        setState(() {
          _caregivers = caregivers;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error loading caregivers: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Caregivers',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade700,
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        // Navigate to user search screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserSearchScreen(),
                          ),
                        ).then((_) => _loadCaregivers()); // Refresh list when returning
                      },
                      icon: const Icon(Icons.person_add, size: 18),
                      label: const Text('Add', style: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _caregivers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people,
                              size: 80,
                              color: Colors.purple.shade200,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No caregivers connected yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade700,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const UserSearchScreen(),
                                  ),
                                ).then((_) => _loadCaregivers()); // Refresh list when returning
                              },
                              icon: const Icon(Icons.person_add),
                              label: const Text('Add Caregiver', style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _caregivers.length,
                        itemBuilder: (context, index) {
                          final caregiver = _caregivers[index];
                          return Dismissible(
                            key: Key(caregiver['id']),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Remove Caregiver'),
                                  content: Text('Are you sure you want to remove ${caregiver['username']} from your caregivers?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text('Remove'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) async {
                              try {
                                final user = FirebaseAuth.instance.currentUser;
                                if (user != null) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .collection('caregivers')
                                      .doc(caregiver['id'])
                                      .delete();
                                  
                                  setState(() {
                                    _caregivers.removeAt(index);
                                  });
                                }
                              } catch (e) {
                                print("Error removing caregiver: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to remove caregiver')),
                                );
                              }
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.purple.shade200,
                                  child: Text(
                                    caregiver['username'][0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(caregiver['username']),
                                subtitle: Text(caregiver['email']),
                                trailing: IconButton(
                                  icon: const Icon(Icons.message),
                                  onPressed: () {
                                    // Message functionality - to be implemented
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Messaging feature coming soon')),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
  }
}

// Don't forget to add this import at the top of the file
