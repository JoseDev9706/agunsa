import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ContainerPhotoWidget extends StatelessWidget {
  const ContainerPhotoWidget({
    super.key,
    required this.uiUtils,
  });

  final UiUtils uiUtils;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: uiUtils.screenWidth * 0.75,
      height: uiUtils.screenWidth * 0.75,
      decoration: BoxDecoration(
          color: uiUtils.labelColor,
          borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          Center(
              child: SvgPicture.asset(
                  'assets/svg/camera_port.svg')),
          Positioned.fill(
            child: Center(
              child:
                  SvgPicture.asset('assets/svg/camera.svg'),
            ),
          ),
        ],
      ),
    );
  }
}