import 'dart:developer';

import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/widgets/custom_navigation_bar.dart';
import 'package:agunsa/features/auth/display/providers/auth_providers.dart';
import 'package:agunsa/features/auth/domain/entities/user_entity.dart';
import 'package:agunsa/features/profile/display/widgets/log_out_widget.dart';
import 'package:agunsa/features/home/display/widgets/change_password_adv.dart';
import 'package:agunsa/features/home/display/widgets/options_card.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends ConsumerWidget {
  final SignInResult? isNeedPasswordConfirmation;
  final UserEntity? user;
  const HomeScreen({
    super.key,
    this.isNeedPasswordConfirmation,
    this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    final user = ref.watch(userProvider);
    final router = ref.read(routerDelegateProvider);
    log('nesessary ${isNeedPasswordConfirmation?.nextStep.signInStep.name.toString() ?? ''}');
    if (isNeedPasswordConfirmation?.nextStep.signInStep.name ==
            'confirmSignInWithNewPassword' &&
        router.currentRoute == AppRoute.home) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        uiUtils.showModalDialog(
          context,
          ChangePasswordAdv(
            uiUtils: uiUtils,
            onChangePassword: () async {
              uiUtils.hideModalDialog(context, ref);

              router.push(AppRoute.changePassword,
                    args: {
                'nextStep': isNeedPasswordConfirmation,
                'isfromChangePassword': true
              });
             
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
                        Expanded(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            "Hola ${'Agunsa'}",
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: uiUtils.whiteColor),
                          ),
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
                        router
                            .push(AppRoute.transactions, args: {'user': user});
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
                      onTap: () {
                        final router = ref.read(routerDelegateProvider);
                        router.push(AppRoute.proccess);
                      },
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
