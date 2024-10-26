import 'package:chat/views/chat_homepage.dart';
import 'package:chat/views/chat_page.dart';

getChatRoutes() {
  return {
    ChatHomepage.route: (context) => const ChatHomepage(),
    ChatPage.route: (context) => const ChatPage(),
  };
}
