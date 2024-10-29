import 'package:chat/controller/firestore_controller.dart';
import 'package:chat/views/widgets/chat_card.dart';
import 'package:chattodo_test/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatSearchPage extends StatefulWidget {
  const ChatSearchPage({super.key});

  static String route = 'chat-search-page';

  @override
  State<ChatSearchPage> createState() => _ChatSearchPageState();
}

class _ChatSearchPageState extends State<ChatSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  String searchQuery = '';

  Future<List<UserModel>> _searchInFirestore(String query) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    return snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FirestoreController>(builder: (_) {
      if (_.isLoading) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else {
        return PopScope(
            onPopInvoked: (didPop) {
              Get.find<FirestoreController>().messages.clear();
            },
            child: Material(
                child: Scaffold(
                    appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(60),
                        child: AppBar(
                            leading: const BackButton(color: Colors.white),
                            title: SizedBox(
                              height: 40,
                              child: TextField(
                                  controller: _searchController,
                                  onChanged: (value) {
                                    setState(() {
                                      searchQuery = value;
                                    });
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: "Search ",
                                    hintStyle: TextStyle(color: Colors.white),
                                    prefixIcon:
                                        Icon(Icons.search, color: Colors.white),
                                    fillColor: Color.fromARGB(255, 61, 61, 61),
                                    filled: true,
                                  )),
                            ))),
                    body: FutureBuilder<List<UserModel>>(
                      future: _searchInFirestore(searchQuery),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text("Error: ${snapshot.error}"));
                        }

                        final results = snapshot.data ?? [];

                        if (results.isEmpty) {
                          return const Center(child: Text("No results found."));
                        }

                        return ListView.builder(
                          itemCount: results.length,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemBuilder: (context, index) {
                            final user = results[index];
                            return ChatCard(user: user);
                          },
                        );
                      },
                    ))));
      }
    });
  }
}
