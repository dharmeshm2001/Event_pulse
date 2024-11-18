import 'package:demo/co_ordinator/codrawer.dart';
import 'package:demo/delete/delete_account_page.dart';
import 'package:demo/events/college_fest_feed.dart';
import 'package:demo/events/cor_Create_Event.dart';
import 'package:demo/events/events_feed.dart';
import 'package:demo/events/public_events_feed.dart';
import 'package:demo/notifiaction/notification_page.dart';
import 'package:demo/registered/user_registered_events.dart';
import 'package:demo/screens/profile.dart';
import 'package:demo/util/my_tab.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Cohome extends StatefulWidget {
  const Cohome({super.key});

  @override
  State<Cohome> createState() => _HomeState();
}

class _HomeState extends State<Cohome> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Profile()),
    );
  }

  void goToCreateEvent() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CorCreateEvent()));
  }

  void goToyourgroup() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CorCreateEvent()));
  }

  void deleteAccount() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DeleteAccountPage()));
  }

  List<Widget> myTabs = const [
    MyTab(
      IconPath: 'assets/images/event_tab.png',
      IconName: 'Public',
    ),
    MyTab(
      IconPath: 'assets/images/College_fest.png',
      IconName: 'Fest',
    ),
    MyTab(
      IconPath: 'assets/images/your_event.png',
      IconName: 'Events',
    ),
    MyTab(
      IconPath: 'assets/images/registered_events.png',
      IconName: 'Registered',
    ),
  ];

  List<Widget> imageSliders = [
    Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child:
              Image.asset('assets/images/participate.jpg', fit: BoxFit.cover),
        ),
        const Positioned(
          bottom: 10.0,
          left: 10.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Participate and explore  events ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              Text(
                '',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Image.asset('assets/images/fest_slide.jpg', fit: BoxFit.cover),
        ),
        const Positioned(
          bottom: 10.0,
          left: 10.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Get ready for the most epic college fests',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              Text(
                ' ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Image.asset('assets/images/create_events1.jpg',
              fit: BoxFit.cover),
        ),
        const Positioned(
          bottom: 10.0,
          left: 10.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Create and manage your events ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              Text(
                '',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Event Pulse",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationPage()));
              },
            ),
          ],
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawer: Codrawer(
          onProfileTap: goToProfilePage,
          onSignOut: signOut,
          onCreateEvent: goToCreateEvent,
          onDelete: deleteAccount,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              CarouselSlider(
                items: imageSliders,
                options: CarouselOptions(
                  height: 130,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              TabBar(tabs: myTabs),
              Expanded(
                  child: TabBarView(
                children: [
                  const PublicEventsFeed(),
                  const CollegeFestFeed(),
                  EventsFeed(userEmail: currentUser.email!),
                  UserRegisteredEvents()
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationsPage {}
