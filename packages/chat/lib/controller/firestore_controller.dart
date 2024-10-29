import 'dart:io';
import 'dart:typed_data';

import 'package:chat/controller/chat_homepage_controller.dart';
import 'package:chat/models/chat_message_model.dart';
import 'package:chat/models/group_model.dart';
import 'package:chattodo_test/controller/services_controller.dart';
import 'package:chattodo_test/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirestoreController extends GetxController {
  bool isLoading = false;

  UserModel? partner;
  GroupModel? selectedGroup;

  List<MessageModel> messages = [];

  ScrollController scrollController = ScrollController();

  getMessages(String receiverId) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chat')
          .doc(receiverId)
          .collection('messages')
          .orderBy('sentTime', descending: false)
          .snapshots(includeMetadataChanges: true)
          .listen((messages) {
        this.messages = messages.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList();
            
        update();
        scrollDown();
      });
   
  }

  getGroupMessages(String receiverId) {
    FirebaseFirestore.instance
        .collection('groups')
        .doc(receiverId)
        .collection('messages')
        .orderBy('sentTime', descending: false)
        .snapshots(includeMetadataChanges: true)
        .listen((messages) {
      this.messages = messages.docs
          .map((doc) => MessageModel.fromJson(doc.data()))
          .toList();
      update();
      scrollDown();
    });
  }

  Future<void> getUserById(String userId) async {
    isLoading = true;
    update();

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots(includeMetadataChanges: true)
        .listen((user) {
      partner = UserModel.fromJson(user.data()!);
      isLoading = false;
      update();
    });
  }

  Future<void> getGroupById(String groupId) async {
    isLoading = true;
    update();

    FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .snapshots(includeMetadataChanges: true)
        .listen((group) {
      selectedGroup = GroupModel.fromJson(group.data()!);
      isLoading = false;
      update();
    });
  }

  Future<void> addTextMessage({
    bool? addToChat,
    required String content,
    required String receiverId,
  }) async {
    final message = MessageModel(
      content: content,
      seen: false,
      senderName: Get.find<ChatHomepageController>().currentUser!.name,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.text,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );
    await ServicesController.addMessageToChat(
        addToChat ?? true, receiverId, message);
  }

  static Future<void> addImageMessage({
    required bool addToChat,
    required String receiverId,
    required Uint8List file,
  }) async {
    final image = await ServicesController.uploadImage(
        file, 'image/chat/${DateTime.now()}');

    final message = MessageModel(
      content: image,
      seen: false,
      senderName: Get.find<ChatHomepageController>().currentUser!.name,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.image,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );
    await ServicesController.addMessageToChat(addToChat, receiverId, message);
  }

  static Future<void> addAudioMessage({
    required bool addToChat,
    required String receiverId,
    required File file,
  }) async {
    final audio = await ServicesController.uploadAudio(
        file, 'audio/chat/${DateTime.now()}');

    final message = MessageModel(
      content: audio,
      seen: false,
      senderName: Get.find<ChatHomepageController>().currentUser!.name,
      sentTime: DateTime.now(),
      receiverId: receiverId,
      messageType: MessageType.audio,
      senderId: FirebaseAuth.instance.currentUser!.uid,
    );
    await ServicesController.addMessageToChat(addToChat, receiverId, message);
  }

  void scrollDown() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
}
