import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/controller/firestore_controller.dart';
import 'package:chat/views/chat_page.dart';
import 'package:chattodo_test/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          Get.find<FirestoreController>().getUserById(user.uid);
          Get.find<FirestoreController>().getMessages(user.uid);
          Navigator.pushNamed(context, ChatPage.route);
        },
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Stack(
            alignment: Alignment.bottomRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: user.image,
                  height: 57.r,
                  width: 57.r,
                  fit: BoxFit.cover,
                ),
              ),
              user.isOnline
                  ? const Positioned(
                      right: 0,
                      bottom: -10,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 7,
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 5,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          title: Row(
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // ! seen func
            ],
          ),
          subtitle: Text(
            'Last Active : ${timeago.format(user.lastActive)}',
            maxLines: 2,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
}
