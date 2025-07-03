import 'dart:developer';

import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  final Color black = const Color(0xFF000000);
  final Color green = const Color(0xFF419A20);
  final Color orange = const Color(0xFFFCB018);

  void getDeviceSize(BuildContext context,
      {required double height, required double width}) {
    screenHeight = height;
    screenWidth = width;
    log('Screen Height: $screenHeight');
    log('Screen Width: $screenWidth');
  }

  Future<void> showLoadingDialog() async {}
  Future<void> showModalDialog(
      BuildContext context, Widget child, bool isDismissible) async {
    return await showModalBottomSheet(
        isDismissible: isDismissible,
        enableDrag: isDismissible,
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

  void hideModalDialog(BuildContext context, WidgetRef ref) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }
}
