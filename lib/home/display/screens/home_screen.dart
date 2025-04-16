import 'dart:math';

import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/widgets/animated_tittle.dart';
import 'package:agunsa/core/widgets/custom_list_tile.dart';
import 'package:agunsa/utils/ui_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: uiUtils.screenHeight * 0.22,
              color: uiUtils.primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.logout,
                            color: uiUtils.whiteColor,
                          ))
                    ],
                  ),
                  SvgPicture.asset(
                    "assets/svg/primary-logo.svg",
                    height: uiUtils.screenHeight * 0.04,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                  SizedBox(height: uiUtils.screenHeight * 0.01),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Hola Agunsa",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: uiUtils.whiteColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 1),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    const Text(
                      "¿Que deseas hacer?",
                      style:
                          TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 60),
                    OptionsCard(
                      uiUtils: uiUtils,
                      title: "Nueva Transacción",
                      subtitle: Row(
                        children: [
                          Text("Entradas",
                              style: TextStyle(
                                  color: uiUtils.whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(width: 5),
                          SvgPicture.asset(
                            "assets/svg/arrow_climb.svg",
                          ),
                        ],
                      ),
                      leading: Icon(
                        size: 35,
                        Icons.add_circle,
                        color: uiUtils.whiteColor,
                      ),
                      onTap: () {},
                    ),
                    const SizedBox(height: 40),
                    OptionsCard(
                      uiUtils: uiUtils,
                      title: "Transacciones en proceso",
                      subtitle: Row(
                        children: [
                          Text("Salidas",
                              style: TextStyle(
                                  color: uiUtils.whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(width: 5),
                          SvgPicture.asset(
                            "assets/svg/arrow_sis.svg",
                          ),
                        ],
                      ),
                      leading: SvgPicture.asset(
                        "assets/svg/report.svg",
                      ),
                      onTap: () {},
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: uiUtils.screenHeight * 0.08,
          width: uiUtils.screenWidth*0.4,
          margin:  EdgeInsets.symmetric(horizontal: uiUtils.screenWidth*0.15, vertical: uiUtils.screenHeight*0.02),
          decoration: BoxDecoration(
            color: uiUtils.primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {},
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
          ),
      ),
    );
  }
}

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
