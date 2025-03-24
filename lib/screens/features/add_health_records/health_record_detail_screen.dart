import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class HealthRecordDetailScreen extends StatelessWidget {
  final Map<String, dynamic> record;

  const HealthRecordDetailScreen({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Record Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Name
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: const Text('Patient Name'),
                  subtitle: Text(record['patient_name'] ?? 'N/A'),
                ),
                const Divider(),

                // Date of Birth
                ListTile(
                  leading: const Icon(Icons.cake, color: Colors.pink),
                  title: const Text('Date of Birth'),
                  subtitle: Text(record['date_of_birth'] ?? 'N/A'),
                ),
                const Divider(),

                // Report Title
                ListTile(
                  leading: const Icon(Icons.description, color: Colors.green),
                  title: const Text('Report Title'),
                  subtitle: Text(record['report_title'] ?? 'N/A'),
                ),
                const Divider(),

                // Doctor
                ListTile(
                  leading: const Icon(Icons.local_hospital, color: Colors.red),
                  title: const Text('Doctor'),
                  subtitle: Text(record['doctor_name'] ?? 'N/A'),
                ),
                const Divider(),

                // Hospital
                ListTile(
                  leading: const Icon(Icons.apartment, color: Colors.purple),
                  title: const Text('Hospital'),
                  subtitle: Text(record['hospital_name'] ?? 'N/A'),
                ),
                const Divider(),

                // Notes
                ListTile(
                  leading: const Icon(Icons.notes, color: Colors.orange),
                  title: const Text('Notes'),
                  subtitle: Text(record['notes'] ?? 'N/A'),
                ),
                const Divider(),

                // File Handler
                if (record['file_url'] != null)
                  GestureDetector(
                    onTap: () => _handleFileTap(context, record['file_url']),
                    child: _buildFilePreview(record['file_url']),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilePreview(String fileUrl) {
    if (fileUrl.endsWith('.png') || fileUrl.endsWith('.jpg') || fileUrl.endsWith('.jpeg')) {
      // Image preview
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          fileUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Text('Error loading image'),
        ),
      );
    } else if (fileUrl.endsWith('.pdf')) {
      // PDF preview
      return Container(
        height: 200,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.picture_as_pdf, size: 50, color: Colors.red),
        ),
      );
    } else {
      // Unsupported file type
      return Container(
        height: 200,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.insert_drive_file, size: 50, color: Colors.blue),
        ),
      );
    }
  }

  void _handleFileTap(BuildContext context, String fileUrl) {
    if (fileUrl.endsWith('.png') || fileUrl.endsWith('.jpg') || fileUrl.endsWith('.jpeg')) {
      // Open image in full screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenImageViewer(imageUrl: fileUrl),
        ),
      );
    } else if (fileUrl.endsWith('.pdf')) {
      // Open PDF in full screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenPdfViewer(pdfUrl: fileUrl),
        ),
      );
    } else {
      // Unsupported file type
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unsupported file format')),
      );
    }
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Image Viewer'),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 3.0,
          child: Image.network(
            imageUrl,
            errorBuilder: (context, error, stackTrace) =>
                const Text('Error loading image', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

class FullScreenPdfViewer extends StatelessWidget {
  final String pdfUrl;

  const FullScreenPdfViewer({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: pdfUrl,
        onError: (error) {
          debugPrint('Error loading PDF: $error');
        },
        onRender: (_pages) {
          debugPrint('Rendered $_pages pages');
        },
        onPageChanged: (page, total) {
          debugPrint('Page changed: $page/$total');
        },
      ),
    );
  }
}
