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

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
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
            const Text(
              'Carlos Mario',
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
                      leading: SvgPicture.asset("assets/svg/no-profile.svg",
                          height: uiUtils.screenHeight * 0.03,
                          color: uiUtils.primaryColor),
                      title: Text(
                        'Datos Personales',
                        style: TextStyle(
                            color: uiUtils.grayLightColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {},
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
            const Spacer(),
          ],
        ),
        bottomNavigationBar: CustomBottomNavitionBar(uiUtils: uiUtils),
      ),
    );
  }
}


