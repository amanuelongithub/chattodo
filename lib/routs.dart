import 'package:chattodo_test/views/auth/forgotpassword_page.dart';
import 'package:chattodo_test/views/auth/login_page.dart';
import 'package:chattodo_test/views/auth/signup_page.dart';
import 'package:chattodo_test/views/home_page.dart';
import 'package:chattodo_test/views/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:chat/route.dart' as chat;
import 'package:todo/route.dart' as todo;

Map<String, WidgetBuilder> getRoutes() {
  return {
    SplashPage.route: (context) => const SplashPage(),
    HomePage.route: (context) => const HomePage(),
    LoginPage.route: (context) => const LoginPage(),
    SignUpPage.route: (context) => const SignUpPage(),
    ForgotPasswordPage.route: (context) => const ForgotPasswordPage(),
    ...chat.getChatRoutes(),
    ...todo.getTodoRoutes(),
  };
}
