import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/models/chat_user.dart';
import 'package:demo/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  //checking if the user is already exist or not
  static Future<bool> userExist() async {
    return (await firestore.collection('user').doc(auth.currentUser!.uid).get())
        .exists;
  }

  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationId(user.uid)}/message/')
        .where('fromId', isEqualTo: APIs.user.uid)
        .where('toId', isEqualTo: user.uid)
        .snapshots();
  }

//for sending messages
//chats(collection)--> conversation_id(doc) -->message (collection) -->message(doc)
  static Future<void> sendMessage(ChatUser ChatUser, String msg) async {
    final time = DateTime.now().microsecondsSinceEpoch.toString();

    final MessageModel message = MessageModel(
        toId: ChatUser.uid,
        msg: msg,
        read: '',
        type: Type.text,
        fromId: user.uid,
        sent: time);
    final ref = firestore
        .collection('chats/${getConversationId(ChatUser.uid)}/message/');
    await ref.doc(time).set(message.toJson());
  }
}
