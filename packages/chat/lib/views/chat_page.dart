import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/controller/firestore_controller.dart';
import 'package:chat/views/widgets/chat_custom_textfield.dart';
import 'package:chat/views/widgets/empty_widget.dart';
import 'package:chat/views/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/chat_message_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  static String route = 'chat-page';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: AppBar(
                    leading: const BackButton(
                      color: Colors.white,
                    ),
                    title: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: _.partner != null
                              ? CachedNetworkImage(
                                  imageUrl: _.partner!.image,
                                  height: 40.r,
                                  width: 40.r,
                                  fit: BoxFit.cover,
                                )
                              : const SizedBox(),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _.partner!.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              _.partner!.isOnline
                                  ? 'Online'
                                  : timeago
                                      .format(_.partner!.lastActive)
                                      .toString(),
                              style: TextStyle(
                                color: _.partner!.isOnline
                                    ? Colors.green
                                    : Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // actions: [
                    //   IconButton(
                    //       onPressed: () {},
                    //       icon: const Icon(
                    //         Icons.search,
                    //         color: Colors.white,
                    //       )),
                    //   const SizedBox(
                    //     width: 15,
                    //   )
                    // ],
                  )),
              body: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _.messages.isEmpty
                            ? const EmptyWidget(
                                icon: Icons.waving_hand, text: 'Say Hello!')
                            : ListView.builder(
                                controller: _.scrollController,
                                itemCount: _.messages.length,
                                itemBuilder: (context, index) {
                                  final isMe = _.partner!.uid !=
                                      _.messages[index].senderId;
                                  switch (_.messages[index].messageType) {
                                    case MessageType.text:
                                      return MessageBubble(
                                          isMe: isMe,
                                          message: _.messages[index],
                                          senderName:
                                              _.messages[index].senderName,
                                          isImage: null);

                                    case MessageType.image:
                                      return MessageBubble(
                                        isMe: isMe,
                                        message: _.messages[index],
                                        senderName:
                                            _.messages[index].senderName,
                                        isImage: true,
                                      );

                                    case MessageType.audio:
                                      return MessageBubble(
                                        isMe: isMe,
                                        message: _.messages[index],
                                        senderName:
                                            _.messages[index].senderName,
                                        isImage: false,
                                      );

                                    default:
                                      const SizedBox();
                                  }
                                },
                              ),
                      ),
                    ),
                  ),
                  Container(
                    height: 70,
                    padding: EdgeInsets.only(left: 0.w, right: 5),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: const ChatCustomTextfield(),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
