import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:chat/models/chat_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chat/models/group_model.dart';
import 'package:uuid/uuid.dart';

class ServicesController {
  static final firestore = FirebaseFirestore.instance;

  // * store image to firebase storage
  static Future<String> uploadImage(Uint8List file, String storagePath) async =>
      await FirebaseStorage.instance
          .ref()
          .child(storagePath)
          .putData(file)
          .then((task) => task.ref.getDownloadURL());

  static Future<String> uploadAudio(File file, String storagePath) async =>
      await FirebaseStorage.instance
          .ref()
          .child(storagePath)
          .putFile(file)
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
          .collection('groups')
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

  // static Future<void> updateMessageData(Map<String, dynamic> data) async =>
  //     await firestore
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .update(data);

  Future buildGroup(Uint8List file, String groupName, String createdBy) async {
    var uuid = const Uuid();
    final id = uuid.v4();
    final image =
        await ServicesController.uploadImage(file, 'image/profile/$id');

    await createGroup(
      name: groupName,
      image: image,
      id: id,
      createdBy: createdBy,
    );
  }

  static Future<void> createGroup({
    required String id,
    required String name,
    required String image,
    required String createdBy,
  }) async {
    try {
      final group = GroupModel(
          uid: id,
          name: name,
          image: image,
          onlineUsers: 0,
          createdBy: createdBy,
          lastActive: DateTime.now());

      await firestore.collection('groups').doc(id).set(group.toJson());
    } catch (e) {
      log(e.toString());
      // isError = true;
      // if (e is FirebaseException) {
      //   if (e.code == 'already-exists') {
      //     errorMsg =
      //         'User already registerd with this email, please try another one';
      //   } else {
      //     errorMsg = 'Error occured while creating user';
      //   }
      // } else if (e is SocketException) {
      //   errorMsg = 'please check your internet connection';
      // }
    }
  }

  Future logoutUser() async {
    await FirebaseAuth.instance.signOut();
  }
}
