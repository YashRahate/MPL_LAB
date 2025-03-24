import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'caregiver_service.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyAlertService {
  final CaregiverService _caregiverService = CaregiverService();

  Future<void> sendEmergencyAlert() async {
    try {
      // Get current user
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in. Please sign in to continue.');
      }

      // Get caregiver emails
      final List<String> caregiversEmails =
          await _caregiverService.getCaregiverEmails(currentUser.uid);

      if (caregiversEmails.isEmpty) {
        throw Exception('No caregivers registered. Please add caregivers to your account.');
      }

      // Get current location
      final Position position = await _getCurrentLocation();

      // Send emails to caregivers
      await _sendEmergencyEmails(
          caregiversEmails, currentUser.displayName ?? 'User', position);

      // Optionally, log the emergency event
      await _logEmergencyEvent(currentUser.uid, position);
    } catch (e) {
      print('Emergency alert error: $e');
      rethrow;
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check location services
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable them.');
    }

    // Check and request permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied. Please enable them in settings.');
    }

    // Get current location
    return await Geolocator.getCurrentPosition();
  }

Future<void> _sendEmergencyEmails(
    List<String> caregiversEmails, String userName, Position position) async {
  try {
    print('Preparing to send emergency emails...');
    print('Recipients: ${caregiversEmails.join(",")}');
    print('Location: Latitude ${position.latitude}, Longitude ${position.longitude}');

    // Email content
    final String subject = 'Emergency Alert: Immediate Assistance Required';
    final String body =
        'Dear Caregiver,\n\nThis is an emergency alert from $userName.\n\n'
        'Current location:\n'
        'Latitude: ${position.latitude}\n'
        'Longitude: ${position.longitude}\n\n'
        'Please respond as soon as possible.\n\n'
        'Thank you.';

    // Create the email URI
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: caregiversEmails.join(','),
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    // Check if the email client can be launched
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw Exception('Could not launch email client. Please try again.');
    }
  } catch (e) {
    print('Error sending emails: $e');
  }
}



  Future<void> _logEmergencyEvent(String userId, Position position) async {
    // Log emergency event in Firestore
    await FirebaseFirestore.instance.collection('emergency_logs').add({
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
      'location': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
    });
  }
}
