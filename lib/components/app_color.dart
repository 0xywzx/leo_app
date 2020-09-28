import 'package:flutter/material.dart';

class AppColor {
  static Color button = const Color(0x1E65DC);

  // 16進数カラーを使えるようにする
  static Color hexColor(String hexColor) {
    try {
      var _hexColor = hexColor.toUpperCase().replaceAll("#", "");
      if (_hexColor.length == 6) {
        _hexColor = "FF" + _hexColor;
      }
      return Color(int.parse(_hexColor, radix: 16));
    } catch (e) {
      return null;
    }
  }
}