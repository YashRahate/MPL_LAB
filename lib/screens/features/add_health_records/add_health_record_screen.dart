import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart'; // For Firebase Authentication
import '../../../services/cloudinary_service.dart';
import '../../../services/firestore_service.dart';
import '../../../models/health_record_model.dart';

class AddHealthRecordScreen extends StatefulWidget {
  @override
  _AddHealthRecordScreenState createState() => _AddHealthRecordScreenState();
}

class _AddHealthRecordScreenState extends State<AddHealthRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cloudinaryService = CloudinaryService();
  final _firestoreService = FirestoreService();

  String? _fileName;
  Uint8List? _fileBytes;
  String? _fileUrl;

  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _reportTitleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _reportDateController = TextEditingController();
  bool _isUploading = false;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        _fileBytes = result.files.single.bytes;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _uploadAndSave() async {
    if (_formKey.currentState!.validate()) {
      if (_fileBytes == null || _fileName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a file to upload.')),
        );
        return;
      }

      setState(() {
        _isUploading = true;
      });

      // Upload to Cloudinary
      _fileUrl = await _cloudinaryService.uploadFile(
        fileName: _fileName!,
        fileBytes: _fileBytes!,
      );

      setState(() {
        _isUploading = false;
      });

      if (_fileUrl != null) {
        // Fetch current user ID from Firebase Authentication
        final user = FirebaseAuth.instance.currentUser;

        // Generate a new document ID for Firestore
        final newDocRef = _firestoreService.getCollectionReference().doc();

        // Save to Firestore
        final healthRecord = HealthRecordModel(
          reportId: newDocRef.id, // Use the generated document ID
          userId: user?.uid ?? 'unknown', // Use logged-in user's UID
          patientName: _patientNameController.text,
          dateOfBirth: _dateOfBirthController.text,
          reportTitle: _reportTitleController.text,
          doctorName: _doctorNameController.text.isNotEmpty
              ? _doctorNameController.text
              : 'Unknown Doctor',
          hospitalName: _hospitalNameController.text.isNotEmpty
              ? _hospitalNameController.text
              : 'Unknown Hospital',
          dateUploaded: DateTime.now().toString(),
          reportDate: _reportDateController.text,
          fileUrl: _fileUrl!,
          notes: _notesController.text,
        );

        await _firestoreService.saveHealthRecord(healthRecord);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Record uploaded successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload file.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Health Record')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _patientNameController,
                decoration: InputDecoration(labelText: 'Patient Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _dateOfBirthController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, _dateOfBirthController),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _reportTitleController,
                decoration: InputDecoration(labelText: 'Report Title'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _doctorNameController,
                decoration: InputDecoration(labelText: 'Doctor Name (Optional)'),
              ),
              TextFormField(
                controller: _hospitalNameController,
                decoration: InputDecoration(labelText: 'Hospital Name (Optional)'),
              ),
              TextFormField(
                controller: _reportDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Report Date',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, _reportDateController),
                  ),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: 'Notes'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: Icon(Icons.upload),
                label: Text('Select File'),
              ),
              if (_fileName != null) Text('File: $_fileName'),
              if (_isUploading) CircularProgressIndicator(),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _uploadAndSave,
                child: Text('Upload and Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
