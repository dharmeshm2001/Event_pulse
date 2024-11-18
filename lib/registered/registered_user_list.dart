// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class RegisteredUsersList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Registered Users"),
//       ),
//       body: StreamBuilder(
//         stream:
//             FirebaseFirestore.instance.collection('registrations').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           var registrations = snapshot.data!.docs;

//           if (registrations.isEmpty) {
//             return Center(
//                 child: Image.asset(
//                   "images/loading.gif",
//                   height: 125.0,
//                   width: 125.0,
//                 ),
//                 Text('No users registered for this event.'));
//           }

//           return ListView.builder(
//             itemCount: registrations.length,
//             itemBuilder: (context, index) {
//               var registration = registrations[index];
//               return UserChatItem(
//                 name: registration['name'],
//                 email: registration['email'],
//                 eventTitle: registration['event_title'],
//                 phone: registration['phone'],
//                 // profilePictureUrl:
//                 //     registration['profileImage'], // Add profile picture URL
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class UserChatItem extends StatelessWidget {
//   final String name;
//   final String email;
//   final String eventTitle;
//   final String phone;

//   UserChatItem({
//     required this.name,
//     required this.email,
//     required this.eventTitle,
//     required this.phone,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: CircleAvatar(),
//       title: Text(name),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Email: $email"),
//           Text("Event name: $eventTitle"),
//           Text("Phone: $phone"),
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisteredUsersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registered Users"),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('registrations').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var registrations = snapshot.data!.docs;

          if (registrations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/cat.webp",
                    height: 125.0,
                    width: 200.0,
                  ),
                  SizedBox(
                      height: 10), // Add some space between the image and text
                  Text('No users registered for this event.'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: registrations.length,
            itemBuilder: (context, index) {
              var registration = registrations[index];
              return UserChatItem(
                name: registration['name'],
                email: registration['email'],
                eventTitle: registration['event_title'],
                phone: registration['phone'],
                // profilePictureUrl:
                //     registration['profileImage'], // Add profile picture URL
              );
            },
          );
        },
      ),
    );
  }
}

class UserChatItem extends StatelessWidget {
  final String name;
  final String email;
  final String eventTitle;
  final String phone;

  UserChatItem({
    required this.name,
    required this.email,
    required this.eventTitle,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Email: $email"),
          Text("Event name: $eventTitle"),
          Text("Phone: $phone"),
        ],
      ),
    );
  }
}
