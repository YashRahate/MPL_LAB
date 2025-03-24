import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/health_record_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _auth = FirebaseAuth.instance;

  Future<void> addOrUpdateCaregiver(String caregiverId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("User not logged in");

    final caregiverDoc =
        _firestore.collection('caregivers').doc(currentUser.uid);
    await caregiverDoc.set({
      'user_Id': currentUser.uid,
      'caregiver_Id': FieldValue.arrayUnion([caregiverId]),
    }, SetOptions(merge: true));
  }

  Future<List<Map<String, dynamic>>> getCaregivers() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("User not logged in");

    final caregiverDoc =
        await _firestore.collection('caregivers').doc(currentUser.uid).get();
    if (!caregiverDoc.exists) return [];

    final caregiverIds =
        List<String>.from(caregiverDoc.data()?['caregiver_Id'] ?? []);
    return Future.wait(caregiverIds.map((id) async {
      final userDoc = await _firestore.collection('users').doc(id).get();
      return {
        'id': id,
        'username': userDoc.data()?['username'] ?? 'Unknown',
        'email': userDoc.data()?['email'] ?? 'No email',
      };
    }));
  }

  // Method to get the Firestore collection reference
  CollectionReference getCollectionReference() {
    return _firestore.collection('healthRecords');
  }

  // Save health record to Firestore
  Future<void> saveHealthRecord(HealthRecordModel record) async {
    await getCollectionReference().doc(record.reportId).set(record.toMap());
  }

  // Other Firestore operations can be added here...
}
