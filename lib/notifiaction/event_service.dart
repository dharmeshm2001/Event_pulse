import 'package:cloud_firestore/cloud_firestore.dart';

import 'notification_service.dart';

class EventService {
  final NotificationService _notificationService = NotificationService();

  Future<void> registerForEvent(
      String eventId, String organizerEmail, String userEmail) async {
    // Save registration to Firestore (this logic is simplified)
    await FirebaseFirestore.instance.collection('registrations').add({
      'event_title': eventId,
      'user': userEmail,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Notify the organizer of the new registration
    await _notificationService.createNotification(
      recipient: organizerEmail,
      title: 'New Registration for Your Event',
      body: '$userEmail has registered for your event',
      type: 'event_registration',
    );
  }
}
