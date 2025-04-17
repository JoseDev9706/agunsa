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
  final Color modalColor = const Color(0xFFD9D9D9);
  final Color optionsColor = const Color(0xFF929292);

  void getDeviceSize(BuildContext context) {
    screenHeight = MediaQueryData.fromView(View.of(context)).size.height;
    screenWidth = MediaQueryData.fromView(View.of(context)).size.width;
  }

  Future<void> showLoadingDialog() async {}
  Future<void> showModalDialog(BuildContext context, Widget child) async {
    return await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: modalColor, borderRadius: BorderRadius.circular(25)),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: child,
          );
        });
  }
}
