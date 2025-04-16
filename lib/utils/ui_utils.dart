import 'package:flutter/material.dart';

class UiUtils {
  UiUtils._privateConstructor();
  static final UiUtils _instance = UiUtils._privateConstructor();

  factory UiUtils() => _instance;

  double screenHeight = 0;
  double screenWidth = 0;

  final Color primaryColor = const Color(0xFFCE1D1B);
  final Color primaryLigthColor = const Color(0xFFDF271C);
  final Color grayDarkColor = const Color(0xFF3F3F3E);
  final Color grayLightColor = const Color(0xFF9B9A99);
  final Color labelColor = const Color(0xFFD8D8D8);
  final Color whiteColor = const Color(0xFFFFFFFF);

  void getDeviceSize(BuildContext context) {
    screenHeight = MediaQueryData.fromView(View.of(context)).size.height;
    screenWidth = MediaQueryData.fromView(View.of(context)).size.width;
  }

  
}
