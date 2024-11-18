import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/co_ordinator/cohome.dart';
import 'package:demo/screens/splash_screen.dart';
import 'package:demo/student/student_home.dart';
import 'package:demo/volunteer/voluntter_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  // Function to fetch the user's role from Firestore
  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();
      if (userDoc.exists) {
        return userDoc['role'] as String?;
      }
    } catch (e) {
      print("Error fetching user role: $e");
    }
    return null;
  }

  Widget navigateBasedOnRole(String? role) {
    if (role == 'Coordinator') {
      return const Cohome();
    } else if (role == 'Volunteer') {
      return const VolunteerHome();
    } else if (role == 'Student') {
      return const StudentHome();
    } else {
      return const SplashScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<String?>(
              future: getUserRole(snapshot.data!.uid),
              builder: (context, AsyncSnapshot<String?> roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (roleSnapshot.hasError) {
                  return Center(child: Text('Error: ${roleSnapshot.error}'));
                }

                return navigateBasedOnRole(roleSnapshot.data);
              },
            );
          }

          return const SplashScreen();
        },
      ),
    );
  }
}
