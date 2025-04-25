import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/widgets/custom_navigation_bar.dart';
import 'package:agunsa/features/profile/display/widgets/log_out_widget.dart';
import 'package:agunsa/home/display/widgets/change_password_adv.dart';
import 'package:agunsa/home/display/widgets/options_card.dart';
import 'package:agunsa/utils/ui_utils.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends ConsumerWidget {
  final SignInResult? isNeedPasswordConfirmation;
  const HomeScreen({
    super.key,
    this.isNeedPasswordConfirmation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    if (isNeedPasswordConfirmation?.nextStep.signInStep.name ==
        'signInWithPassword') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        uiUtils.showModalDialog(
          context,
          ChangePasswordAdv(
            uiUtils: uiUtils,
            onChangePassword: () {
              final router = ref.read(routerDelegateProvider);
              router.push(AppRoute.changePassword,
                  args: {'nextStep': isNeedPasswordConfirmation});
            },
          ),
          false,
        );
      });
    }
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
                          onPressed: () {
                            uiUtils.showModalDialog(
                                context, LogoutWidget(uiUtils: uiUtils), true);
                          },
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
                      onTap: () {
                        final router = ref.read(routerDelegateProvider);
                        router.push(AppRoute.transactions);
                      },
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
        bottomNavigationBar: CustomBottomNavitionBar(uiUtils: uiUtils),
      ),
    );
  }
}
