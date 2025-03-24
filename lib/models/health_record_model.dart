// lib/models/health_record_model.dart
class HealthRecordModel {
  String reportId;
  String userId;
  String patientName;
  String dateOfBirth;
  String reportTitle;
  String doctorName;
  String hospitalName;
  String dateUploaded;
  String reportDate;
  String fileUrl;
  String notes;

  HealthRecordModel({
    required this.reportId,
    required this.userId,
    required this.patientName,
    required this.dateOfBirth,
    required this.reportTitle,
    this.doctorName = '',
    this.hospitalName = '',
    required this.dateUploaded,
    required this.reportDate,
    required this.fileUrl,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'report_id': reportId,
      'user_id': userId,
      'patient_name': patientName,
      'date_of_birth': dateOfBirth,
      'report_title': reportTitle,
      'doctor_name': doctorName,
      'hospital_name': hospitalName,
      'date_uploaded': dateUploaded,
      'report_date': reportDate,
      'file_url': fileUrl,
      'notes': notes,
    };
  }
}
