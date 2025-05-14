import 'package:agunsa/core/widgets/general_bottom.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class ChangePasswordAdv extends StatelessWidget {
  const ChangePasswordAdv({
    super.key,
    required this.uiUtils, this.onChangePassword,
  });

  final UiUtils uiUtils;
  final VoidCallback? onChangePassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            height: uiUtils.screenHeight * 0.01,
            width: uiUtils.screenWidth * 0.15,
            decoration: BoxDecoration(
              color: uiUtils.primaryColor,
              borderRadius: BorderRadius.circular(5),
            )),
        const SizedBox(height: 20),
        const Text(
          textAlign: TextAlign.center,
          'Aviso importante',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        const SizedBox(height: 10),
        Text(
          textAlign: TextAlign.center,
          'Tu contraseña es temporal. Por seguridad, cámbiala lo antes posible desde tu perfil.',
          style: TextStyle(
              fontWeight: FontWeight.normal,
              color: uiUtils.grayDarkColor,
              fontSize: 17),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: onChangePassword,
          child: Text(
            'CAMBIAR CONTRASEÑA',
            style: TextStyle(
                color: uiUtils.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 17),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
