import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserRegisteredEvents extends StatefulWidget {
  const UserRegisteredEvents({Key? key}) : super(key: key);

  @override
  _UserRegisteredEventsState createState() => _UserRegisteredEventsState();
}

class _UserRegisteredEventsState extends State<UserRegisteredEvents> {
  String? currentUserEmail;
  List<Map<String, dynamic>> registeredEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserAndEvents();
  }

  Future<void> _fetchCurrentUserAndEvents() async {
    try {
      currentUserEmail = FirebaseAuth.instance.currentUser!.email;

      if (currentUserEmail != null) {
        await _fetchRegisteredEvents();
      }
    } catch (e) {
      print("Error fetching user or events: $e");
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchRegisteredEvents() async {
    QuerySnapshot registrationsSnapshot = await FirebaseFirestore.instance
        .collection('registrations')
        .where('email', isEqualTo: currentUserEmail)
        .get();

    List<QueryDocumentSnapshot> registrationDocs = registrationsSnapshot.docs;

    for (var registrationDoc in registrationDocs) {
      String eventTitle = registrationDoc['event_title'];

      QuerySnapshot eventsSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('title', isEqualTo: eventTitle)
          .get();

      if (eventsSnapshot.docs.isNotEmpty) {
        registeredEvents
            .add(eventsSnapshot.docs.first.data() as Map<String, dynamic>);
      }
    }

    setState(() {}); // Trigger UI update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : registeredEvents.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/cat.webp",
                        height: 125.0,
                        width: 200.0,
                      ),
                      SizedBox(height: 10),
                      Text('You have not registered for any event :('),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: registeredEvents.length,
                  itemBuilder: (context, index) {
                    var eventData = registeredEvents[index];
                    return ListTile(
                      leading: eventData['poster_url'] != null
                          ? Image.network(eventData['poster_url'],
                              width: 50, height: 50)
                          : const Icon(Icons.event),
                      title: Text(eventData['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(eventData['description']),
                          Text('Location: ${eventData['location']}'),
                          Text('Price: ₹${eventData['price']}'),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
