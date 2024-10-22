import 'package:flutter/material.dart';

class AppConstant {
  static Color kcPrimary = hexToColor('#5D1190');
  static Color kcBkg = hexToColor('#F9F9F9'); // bg grey
}

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
