import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/widgets/general_bottom.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:agunsa/features/auth/display/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutWidget extends ConsumerWidget {
  const LogoutWidget({
    super.key,
    required this.uiUtils,
  });

  final UiUtils uiUtils;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: uiUtils.screenHeight * 0.01,
          width: uiUtils.screenWidth * 0.15,
          decoration: BoxDecoration(
            color: uiUtils.primaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          textAlign: TextAlign.center,
          'Cerrar Sesión',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
        ),
        const SizedBox(height: 10),
        Text(
          textAlign: TextAlign.center,
          'Al cerrar sesión tu deberás acceder a la app usando tu contraseña.',
          style: TextStyle(
              fontWeight: FontWeight.normal,
              color: uiUtils.grayDarkColor,
              fontSize: 17),
        ),
        const SizedBox(height: 20),
        GeneralBottom(
          width: uiUtils.screenWidth,
          color: uiUtils.primaryColor,
          text: 'CANCELAR',
          onTap: () {
            Navigator.pop(context);
          },
          textColor: uiUtils.whiteColor,
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () async {
            Navigator.pop(context);
            final result =
                await ref.read(loginControllerProvider.notifier).logout();
            if (!result) {
              uiUtils.showSnackBar(context, 'Error al cerrar sesión');
            }
          },
          child: Text(
            'CERRAR SESIÓN',
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
