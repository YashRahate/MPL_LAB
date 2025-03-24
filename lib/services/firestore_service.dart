import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/health_record_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
