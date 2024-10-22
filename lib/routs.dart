import 'package:chattodo_test/views/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:chat/route.dart' as chat;
import 'package:todo/route.dart' as todo;

Map<String, WidgetBuilder> getRoutes() {
  return {
    SplashPage.route: (context) => const SplashPage(),
    ...chat.getChatRoutes(),
    ...todo.getTodoRoutes(),
  };
}