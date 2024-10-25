import 'package:chattodo_test/constants.dart';
import 'package:chattodo_test/controller/auth_controller.dart';
import 'package:chattodo_test/views/auth/login_page.dart';
import 'package:chattodo_test/views/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static String route = 'splash-page';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    chekLoggedIn();
  }

  chekLoggedIn() async {
    final navigator = Navigator.of(context);

    await Future.delayed(const Duration(seconds: 1));

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        // Get.put(HomepageController());
        // Get.put(ChatController());
        navigator.pushNamedAndRemoveUntil(HomePage.route, (route) => false);
      } else {
        Get.put(AuthController());
        navigator.pushNamedAndRemoveUntil(LoginPage.route, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.kcBkg,
    );
  }
}
