import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static const String _fcmScope =
      'https://www.googleapis.com/auth/firebase.messaging';

  // Your Firebase project ID (from Firebase Console → Project Settings)
  static const String _projectId = 'exam-app-edd3a';

  /// Gets OAuth2 Access Token from service account
  Future<String> _getAccessToken() async {
    try {
      // Load service account JSON from assets
      final serviceAccountJson = await rootBundle.loadString(
        // This file is declared in pubspec.yaml under flutter/assets
        'assets/firebase/exam-app-edd3a-firebase-adminsdk-fbsvc-6c74e6e2a0.json',
      );

      final accountCredentials = ServiceAccountCredentials.fromJson(
        json.decode(serviceAccountJson),
      );

      // Get access token
      final scopes = [_fcmScope];
      final client = http.Client();

      try {
        final accessCredentials =
            await obtainAccessCredentialsViaServiceAccount(
          accountCredentials,
          scopes,
          client,
        );

        return accessCredentials.accessToken.data;
      } finally {
        client.close();
      }
    } catch (e) {
      print('Error getting access token: $e');
      throw Exception('Failed to get access token: $e');
    }
  }

  /// Send notification to specific device using FCM token
  Future<bool> sendNotificationToDevice({
    required String fcmToken,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final accessToken = await _getAccessToken();

      final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send',
      );

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final payload = {
        'message': {
          'token': fcmToken,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': data ?? {},
          'android': {
            'priority': 'high',
            'notification': {
              'sound': 'default',
              'channelId': 'quiz_notifications',
            },
          },
        },
      };

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully!');
        return true;
      } else {
        print('Failed to send notification: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error sending notification: $e');
      return false;
    }
  }

  /// Send notification to a topic (broadcast to all subscribed devices)
  Future<bool> sendNotificationToTopic({
    required String topic,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final accessToken = await _getAccessToken();

      final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send',
      );

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final payload = {
        'message': {
          'topic': topic, // e.g., 'quiz_results'
          'notification': {
            'title': title,
            'body': body,
          },
          'data': data ?? {},
          'android': {
            'priority': 'high',
            'notification': {
              'sound': 'default',
              'channelId': 'quiz_notifications',
            },
          },
        },
      };

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        print('Notification sent to topic successfully!');
        return true;
      } else {
        print('Failed to send notification: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error sending notification: $e');
      return false;
    }
  }

  /// Send notification to multiple devices
  Future<void> sendNotificationToMultipleDevices({
    required List<String> fcmTokens,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    for (String token in fcmTokens) {
      await sendNotificationToDevice(
        fcmToken: token,
        title: title,
        body: body,
        data: data,
      );
      // Add small delay to avoid rate limiting
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  /// Send notification via Node.js API (more secure - service account stays on server)
  /// Set USE_API_MODE = true to use this instead of direct FCM
  /// Make sure your Node.js API server is running on the specified URL
  static const bool USE_API_MODE = false; // Set to true to use API mode
  static const String API_BASE_URL =
      'http://localhost:3000'; // Change to your server URL

  Future<bool> sendNotificationViaAPI({
    required String quizId,
    required String studentId,
    required String studentName,
    required int score,
    required int totalQuestions,
    required int timeTakenSeconds,
  }) async {
    try {
      final url =
          Uri.parse('$API_BASE_URL/api/notifications/send-to-professor');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'quizResult': {
            'quizId': quizId,
            'studentId': studentId,
            'studentName': studentName,
            'score': score,
            'totalQuestions': totalQuestions,
            'timeTakenSeconds': timeTakenSeconds,
          },
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Notification sent via API');
        return true;
      } else {
        print('❌ Failed to send notification via API: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error sending notification via API: $e');
      return false;
    }
  }
}
