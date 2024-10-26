import 'package:chat/controller/chat_homepage_controller.dart';
import 'package:chat/views/widgets/chat_usercard.dart';
import 'package:chattodo_test/constants.dart';
import 'package:chattodo_test/models/user_model.dart';
import 'package:chattodo_test/views/widget/error_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatHomepage extends StatefulWidget {
  const ChatHomepage({super.key});

  static String route = 'chat-homepage';

  @override
  State<ChatHomepage> createState() => _ChatHomepageState();
}

class _ChatHomepageState extends State<ChatHomepage>
    with WidgetsBindingObserver {
  ChatHomepageController homepageController = Get.put(ChatHomepageController());

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<ChatHomepageController>().fetchAllUsers();

    return Scaffold(
      body: GetBuilder<ChatHomepageController>(builder: (_) {
        if (_.isLoading) {
          return Scaffold(
            body: Center(
                child: CircularProgressIndicator(
              color: AppConstant.kcPrimary,
            )),
          );
        } else if (_.isError) {
          return ErrorPage(msg: _.errorMsg ?? 'Someting went wrong');
        } else if (_.users == null || _.users!.isEmpty) {
          return const ErrorPage(msg: 'Empty');
        } else {
          homepageController.update();
          return Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: AppBar(
                  leading: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  title: Text(
                    getProfile().name.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        )),
                    const SizedBox(
                      width: 15,
                    )
                  ],
                )),
            body: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: ListView.separated(
                  itemCount: _.users!.length,
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  itemBuilder: (context, index) => _.users![index].uid !=
                          FirebaseAuth.instance.currentUser?.uid
                      ? UserCard(user: _.users![index])
                      : const SizedBox(),
                  separatorBuilder: (BuildContext context, int index) =>
                      Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _.users![index].uid !=
                            FirebaseAuth.instance.currentUser?.uid
                        ? const Divider()
                        : const SizedBox(),
                  ),
                )),
          );
        }
      }),
    );
  }

  UserModel getProfile() {
    return homepageController.users!.firstWhere(
        (user) => user.uid == FirebaseAuth.instance.currentUser?.uid);
  }
}
