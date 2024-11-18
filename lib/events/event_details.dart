import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/Event_join/event_registration.dart';
import 'package:demo/payment_module/payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventDetails extends StatefulWidget {
  final Map<String, dynamic> eventData;
  const EventDetails({super.key, required this.eventData});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String userRole = '';
  String currentUserEmail = '';
  bool isOrganizer = false;
  bool isRegistered = false;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _fetchUserRoleAndEmail();
    _checkUserRegistration();
    _checkIfLiked();
  }

  Future<void> _fetchUserRoleAndEmail() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();

      if (userDoc.exists) {
        String role = userDoc['role'] ?? '';
        String email = FirebaseAuth.instance.currentUser!.email ?? '';

        setState(() {
          userRole = role;
          currentUserEmail = email;
          isOrganizer = widget.eventData['organizer'] == currentUserEmail;
        });
      }
    } catch (e) {
      print("Error fetching user role and email: $e");
    }
  }

  Future<void> _checkUserRegistration() async {
    try {
      String userEmail = FirebaseAuth.instance.currentUser!.email ?? '';
      QuerySnapshot registrationSnapshot = await FirebaseFirestore.instance
          .collection('registrations')
          .where('event_title', isEqualTo: widget.eventData['title'])
          .where('email', isEqualTo: userEmail)
          .get();

      if (registrationSnapshot.docs.isNotEmpty) {
        setState(() {
          isRegistered = true;
        });
      }
    } catch (e) {
      print("Error checking registration: $e");
    }
  }

  Future<void> _checkIfLiked() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot likeDoc = await FirebaseFirestore.instance
          .collection('event_likes')
          .doc('${widget.eventData['event_title']}_$uid')
          .get();

      if (likeDoc.exists) {
        setState(() {
          isLiked = true;
        });
      }
    } catch (e) {
      print("Error checking if liked: $e");
    }
  }

  Future<void> _toggleLike() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String likeDocId = '${widget.eventData['event_title']}_$uid';
    DocumentReference likeDocRef =
        FirebaseFirestore.instance.collection('event_likes').doc(likeDocId);

    if (isLiked) {
      await likeDocRef.delete();
      setState(() {
        isLiked = false;
      });
    } else {
      await likeDocRef.set({
        'event_title': widget.eventData['event_title'],
        'user_id': uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      setState(() {
        isLiked = true;
      });
    }
  }

  void _onJoinEvent() {
    if (widget.eventData['price'] == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return EventRegistration(
              eventData: widget.eventData,
              role: userRole,
            );
          },
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return Payment(
              eventDoc: widget.eventData,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: 350,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: widget.eventData['poster_url'] != null
                        ? NetworkImage(widget.eventData['poster_url'])
                        : const AssetImage('assets/images/Event_poster.png')
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 50,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.black,
              ),
            ),
            Positioned(
              top: 320,
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                width: MediaQuery.of(context).size.width,
                height: 500,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.eventData['title'] ?? 'Unnamed Event',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          widget.eventData['location'] ?? 'Unknown Location',
                          style:
                              const TextStyle(color: Colors.deepPurpleAccent),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text(
                          'Organizer: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(widget.eventData['organizer'] ??
                            'No Organizer for this event ')
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text(
                          'Event Type: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.eventData['event_type'] ?? 'Public',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Description",
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.eventData['description'] ??
                          'No description available',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: isRegistered ? null : _onJoinEvent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 85,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isRegistered ? "Already Registered" : "Join Event",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
