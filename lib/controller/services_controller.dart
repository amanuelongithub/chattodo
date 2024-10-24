import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class ServicesController {


  // * store image to firebase storage
  static Future<String> uploadImage(Uint8List file, String storagePath) async =>
      await FirebaseStorage.instance
          .ref()
          .child(storagePath)
          .putData(file)
          .then((task) => task.ref.getDownloadURL());
}
