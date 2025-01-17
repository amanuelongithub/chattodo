import 'package:chat/views/chat_grouppage.dart';
import 'package:chat/views/chat_homepage.dart';
import 'package:chat/views/chat_page.dart';
import 'package:chat/views/chat_seachpage.dart';

getChatRoutes() {
  return {
    ChatHomepage.route: (context) => const ChatHomepage(),
    ChatPage.route: (context) => const ChatPage(),
    ChatGroupPage.route: (context) => const ChatGroupPage(),
    ChatSearchPage.route: (context) => const ChatSearchPage(),
  };
}
