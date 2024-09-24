import 'package:flutter/material.dart';

class ColorPalette {
  
  static const Color pageBackground = Color.fromRGBO(40, 40, 40, 1);
  static const Color clockBorderDaytime = Color.fromARGB(255, 253, 236, 77);
  static const Color clockBorderNight = Color.fromARGB(255, 46, 81, 196);

  Color customGrey(int rgb, {double opacity = 1.0}) {
    if (rgb < 1 || rgb > 254) {
      throw ArgumentError('RGB value must be between 1 and 254.');
    } else if (opacity < 0 || opacity > 1) {
      throw ArgumentError('Opacity value must be between 0.0 and 1.0');
    }
    return Color.fromRGBO(rgb, rgb, rgb, opacity);
  }
}
