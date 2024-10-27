import 'dart:typed_data';
import 'package:chat/models/chat_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ServicesController {
  static final firestore = FirebaseFirestore.instance;

  // * store image to firebase storage
  static Future<String> uploadImage(Uint8List file, String storagePath) async =>
      await FirebaseStorage.instance
          .ref()
          .child(storagePath)
          .putData(file)
          .then((task) => task.ref.getDownloadURL());

  static Future<void> addMessageToChat(
    bool addToChat,
    String receiverId,
    MessageModel message,
  ) async {
    if (addToChat) {
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chat')
          .doc(receiverId)
          .collection('messages')
          .add(message.toJson());

      await firestore
          .collection('users')
          .doc(receiverId)
          .collection('chat')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('messages')
          .add(message.toJson());
    } else {
      await firestore
          .collection('group')
          .doc(receiverId)
          .collection('messages')
          .add(message.toJson());
    }
  }

  static Future<void> updateUserData(Map<String, dynamic> data) async =>
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);

  Future logoutUser() async{
   await FirebaseAuth.instance.signOut();
  }
}
