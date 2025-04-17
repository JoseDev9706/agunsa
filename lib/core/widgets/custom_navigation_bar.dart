import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomBottomNavitionBar extends ConsumerWidget {
  const CustomBottomNavitionBar({
    super.key,
    required this.uiUtils,
  });

  final UiUtils uiUtils;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: uiUtils.screenHeight * 0.08,
      width: uiUtils.screenWidth * 0.4,
      margin: EdgeInsets.symmetric(
          horizontal: uiUtils.screenWidth * 0.15,
          vertical: uiUtils.screenHeight * 0.02),
      decoration: BoxDecoration(
        color: uiUtils.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        IconButton(
            onPressed: () {
               final router = ref.read(routerDelegateProvider);
              router.push(AppRoute.home);
            },
            icon: Icon(
              Icons.home,
              color: uiUtils.whiteColor,
              size: uiUtils.screenHeight * 0.04,
            )),
        IconButton(
            onPressed: () {
              final router = ref.read(routerDelegateProvider);
              router.push(AppRoute.profile);
            },
            icon: Icon(
              Icons.person_rounded,
              color: uiUtils.whiteColor,
              size: uiUtils.screenHeight * 0.04,
            ))
      ]),
    );
  }
}
