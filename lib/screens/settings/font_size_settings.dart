import 'package:flutter/material.dart';

class FontSizeSettingsScreen extends StatefulWidget {
  const FontSizeSettingsScreen({super.key});

  @override
  State<FontSizeSettingsScreen> createState() => _FontSizeSettingsScreenState();
}

class _FontSizeSettingsScreenState extends State<FontSizeSettingsScreen> {
  double _fontSize = 1.0; // 1.0 is the default scale

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Font Size Settings'),
        backgroundColor: const Color(0xFF283593), // Deep indigo
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adjust Text Size',
              style: TextStyle(
                fontSize: 22 * _fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF283593),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Move the slider to adjust the text size throughout the app.',
              style: TextStyle(
                fontSize: 16 * _fontSize,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    Text(
                      'Preview',
                      style: TextStyle(
                        fontSize: 18 * _fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This is how your text will appear throughout the app.',
                      style: TextStyle(
                        fontSize: 16 * _fontSize,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Small text example',
                      style: TextStyle(
                        fontSize: 14 * _fontSize,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('A', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Slider(
                    min: 0.8,
                    max: 1.5,
                    divisions: 7,
                    value: _fontSize,
                    activeColor: const Color(0xFF283593),
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value;
                      });
                    },
                  ),
                ),
                const Text('A', style: TextStyle(fontSize: 28)),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF283593),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Save font size preference and apply changes
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Font size settings saved'),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text(
                  'Save Settings',
                  style: TextStyle(fontSize: 16 * _fontSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}