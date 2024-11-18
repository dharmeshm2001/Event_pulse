import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:demo/Controls/text_box.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final CurrentUser = FirebaseAuth.instance.currentUser!;
  final userCollections = FirebaseFirestore.instance.collection('user');

  // Image picker
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.black),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: const TextStyle(color: Colors.black)),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context)),
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => Navigator.of(context).pop(newValue),
          )
        ],
      ),
    );

    // Update Firebase if the new value is not empty
    if (newValue.trim().isNotEmpty) {
      await userCollections.doc(CurrentUser.email).update({field: newValue});
    }
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _uploadImageToFirebase(_image!);
    }
  }

  // Upload image to Firebase
  Future<void> _uploadImageToFirebase(File image) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child('${CurrentUser.email}.jpg');

    // Upload image to Firebase Storage
    await storageRef.putFile(image);

    // Get the download URL and save it in Firestore
    String downloadUrl = await storageRef.getDownloadURL();
    await userCollections.doc(CurrentUser.email).update({
      'profileImage': downloadUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Your Profile ", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("user")
            .doc(CurrentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          // Get user data
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 120,
                    backgroundImage: userData.containsKey('profileImage') &&
                            userData['profileImage'] != null
                        ? NetworkImage(userData['profileImage'])
                        : const AssetImage('assets/images/avatar.png')
                            as ImageProvider,
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  CurrentUser.email!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 50),
                const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Text(
                    "My Details",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                MyTextBox(
                  text: userData['username'],
                  sectionName: 'Username',
                  onPressed: () => editField('username'),
                ),
                MyTextBox(
                  text: userData['Bio'],
                  sectionName: 'Bio',
                  onPressed: () => editField('Bio'),
                ),
                if (userData['role'] == 'Student' ||
                    userData['role'] == 'Coordinator')
                  MyTextBox(
                    text: userData['College'] ?? 'N/A',
                    sectionName: 'College',
                    onPressed: () => editField('College'),
                  ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
