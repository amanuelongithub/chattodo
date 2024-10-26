import 'package:chattodo_test/constants.dart';
import 'package:flutter/material.dart';

class TodoHomepage extends StatelessWidget {
  const TodoHomepage({super.key});

  static String route = 'todo-homepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(title: const Text('Todo App'))),
      body: Container(color: AppConstant.kcPrimary),
    );
  }
}
