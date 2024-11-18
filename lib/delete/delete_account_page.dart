import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteAccountPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteUserData(String uid) async {
    try {
      await _firestore.collection('user').doc(uid).delete();

      QuerySnapshot eventsSnapshot = await _firestore
          .collection('events')
          .where('created_by', isEqualTo: uid)
          .get();

      for (var doc in eventsSnapshot.docs) {
        await _firestore.collection('events').doc(doc.id).delete();
      }

      QuerySnapshot registrationsSnapshot = await _firestore
          .collection('registrations')
          .where('email', isEqualTo: uid)
          .get();

      for (var doc in registrationsSnapshot.docs) {
        await _firestore.collection('registrations').doc(doc.id).delete();
      }
    } catch (e) {
      print("Error deleting user data: $e");
      throw e;
    }
  }

  Future<void> _deleteUserAccount(BuildContext context) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        await _deleteUserData(user.uid);

        await user.delete();

        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text("Your account has been successfully deleted."),
            );
          },
        );

        Navigator.pushReplacementNamed(context, '/login');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Text(
                  'For security reasons, please re-authenticate before deleting your account.',
                ),
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Error deleting account: ${e.message}"),
              );
            },
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Error: ${e.toString()}"),
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("No user is currently logged in."),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            _confirmDeleteDialog(context);
          },
          child: Text("Delete My Account"),
        ),
      ),
    );
  }

  void _confirmDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Account Deletion"),
          content: Text(
              "Are you sure you want to delete your account? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteUserAccount(context);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
