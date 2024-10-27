import 'dart:developer';
import 'dart:typed_data';
import 'package:chat/controller/firestore_controller.dart';
import 'package:chattodo_test/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatCustomTextfield extends StatefulWidget {
  final bool? isFromGroup;
  const ChatCustomTextfield({super.key, this.isFromGroup = false});

  @override
  State<ChatCustomTextfield> createState() => _ChatCustomTextfieldState();
}

class _ChatCustomTextfieldState extends State<ChatCustomTextfield> {
  String? text;
  Uint8List? file;
  bool startWriting = false;
  @override
  Widget build(BuildContext context) {
    log(widget.isFromGroup.toString());
    return Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                child: TextFormField(
                  cursorColor: AppConstant.kcPrimary,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Type your message',
                    fillColor: Colors.transparent,
                    filled: true,
                    border: InputBorder.none,
                    errorStyle: TextStyle(height: 0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      text = value;
                      startWriting = true;
                    });
                  },
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
              ),
              if (!startWriting || text == '' || text == null) ...{
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.audiotrack, size: 20)),
                IconButton(
                    onPressed: () async => widget.isFromGroup!
                        ? _sendImage(false)
                        : _sendImage(true),
                    icon: const Icon(Icons.image, size: 20))
              } else ...{
                IconButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (widget.isFromGroup == false) {
                        await Get.find<FirestoreController>().addTextMessage(
                          receiverId:
                              Get.find<FirestoreController>().partner!.uid,
                          content: text!,
                        );
                      } else {
                        await Get.find<FirestoreController>().addTextMessage(
                          addToChat: false,
                          receiverId: Get.find<FirestoreController>()
                              .selectedGroup!
                              .uid,
                          content: text!,
                        );
                      }
                      setState(() {
                        text = '';
                        startWriting = false;
                      });
                    },
                    icon: const Icon(Icons.send, size: 25)),
              }
            ])));
  }

  Future<void> _sendImage(bool addToChat) async {
    final pickedImage = await pickImage();
    setState(() => file = pickedImage);
    if (file != null) {
      await FirestoreController.addImageMessage(
        addToChat: addToChat,
        receiverId: addToChat
            ? Get.find<FirestoreController>().partner!.uid
            : Get.find<FirestoreController>().selectedGroup!.uid,
        file: file!,
      );
    }
  }
}
