import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AppConstant {
  static Color kcPrimary = hexToColor('#5D1190');
  static Color kcBkg = hexToColor('#F9F9F9'); // bg grey
  static Color kcAppbarbg = hexToColor('#000000'); // bg grey
}

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

Future<Uint8List?> pickImage() async {
  try {
    final imagePicker = ImagePicker();
    final file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return await file.readAsBytes();
    }
  } on PlatformException catch (e) {
    debugPrint('Failed to pick image: $e');
  }
  return null;
}
