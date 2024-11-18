import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  Future<void> createNotification({
    required String recipient,
    required String title,
    required String body,
    required String type, // event_creation, message, event_registration
  }) async {
    await FirebaseFirestore.instance.collection('notifications').add({
      'recipient': recipient,
      'title': title,
      'body': body,
      'type': type,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
