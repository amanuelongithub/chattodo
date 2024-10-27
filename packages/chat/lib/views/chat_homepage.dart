import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/controller/chat_homepage_controller.dart';
import 'package:chat/controller/firestore_controller.dart';
import 'package:chat/views/widgets/chat_usercard.dart';
import 'package:chattodo_test/constants.dart';
import 'package:chattodo_test/controller/services_controller.dart';
import 'package:chattodo_test/views/widget/error_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  FirestoreController chatpageController = Get.put(FirestoreController());

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    if (homepageController.users == null || homepageController.users!.isEmpty) {
      homepageController.fetchAllUsers();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          return Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: AppBar(
                  leading: Builder(builder: (context) {
                    return IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  }),
                  title: const Text(
                    'Telegram',
                    style: TextStyle(color: Colors.white),
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
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 60,
                              width: 60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: _.currentUser != null
                                    ? CachedNetworkImage(
                                        imageUrl: _.currentUser!.image,
                                        height: 57.r,
                                        width: 57.r,
                                        fit: BoxFit.cover,
                                      )
                                    : const SizedBox(),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _.currentUser != null
                                  ? _.currentUser!.name.toUpperCase()
                                  : '',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _.currentUser != null ? _.currentUser!.email : '',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      )),
                  ListTile(
                    leading: const Icon(Icons.group),
                    title: const Text('Create group'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () async {
                      Navigator.pop(context);
                      _.showLoading(true);

                      await ServicesController.updateUserData({
                        'lastActive': DateTime.now(),
                        'isOnline': false,
                      });
                      await ServicesController().logoutUser();
                      _.showLoading(false);
                    },
                  ),
                ],
              ),
            ),
            body: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: RefreshIndicator(
                  backgroundColor: AppConstant.kcPrimary,
                  color: AppConstant.kcBkg,
                  onRefresh: () =>
                      Future.delayed(const Duration(milliseconds: 400), () {
                    _.fetchAllUsers();
                  }),
                  child: ListView.separated(
                    itemCount: _.users!.length,
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
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
                  ),
                )),
          );
        }
      }),
    );
  }
}
