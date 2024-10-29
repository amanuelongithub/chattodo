import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/controller/chat_homepage_controller.dart';
import 'package:chat/controller/firestore_controller.dart';
import 'package:chat/models/group_model.dart';
import 'package:chat/views/chat_seachpage.dart';
import 'package:chat/views/widgets/chat_card.dart';
import 'package:chattodo_test/constants.dart';
import 'package:chattodo_test/controller/services_controller.dart';
import 'package:chattodo_test/models/user_model.dart';
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
  TextEditingController groupName = TextEditingController();
  Uint8List? file;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    if (homepageController.users == null || homepageController.users!.isEmpty) {
      homepageController.fetchHomeData();
      homepageController.setCurrentUser();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed: // when user get back to app
        ServicesController.updateUserData({
          'lastActive': DateTime.now(),
          'isOnline': true,
        });
        break;

      case AppLifecycleState.inactive: // run app in background
      case AppLifecycleState.paused: // ex: switch to another app
        ServicesController.updateUserData({'isOnline': false});
        break;
      case AppLifecycleState.detached: // terminat the app
        ServicesController.updateUserData({'isOnline': false});
        break;
      case AppLifecycleState.hidden:
        break;
    }
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
                        onPressed: () =>
                            navigator!.pushNamed(ChatSearchPage.route),
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
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text(
                                  "Create group",
                                  style:
                                      TextStyle(color: AppConstant.kcPrimary),
                                ),
                                content: StatefulBuilder(
                                    builder: (context, setState) {
                                  return SizedBox(
                                    height: 200.h,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            final pickedImage =
                                                await pickImage();
                                            setState(() => file = pickedImage!);
                                          },
                                          child: file != null
                                              ? CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage:
                                                      MemoryImage(file!),
                                                )
                                              : const CircleAvatar(
                                                  radius: 51,
                                                  backgroundColor: Colors.grey,
                                                  child: CircleAvatar(
                                                    radius: 50,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Icon(
                                                      Icons.add_a_photo,
                                                      size: 40,
                                                      color: Color.fromARGB(
                                                          255, 163, 163, 163),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        TextFormField(
                                          controller: groupName,
                                        )
                                      ],
                                    ),
                                  );
                                }),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: AppConstant.kcAppbarbg),
                                      )),
                                  TextButton(
                                      child: const Text(
                                        "Create",
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 5, 217, 5)),
                                      ),
                                      onPressed: () async {
                                        final navigator = Navigator.of(context);

                                        if (groupName.text.isNotEmpty &&
                                            file != null) {
                                          if (file != null) {
                                            await ServicesController()
                                                .buildGroup(
                                                    file!,
                                                    groupName.text,
                                                    _.currentUser!.uid);
                                            navigator.pop();
                                          } else {
                                            const snackBar = SnackBar(
                                                content: Text(
                                                    'Please select a profile picture'));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            return;
                                          }
                                        }
                                      }),
                                ],
                              ));
                    },
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
                  onRefresh: () async => await Future.delayed(
                      const Duration(milliseconds: 400), () async {
                    _.fetchHomeData;
                    _.setCurrentUser();
                  }),
                  child: Builder(builder: (context) {
                    final card = [..._.users!, ..._.groups!];
                    return ListView.separated(
                        itemCount: card.length,
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
                        itemBuilder: (context, index) {
                          final item = card[index];
                          if (item is UserModel &&
                              _.users![index].uid !=
                                  FirebaseAuth.instance.currentUser?.uid) {
                            return ChatCard(user: item, groupModel: null);
                          } else if (item is GroupModel) {
                            return ChatCard(user: null, groupModel: item);
                          } else {
                            return const SizedBox();
                          }
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          final card = [..._.users!, ..._.groups!];
                          final item = card[index];

                          return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: (item is UserModel &&
                                      _.users![index].uid !=
                                          FirebaseAuth
                                              .instance.currentUser?.uid)
                                  ? const Divider()
                                  : item is GroupModel
                                      ? const Divider()
                                      : const SizedBox());
                        });
                  }),
                )),
          );
        }
      }),
    );
  }
}
