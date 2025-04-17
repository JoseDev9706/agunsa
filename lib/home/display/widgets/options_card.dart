import 'package:agunsa/core/widgets/animated_tittle.dart';
import 'package:agunsa/core/widgets/custom_list_tile.dart';
import 'package:agunsa/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class OptionsCard extends StatelessWidget {
  const OptionsCard({
    super.key,
    required this.uiUtils,
    required this.title,
    required this.onTap,
    required this.subtitle,
    required this.leading,
  });

  final UiUtils uiUtils;
  final String title;
  final VoidCallback onTap;
  final Widget subtitle;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: uiUtils.grayLightColor),
      child: CustomListTile(
        leading: leading,
        title: AnimatedTitle(
          text: title,
          style: TextStyle(
            color: uiUtils.whiteColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: subtitle,
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: uiUtils.whiteColor,
        ),
        onTap: onTap,
      ),
    );
  }
}