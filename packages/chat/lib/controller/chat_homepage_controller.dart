import 'dart:developer';
import 'dart:io';

import 'package:chat/models/group_model.dart';
import 'package:chattodo_test/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatHomepageController extends GetxController {
  bool isLoading = false;
  bool isError = false;
  String? errorMsg;

  UserModel? currentUser;
  List<UserModel>? users;
  List<GroupModel>? groups;

  Future<void> fetchHomeData() async {
    try {
      isLoading = true;
      update();
      isError = false;
      errorMsg = null;

      Future.wait([
        fetchAllUsers(),
        fetchAllGroups(),
        setCurrentUser(),
      ]);
    } catch (e) {
      if (e is SocketException) {
        errorMsg = 'please check your internet connection';
      }
    } finally {
      if (users != null && users!.isNotEmpty) {
        isError = false;
      }
    }
    isLoading = false;
    update();
  }

  Future<void> fetchAllUsers() async {
    try {
      isLoading = true;
      update();
      isError = false;
      errorMsg = null;

      // real time updates
      FirebaseFirestore.instance
          .collection('users')
          .orderBy('lastActive', descending: true)
          .snapshots(includeMetadataChanges: true)
          .listen((userlist) async {
        users =
            userlist.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
        isLoading = false;
        log(users!.toList().toString());
        update();
      });
      await setCurrentUser();
    } catch (e) {
      if (e is FirebaseException) {
        if (e.code == 'user-not-found') {
          errorMsg = 'User not found';
        } else if (e.code == 'wrong-password') {
          errorMsg = 'Wrong password';
        }
      } else if (e is SocketException) {
        errorMsg = 'please check your internet connection';
      }
    } finally {
      if (users != null && users!.isNotEmpty) {
        isError = false;
      }
    }
  }

  Future<void> fetchAllGroups() async {
    // real time updates
    FirebaseFirestore.instance
        .collection('groups')
        .orderBy('lastActive', descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((grouplist) async {
      groups =
          grouplist.docs.map((doc) => GroupModel.fromJson(doc.data())).toList();
    });
  }

  showLoading(bool isLoading) {
    this.isLoading = isLoading;
    update();
  }

  Future<void> setCurrentUser() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots(includeMetadataChanges: true)
        .listen((user) {
      currentUser = UserModel.fromJson(user.data()!);
      update();
    });
  }
}
