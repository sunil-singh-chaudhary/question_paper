import 'package:flutter/material.dart';

extension CustomTextStyle on TextStyle {
  TextStyle withColorAndSize(Color color, double fontSize) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }
}
