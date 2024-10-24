import 'package:chattodo_test/constants.dart';
import 'package:chattodo_test/views/auth/login_page.dart';
import 'package:flutter/material.dart';

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
    init();
  }

  init() async {
    final navigator = Navigator.of(context);
    await Future.delayed(const Duration(seconds: 1));
    // String routeName = HomePage.route;
    String routeName = LoginPage.route;
    navigator.pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.kcBkg,
    );
  }
}
