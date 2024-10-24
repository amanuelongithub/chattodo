import 'package:flutter/material.dart';

class ChatHomepage extends StatelessWidget {
  const ChatHomepage({super.key});

  static String route = 'chat-homepage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(80), child: AppBar(title: const Text('Chat App'))),
      body: Container(color: Colors.blue),
    );
  }
}