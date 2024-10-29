import 'dart:io';
import 'dart:typed_data';
import 'package:chattodo_test/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chattodo_test/controller/services_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  bool isLoading = false;
  bool isError = false;
  String? errorMsg;

  static final firestore = FirebaseFirestore.instance;

  void resetData() {
    isLoading = false;
    isError = false;
    errorMsg = null;
    update();
  }

  Future<void> loginUser(String email, String pwd) async {
    try {
      isLoading = true;
      update();
      isError = false;
      errorMsg = null;

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pwd,
      );
      await ServicesController.updateUserData(
        {'isOnline': true, 'lastActive': DateTime.now()},
      );
    } catch (e) {
      isError = true;
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-credential') {
          errorMsg = 'User not found';
        } else if (e.code == 'wrong-password') {
          errorMsg = 'Wrong password';
        }
      } else if (e is SocketException) {
        errorMsg = 'please check your internet connection';
      }
    } finally {
      isLoading = false;
    }
    update();
  }

  Future signUp(
      Uint8List file, String username, String email, String pwd) async {
    try {
      isLoading = true;
      update();

      isError = false;
      errorMsg = null;

      final user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pwd);
      final image = await ServicesController.uploadImage(
          file, 'image/profile/${user.user!.uid}');
      await createUser(
          name: username,
          image: image,
          email: user.user!.email!,
          uid: user.user!.uid);
    } catch (e) {
      isError = true;
      if (e is FirebaseAuthException) {
        if (e.code == 'already-exists') {
          errorMsg =
              'User alredy registerd with this email, please try another one';
        } else if (e.code == 'weak-password') {
          errorMsg = e.message;
        }
      } else if (e is SocketException) {
        errorMsg = 'please check your internet connection';
      }
    } finally {
      isLoading = false;
    }
    update();
  }

  Future<void> createUser(
      {required String name,
      required String image,
      required String email,
      required String uid}) async {
    try {
      final user = UserModel(
          uid: uid,
          email: email,
          name: name,
          image: image,
          isOnline: true,
          lastActive: DateTime.now());

      await firestore.collection('users').doc(uid).set(user.toJson());
    } catch (e) {
      isError = true;
      if (e is FirebaseException) {
        if (e.code == 'already-exists') {
          errorMsg =
              'User already registerd with this email, please try another one';
        } else {
          errorMsg = 'Error occured while creating user';
        }
      } else if (e is SocketException) {
        errorMsg = 'please check your internet connection';
      }
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      isLoading = true;
      update();
      isError = false;
      errorMsg = null;

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
    } catch (e) {
      isError = true;
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-credential') {
          errorMsg = 'User not found';
        }
      } else if (e is SocketException) {
        errorMsg = 'please check your internet connection';
      }
    } finally {
      isLoading = false;
    }
    update();
  }

  logout() {
    FirebaseAuth.instance.signOut();
  }
}
