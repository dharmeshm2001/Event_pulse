import 'package:demo/registered/registered_user_list.dart';
import 'package:demo/util/event_tile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsFeed extends StatelessWidget {
  final String userEmail;

  const EventsFeed({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('events')
          .where('organizer', isEqualTo: userEmail)
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
                const Text('You have not created any Events :(.'),
              ],
            ),
          );
        }
        List<QueryDocumentSnapshot> userEvents = snapshot.data!.docs;

        return GridView.builder(
          itemCount: userEvents.length,
          padding: const EdgeInsets.all(5),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 1.5,
          ),
          itemBuilder: (context, index) {
            var eventData = userEvents[index].data() as Map<String, dynamic>;
            // String eventId =
            //     userEvents[index].id; // Event ID for querying registrations

            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisteredUsersList()));
              },
              child: EventTile(
                eventname: eventData['title'] ?? 'Unnamed Event',
                eventImage:
                    eventData['poster_url'] ?? 'assets/images/Event_poster.jpg',
                eventprice: eventData['price'].toString(),
              ),
            );
          },
        );
      },
    );
  }

  void _showRegisteredUsersDialog(BuildContext context, String eventId) async {
    try {
      int registeredUsersCount = await _getRegisteredUsersCount(eventId);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Registered Users'),
            content: Text('Number of users registered: $registeredUsersCount'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to load registered users. Error: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<int> _getRegisteredUsersCount(String eventId) async {
    try {
      QuerySnapshot registrationsSnapshot = await FirebaseFirestore.instance
          .collection('registrations')
          .where('event_title', isEqualTo: eventId)
          .get();

      return registrationsSnapshot.docs.length;
    } catch (e) {
      throw 'Error fetching registrations: $e';
    }
  }
}
