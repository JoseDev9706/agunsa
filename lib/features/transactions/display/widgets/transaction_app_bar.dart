import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionAppBar extends ConsumerWidget {
  const TransactionAppBar(
      {super.key,
      required this.uiUtils,
      this.title,
      this.subtitle,
      this.titleColor,
      this.iconColor,
      required this.onTap});

  final UiUtils uiUtils;
  final String? title;
  final String? subtitle;
  final Color? titleColor;
  final Color? iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      // height: uiUtils.screenHeight * 0.15,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: uiUtils.grayDarkColor,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    Icons.arrow_back,
                    color: iconColor ?? uiUtils.whiteColor,
                    size: 20,
                  )),
            )
          ]),
          // if (title != null || subtitle != null) ...[
          //   const Spacer(),
          // ],
          Text(
            title ?? "PERFIL",
            style: TextStyle(
              color: titleColor ?? uiUtils.grayDarkColor,
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
