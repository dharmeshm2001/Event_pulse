import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as Path;

class DataControl extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  DocumentSnapshot? myDocument;

  var allUsers = <DocumentSnapshot>[].obs;
  var filteredUsers = <DocumentSnapshot>[].obs;
  var allEvents = <DocumentSnapshot>[].obs;
  var filteredEvents = <DocumentSnapshot>[].obs;
  var joinedEvents = <DocumentSnapshot>[].obs;

  var isEventsLoading = false.obs;
  var isUsersLoading = false.obs;
  var isMessageSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    getMyDocument();
    getUsers();
    getEvents();
  }

  // Fetch current user's document from Firestore
  void getMyDocument() {
    FirebaseFirestore.instance
        .collection('user')
        .doc(auth.currentUser?.uid)
        .snapshots()
        .listen((event) {
      myDocument = event;
    });
  }

  // Fetch users from Firestore
  void getUsers() {
    isUsersLoading(true);
    FirebaseFirestore.instance.collection('user').snapshots().listen((event) {
      allUsers.value = event.docs;
      filteredUsers.value.assignAll(allUsers);
      isUsersLoading(false);
    });
  }

  // Fetch events from Firestore
  void getEvents() {
    isEventsLoading(true);

    FirebaseFirestore.instance.collection('events').snapshots().listen((event) {
      allEvents.assignAll(event.docs);
      filteredEvents.assignAll(event.docs);

      joinedEvents.value = allEvents.where((e) {
        List joinedIds = e.get('joined');
        return joinedIds.contains(auth.currentUser?.uid);
      }).toList();

      isEventsLoading(false);
    });
  }

  // Send a message to Firebase Firestore
  Future<void> sendMessageToFirebase({
    required Map<String, dynamic> data,
    required String lastMessage,
    required String groupId,
  }) async {
    isMessageSending(true);

    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(groupId)
          .collection('chatroom')
          .add(data);
      await FirebaseFirestore.instance.collection('chats').doc(groupId).set({
        'lastMessage': lastMessage,
        'groupId': groupId,
        'group': groupId.split('-'),
      }, SetOptions(merge: true));
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e',
          colorText: Colors.white, backgroundColor: Colors.red);
    } finally {
      isMessageSending(false);
    }
  }

  // Create a notification
  Future<void> createNotification(String recUid) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(recUid)
          .collection('myNotifications')
          .add({
        'message': "Send you a message.",
        'image': myDocument?.get('image') ?? '',
        'name':
            "${myDocument?.get('first') ?? ''} ${myDocument?.get('last') ?? ''}",
        'time': DateTime.now()
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to create notification: $e',
          colorText: Colors.white, backgroundColor: Colors.red);
    }
  }

  // Upload an image to Firebase Storage
  Future<String> uploadImageToFirebase(File file) async {
    try {
      String fileName = Path.basename(file.path);
      Reference reference =
          FirebaseStorage.instance.ref().child('myfiles/$fileName');
      UploadTask uploadTask = reference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image: $e',
          colorText: Colors.white, backgroundColor: Colors.red);
      return '';
    }
  }

  // Upload a thumbnail to Firebase Storage
  Future<String> uploadThumbnailToFirebase(Uint8List file) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference reference =
          FirebaseStorage.instance.ref().child('myfiles/$fileName.jpg');
      UploadTask uploadTask = reference.putData(file);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload thumbnail: $e',
          colorText: Colors.white, backgroundColor: Colors.red);
      return '';
    }
  }

  // Create an event in Firestore
  Future<bool> createEvent(Map<String, dynamic> eventData) async {
    try {
      await FirebaseFirestore.instance.collection('events').add(eventData);
      Get.snackbar('Event Uploaded', 'Event is uploaded successfully.',
          colorText: Colors.white, backgroundColor: Colors.blue);
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload event: $e',
          colorText: Colors.white, backgroundColor: Colors.red);
      return false;
    }
  }
}
