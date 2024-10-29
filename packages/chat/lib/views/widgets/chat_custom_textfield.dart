import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:chat/controller/firestore_controller.dart';
import 'package:chattodo_test/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

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

  final _record = Record();
  File? audioFile;

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
                GestureDetector(
                    onLongPressStart: (start) {
                      _startRecording();
                    },
                    onLongPressEnd: (end) {
                      _stopRecording();
                    },
                    child: CircleAvatar(
                        radius: 25,
                        child: const Icon(Icons.audiotrack, size: 20))),
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

  Future<void> sendAudio(bool addToChat) async {
    if (audioFile != null) {
      await FirestoreController.addAudioMessage(
        addToChat: addToChat,
        receiverId: addToChat
            ? Get.find<FirestoreController>().partner!.uid
            : Get.find<FirestoreController>().selectedGroup!.uid,
        file: audioFile!,
      );
    }
  }

  Future<void> _startRecording() async {
    // Check and request permission
    if (await _record.hasPermission()) {
      // Get the temporary directory path
      Directory tempDir = await getTemporaryDirectory();
      String path = '${tempDir.path}/${DateTime.now()}.m4a';

      await _record.start(
        path: path, // the file path where audio is saved
        encoder: AudioEncoder.aacHe, // use AAC encoding
        bitRate: 128000, // optional bitrate
        samplingRate: 44100, // optional sampling rate
      );

      setState(() {
        audioFile = File(path);
      });
    }
  }

  Future<void> _stopRecording() async {
    // Stop recording and release the resources
    await _record.stop();
    await sendAudio(true);

    // Update UI if needed
  }
}
