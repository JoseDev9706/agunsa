import 'dart:math';

import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/widgets/custom_list_tile.dart';
import 'package:agunsa/core/widgets/custom_navigation_bar.dart';
import 'package:agunsa/core/widgets/general_bottom.dart';
import 'package:agunsa/features/profile/display/widgets/custom_app_bar.dart';
import 'package:agunsa/features/profile/display/widgets/log_out_widget.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../auth/display/providers/auth_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    final userlog = ref.watch(userProvider);
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomAppBar(uiUtils: uiUtils),
            SizedBox(height: uiUtils.screenHeight * 0.07),
            CircleAvatar(
              radius: 25,
              backgroundColor: uiUtils.primaryColor,
              child: SvgPicture.asset("assets/svg/no-profile.svg",
                  height: uiUtils.screenHeight * 0.04),
            ),
            Text(
              //'Carlos Mario',
              "${userlog?.email ?? ''}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
            ),
            SizedBox(height: uiUtils.screenHeight * 0.05),
            Container(
                padding: EdgeInsets.symmetric(
                    horizontal: uiUtils.screenWidth * 0.05),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 10)
                    ],
                    color: uiUtils.whiteColor,
                    borderRadius: BorderRadius.circular(5)),
                width: uiUtils.screenWidth * 0.8,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    CustomListTile(
                      leading: SvgPicture.asset("assets/svg/guard.svg",
                          height: uiUtils.screenHeight * 0.03,
                          color: uiUtils.primaryColor),
                      title: Text(
                        'Seguridad',
                        style: TextStyle(
                            color: uiUtils.grayLightColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        final router = ref.read(routerDelegateProvider);
                        router.push(AppRoute.security);
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: uiUtils.grayLightColor,
                      ),
                    ),
                    Divider(
                      color: uiUtils.grayLightColor,
                    ),
                    CustomListTile(
                      leading: Icon(
                        Icons.logout,
                        color: uiUtils.primaryColor,
                      ),
                      title: Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                            color: uiUtils.grayLightColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        uiUtils.showModalDialog(
                            context, LogoutWidget(uiUtils: uiUtils), true);
                      },
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: uiUtils.grayLightColor,
                      ),
                    ),
                  ],
                )),
            SizedBox(height: uiUtils.screenHeight * 0.05),
            GestureDetector(
              onTap: () {
                uiUtils.showModalDialog(
                    context,
                    Column(
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
                          'Eliminar cuenta',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          textAlign: TextAlign.center,
                          'Estas seguro que deseas eliminar tu cuenta?. \nAl hacerlo perderas los datos asociados a la cuenta, tales como los registros de las transacciones realizadas y tus datos de conductor.',
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
                          },
                          child: Text(
                            'ELIMINAR CUENTA',
                            style: TextStyle(
                                color: uiUtils.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    true);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Eliminar Cuenta',
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: uiUtils.primaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
        bottomNavigationBar: CustomBottomNavitionBar(uiUtils: uiUtils),
      ),
    );
  }
}
