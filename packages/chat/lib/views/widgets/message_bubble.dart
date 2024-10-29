import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/models/chat_message_model.dart';
import 'package:chattodo_test/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.isMe,
    this.senderName,
    required this.isImage,
    required this.message,
  });

  final bool isMe;
  final String? senderName;
  final bool? isImage;
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    bool isPlaying = false;

    return Align(
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
        child: FittedBox(
          child: Row(
            children: [
              if (senderName != null && !isMe) ...{
                CircleAvatar(
                  radius: 15,
                  child: Text(
                      senderName != '' ? senderName![0].toUpperCase() : 'Me'),
                ),
                const SizedBox(width: 10),
              },
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isImage == null) ...{
                    Text(message.content,
                        style: const TextStyle(color: Colors.white)),
                  } else if (isImage == true) ...{
                    Container(
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
                  } else ...{
                    StatefulBuilder(builder: (contxt, setState) {
                      return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          height: 50,
                          width: 100,
                          child: ListTile(
                            onTap: () async {
                              setState(() {
                                isPlaying = true;
                              });

                              await player.play(UrlSource(message.content));
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 226, 248),
                              child: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: AppConstant.kcPrimary,
                              ),
                            ),
                            title: const Text(
                              'audio',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 226, 248),
                              ),
                            ),
                          ));
                    })
                  },
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeago.format(message.sentTime),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                      if (isMe) ...{
                        const SizedBox(width: 5),
                        if (message.seen) ...{
                          Icon(
                            Icons.done_all,
                            color: Colors.white,
                            size: 15.sp,
                          )
                        } else ...{
                          Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15.sp,
                          )
                        }
                      }
                    ],
                  ),
                ],
              ),
              if (senderName != null && isMe) ...{
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 15,
                  child: Text(
                      senderName != '' ? senderName![0].toUpperCase() : 'Me'),
                )
              }
            ],
          ),
        ),
      ),
    );
  }
}
