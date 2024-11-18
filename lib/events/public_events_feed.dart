import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/events/event_details.dart';
import 'package:flutter/material.dart';
import 'package:demo/util/publicevents_tile.dart';

class PublicEventsFeed extends StatelessWidget {
  const PublicEventsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('events')
          .where('event_type', isEqualTo: 'Public')
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
                const SizedBox(height: 10),
                const Text('No public events conducted.'),
              ],
            ),
          );
        }

        List<QueryDocumentSnapshot> publicEvents = snapshot.data!.docs;

        return GridView.builder(
          itemCount: publicEvents.length,
          padding: const EdgeInsets.all(5),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 1.5,
          ),
          itemBuilder: (context, index) {
            var eventData = publicEvents[index].data() as Map<String, dynamic>;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetails(
                      eventData: eventData,
                    ),
                  ),
                );
              },
              child: PubliceventsTile(
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
