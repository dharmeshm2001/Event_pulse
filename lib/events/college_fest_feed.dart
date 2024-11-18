import 'package:demo/events/event_details.dart';
import 'package:demo/util/college_tile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CollegeFestFeed extends StatelessWidget {
  const CollegeFestFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('events')
          .where('event_type', isEqualTo: 'College')
          // Filter by college event type
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/cat.webp",
                  height: 125.0,
                  width: 200,
                ),
                SizedBox(
                    height: 10), // Add some space between the image and text
                Text('Currently no college fest are conducted.'),
              ],
            ),
          );
        }

        // List of college events from Firestore
        List<QueryDocumentSnapshot> collegeEvents = snapshot.data!.docs;

        // Display events in a scrollable list
        return ListView.builder(
          itemCount: collegeEvents.length,
          itemBuilder: (context, index) {
            var eventData = collegeEvents[index].data() as Map<String, dynamic>;

            return GestureDetector(
              onTap: () {
                // Navigate to the event details page when tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetails(
                      eventData:
                          eventData, // Passing event data to the next screen
                    ),
                  ),
                );
              },
              child: CollegeTile(
                eventname: eventData['title'] ?? 'Unnamed Event',
                eventImage:
                    eventData['poster_url'] ?? 'assets/images/Event_poster.jpg',
                eventprice: eventData['event_price'] ?? '0',
              ),
            );
          },
        );
      },
    );
  }
}
