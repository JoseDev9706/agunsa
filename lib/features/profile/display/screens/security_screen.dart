import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/widgets/custom_list_tile.dart';
import 'package:agunsa/core/widgets/custom_navigation_bar.dart';
import 'package:agunsa/features/profile/display/screens/change_password.dart';
import 'package:agunsa/features/profile/display/widgets/log_out_widget.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/custom_app_bar.dart';

class SecurityScreen extends ConsumerWidget{
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(
              uiUtils: uiUtils,
              title: 'SEGURIDAD',
            ),
            SizedBox(height: uiUtils.screenHeight * 0.07),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: uiUtils.screenWidth * 0.05),
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10)
                  ],
                  color: uiUtils.whiteColor,
                  borderRadius: BorderRadius.circular(5)),
              width: uiUtils.screenWidth * 0.8,
              child: ListView(
                shrinkWrap: true,
                children: [
                  CustomListTile(
                    onTap: () {
                     final router = ref.read(routerDelegateProvider);
                        router.push(AppRoute.changePassword);
                    },
                    leading: Icon(
                      Icons.lock,
                      color: uiUtils.primaryColor,
                    ),
                    title: Text(
                      'Cambiar contraseña',
                      style: TextStyle(
                          color: uiUtils.optionsColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: uiUtils.primaryColor,
                    ),
                  ),
                  Divider(
                    color: uiUtils.grayLightColor,
                  ),
                  CustomListTile(
                     onTap: () {
                        uiUtils.showModalDialog(
                          context, LogoutWidget(uiUtils: uiUtils), true);
                      },
                    leading: Icon(
                      Icons.logout,
                      color: uiUtils.primaryColor,
                    ),
                    title: Text(
                      'Cerrar sesión',
                      style: TextStyle(
                          color: uiUtils.optionsColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: uiUtils.primaryColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: CustomBottomNavitionBar(uiUtils: uiUtils),
      ),
    );
  }
}
