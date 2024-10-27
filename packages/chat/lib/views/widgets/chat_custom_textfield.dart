import 'dart:typed_data';

import 'package:chat/controller/firestore_controller.dart';
import 'package:chattodo_test/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatCustomTextfield extends StatefulWidget {
  const ChatCustomTextfield({super.key});

  @override
  State<ChatCustomTextfield> createState() => _ChatCustomTextfieldState();
}

class _ChatCustomTextfieldState extends State<ChatCustomTextfield> {
  String? text;
  Uint8List? file;
  bool startWriting = false;
  @override
  Widget build(BuildContext context) {
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
                  cursorColor: Colors.white,
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
                    color: Colors.grey,
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
                    onPressed: () async => _sendImage(),
                    icon: const Icon(Icons.image, size: 20))
              } else ...{
                IconButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      await Get.find<FirestoreController>().addTextMessage(
                        receiverId:
                            Get.find<FirestoreController>().partner!.uid,
                        content: text!,
                      );
                      setState(() {
                        text = '';
                        startWriting = false;
                      });
                    },
                    icon: const Icon(Icons.send, size: 25)),
              }
            ])));
  }

  Future<void> _sendImage() async {
    final pickedImage = await pickImage();
    setState(() => file = pickedImage);
    if (file != null) {
      await FirestoreController.addImageMessage(
        receiverId: Get.find<FirestoreController>().partner!.uid,
        file: file!,
      );
    }
  }
}
