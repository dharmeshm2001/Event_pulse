import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    // Fetch the current user's email
    currentUserEmail = _auth.currentUser?.email;
  }

  // Fetch events created by the current user
  Stream<QuerySnapshot> _fetchUserCreatedEvents() {
    return _firestore
        .collection('events')
        .where('organizer', isEqualTo: currentUserEmail)
        .snapshots();
  }

  // Fetch registrations for events
  Stream<QuerySnapshot> _fetchUserRegistrations() {
    return _firestore
        .collection('registrations')
        .where('email', isEqualTo: currentUserEmail)
        .snapshots();
  }

  // Fetch the total number of registrations for an event
  Future<int> _fetchEventRegistrationCount(String eventTitle) async {
    QuerySnapshot registrationSnapshot = await _firestore
        .collection('registrations')
        .where('event_title', isEqualTo: eventTitle)
        .get();
    return registrationSnapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Notifications")),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Notifications for created events
            Center(child: Text("Your Created Events:")),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _fetchUserCreatedEvents(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error fetching events");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text("You have not created any events.");
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var eventData = snapshot.data!.docs[index].data() as Map;
                    String eventTitle = eventData['title'];
                    DateTime endDate =
                        (eventData['end_date'] as Timestamp).toDate();

                    return ListTile(
                      title: Text("Event: $eventTitle"),
                      subtitle: Text("End Date: ${endDate.toLocal()}"),
                      trailing: FutureBuilder<int>(
                        future: _fetchEventRegistrationCount(eventTitle),
                        builder: (context, registrationSnapshot) {
                          if (registrationSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          int registrationsLeft = 50 -
                              registrationSnapshot
                                  .data!; // Assuming max limit is 50
                          return Text("Registrations left: $registrationsLeft");
                        },
                      ),
                    );
                  },
                );
              },
            ),

            SizedBox(
              height: 30,
            ),

            // Notifications for registered events
            Text("Your Registered Events:"),
            StreamBuilder<QuerySnapshot>(
              stream: _fetchUserRegistrations(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Error fetching registrations");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text("You are not registered for any events.");
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var registrationData =
                        snapshot.data!.docs[index].data() as Map;
                    String eventTitle = registrationData['event_title'];
                    String organizerEmail = registrationData['email'];
                    String registrationName = registrationData['name'];

                    return ListTile(
                      title: Text("Event: $eventTitle"),
                      subtitle: Text("Registered as: $registrationName"),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
