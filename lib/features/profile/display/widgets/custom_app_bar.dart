import 'dart:developer';

import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomAppBar extends ConsumerWidget {
  const CustomAppBar({
    super.key,
    required this.uiUtils, this.title,
    this.subtitle
  });

  final UiUtils uiUtils;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        height: uiUtils.screenHeight * 0.15,
        color: uiUtils.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
               GestureDetector(
                 onTap: () {
                log('back');
                ref.read(routerDelegateProvider).popRoute();
                 },
                 child:  Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: uiUtils.whiteColor,),
                  padding: const EdgeInsets.all(2),
                   child: Icon(
                      Icons.arrow_back,
                      color: uiUtils.primaryColor,
                      size: 20,
                    )
                 ),
               )
            ]),
            const Spacer(),
            Text(
              title ?? "PERFIL",
              style: TextStyle(
                color: uiUtils.whiteColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle ?? "",
              style: TextStyle(
                color: uiUtils.whiteColor,
                fontSize: 17,
              ),
            ),
          ]
          ],
        ),
    );
  }
}