import 'package:cloud_firestore/cloud_firestore.dart';

class CaregiverService {
  Future<List<String>> getCaregiverEmails(String userId) async {
    final caregiversSnapshot = await FirebaseFirestore.instance
        .collection('caregivers')
        .doc(userId)
        .get();

    if (!caregiversSnapshot.exists) return [];

    final caregiversData = caregiversSnapshot.data();
    final caregiverIds = caregiversData?['caregiver_Id'] ?? [];

    List<String> emails = [];
    for (String caregiverId in caregiverIds) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(caregiverId)
          .get();

      if (userDoc.exists) {
        emails.add(userDoc.data()?['email'] ?? '');
      }
    }
    return emails;
  }
}
