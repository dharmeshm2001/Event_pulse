import 'package:demo/events/college_fest_feed.dart';
import 'package:demo/events/intracollege_event_feed.dart';
import 'package:demo/events/public_events_feed.dart';
import 'package:demo/notifiaction/notification_page.dart';
import 'package:demo/registered/user_registered_events.dart';
import 'package:demo/screens/profile.dart';
import 'package:demo/student/student_drawer.dart';
import 'package:demo/util/my_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _HomeState();
}

class _HomeState extends State<StudentHome> {
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

  List<Widget> myTabs = const [
    // public event tabs
    MyTab(
      IconPath: 'assets/images/event_tab.png',
      IconName: 'Public',
    ),
    //college event tabs
    MyTab(
      IconPath: 'assets/images/College_fest.png',
      IconName: 'Fest',
    ),
    MyTab(
      IconPath: 'assets/images/Intracollege.png',
      IconName: 'College',
    ),
    //your event tabs
    MyTab(
      IconPath: 'assets/images/registered_events.png',
      IconName: 'Registered',
    ),
    //your club tabs
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
                // Handle notification icon press
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationPage()));
              },
            ),
          ],
          iconTheme: IconThemeData(color: Colors.white),
        ),
        drawer: StudentDrawer(
          onProfileTap: goToProfilePage,
          onSignOut: signOut,
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
                  // pauseAutoPlayOnTouch: Duration(seconds: 10),
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              //tab bar
              TabBar(tabs: myTabs),
              Expanded(
                  child: TabBarView(
                children: [
                  //public event page
                  const PublicEventsFeed(),

                  //college fest  event feed page
                  const CollegeFestFeed(),

                  // IntracollegeEventFeed(),
                  const IntraCollegeEventsPage(),

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
