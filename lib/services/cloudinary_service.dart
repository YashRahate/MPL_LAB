// lib/services/cloudinary_service.dart
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudinaryService {
  final String apiKey = '998577879453677';
  final String cloudName = 'dnxdu9geb';
  final String uploadPreset = 'medical_reports';

  Future<String?> uploadFile({
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    try {
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/auto/upload');
      final request = http.MultipartRequest('POST', uri);

      request.fields['upload_preset'] = uploadPreset;
      request.fields['api_key'] = apiKey;
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
        ),
      );

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseData);
        return jsonResponse['secure_url']; // File URL
      } else {
        print('Failed to upload file: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }
}
