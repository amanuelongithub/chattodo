import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  bool isLoading = false;
  bool isError = false;
  String? errorMsg;

  var userdataStorage = GetStorage();

  Future<void> loginUser(String email, pwd) async {
    try {
      isLoading = true;
      update();
      isError = false;
      errorMsg = null;

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pwd,
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
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
}
