import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/models/chat_message_model.dart';
import 'package:chattodo_test/constants.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.isMe,
    required this.isImage,
    required this.message,
  });

  final bool isMe;
  final bool isImage;
  final MessageModel message;

  @override
  Widget build(BuildContext context) => Align(
        alignment: isMe ? Alignment.bottomRight : Alignment.bottomLeft,
        child: Container(
          decoration: BoxDecoration(
            color: isMe ? AppConstant.kcPrimary : Colors.grey,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
          ),
          margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isImage
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: message.content,
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Text(message.content,
                      style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 5),
              Text(
                timeago.format(message.sentTime),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      );
}
