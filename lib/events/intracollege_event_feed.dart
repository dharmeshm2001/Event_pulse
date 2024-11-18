import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:demo/events/event_details.dart';
import 'package:demo/util/publicevents_tile.dart';

class IntraCollegeEventsPage extends StatefulWidget {
  const IntraCollegeEventsPage({Key? key}) : super(key: key);

  @override
  _IntraCollegeEventsPageState createState() => _IntraCollegeEventsPageState();
}

class _IntraCollegeEventsPageState extends State<IntraCollegeEventsPage> {
  String? currentUserCollege;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserCollege();
  }

  Future<void> _fetchCurrentUserCollege() async {
    try {
      String? userEmail = FirebaseAuth.instance.currentUser!.email;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(userEmail)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          currentUserCollege = userDoc['College'] ?? '';
        });
      }
    } catch (e) {
      print("Error fetching user college: $e");
    }
  }

  Stream<QuerySnapshot> _fetchIntraCollegeEvents() {
    if (currentUserCollege == null) {
      return Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('events')
        .where('college', isEqualTo: currentUserCollege)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return currentUserCollege == null
        ? Center(child: CircularProgressIndicator())
        : StreamBuilder<QuerySnapshot>(
            stream: _fetchIntraCollegeEvents(),
            builder: (context, snapshot) {
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
                      const Text('No Events conducted by your college.'),
                    ],
                  ),
                );
              }

              List<DocumentSnapshot> eventDocs = snapshot.data!.docs;

              return GridView.builder(
                itemCount: eventDocs.length,
                padding: const EdgeInsets.all(5),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.5,
                ),
                itemBuilder: (context, index) {
                  var eventData =
                      eventDocs[index].data() as Map<String, dynamic>;

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
                      eventImage: eventData['poster_url'] ??
                          'assets/images/Event_poster.jpg',
                      eventprice: (eventData['price'] != null)
                          ? eventData['price'].toString()
                          : '0',
                    ),
                  );
                },
              );
            },
          );
  }
}
