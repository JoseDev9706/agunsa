import 'dart:developer';

import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/widgets/general_bottom.dart';
import 'package:agunsa/features/profile/display/providers/profile_provider.dart';
import 'package:agunsa/features/profile/display/widgets/custom_app_bar.dart';
import 'package:agunsa/features/profile/display/widgets/custom_form_field.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePassword extends ConsumerStatefulWidget {
  final SignInResult? isNeedPasswordConfirmation;
  final bool? isfromChangePassword;
  const ChangePassword(this.isNeedPasswordConfirmation,
      {super.key, this.isfromChangePassword});

  @override
  ConsumerState<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
  late final TextEditingController passwordController;
  late final TextEditingController newPasswordController;
  late final TextEditingController repeatPasswordController;
  late final UiUtils uiUtils;

  @override
  void initState() {
    super.initState();
    uiUtils = UiUtils();
    passwordController = TextEditingController();
    newPasswordController = TextEditingController();
    repeatPasswordController = TextEditingController();

    passwordController.addListener(() {
      ref.read(changePasswordFormStateProvider.notifier).updateCurrentPassword(
            passwordController.text,
          );
      _validateForm();
    });

    newPasswordController.addListener(() {
      ref.read(changePasswordFormStateProvider.notifier).updateNewPassword(
            newPasswordController.text,
          );
      _validateForm();
    });

    repeatPasswordController.addListener(() {
      ref
          .read(changePasswordFormStateProvider.notifier)
          .updateConfirmNewPassword(
            repeatPasswordController.text,
          );
      _validateForm();
    });
  }

  void _validateForm() {
    ref.read(changePasswordFormStateProvider.notifier).validate();
  }

  @override
  void dispose() {
    passwordController.dispose();
    newPasswordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(changePasswordFormStateProvider);
    final formNotifier = ref.read(changePasswordFormStateProvider.notifier);
    final SignInResult? requirePasswordChange =
        ref.watch(isNeedPasswordConfirmationProvider);
    log('requirePasswordChange: $requirePasswordChange');
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            CustomAppBar(
              uiUtils: uiUtils,
              title: 'CAMBIO DE CONTRASEÑA',
              subtitle: 'Completa los campos',
              isFromChangerPassword: true,
            ),
            SizedBox(height: uiUtils.screenHeight * 0.07),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: uiUtils.screenWidth * 0.08,
                  right: uiUtils.screenWidth * 0.08,
                  bottom: uiUtils.screenHeight * 0.08,
                ),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomFormField(
                      label: 'Contraseña actual',
                      validator: (value) => formState.currentPasswordError,
                      icon: null,
                      isPassword: true,
                      isEmail: false,
                      controller: passwordController,
                      isObscure: formState.obscurePassword,
                      onTapIcon: () {
                        formNotifier.togglePasswordVisibility();
                      },
                    ),
                    SizedBox(height: uiUtils.screenHeight * 0.03),
                    CustomFormField(
                      label: 'Nueva contraseña',
                      validator: (value) => formState.newPasswordError,
                      icon: null,
                      isPassword: true,
                      isEmail: false,
                      controller: newPasswordController,
                      isObscure: formState.obscurePassword,
                      onTapIcon: () {
                        formNotifier.togglePasswordVisibility();
                      },
                    ),
                    SizedBox(height: uiUtils.screenHeight * 0.03),
                    CustomFormField(
                      label: 'Repetir contraseña',
                      validator: (value) => formState.confirmPasswordError,
                      icon: null,
                      isPassword: true,
                      isEmail: false,
                      controller: repeatPasswordController,
                      isObscure: formState.obscurePassword,
                      onTapIcon: () {
                        formNotifier.togglePasswordVisibility();
                      },
                    ),
                    SizedBox(height: uiUtils.screenHeight * 0.2),
                    GeneralBottom(
                      width: uiUtils.screenWidth * 0.8,
                      color: formState.isValid
                          ? uiUtils.primaryColor
                          : Colors.grey,
                      text: 'CONTINUAR',
                      onTap: formState.isValid
                          ? () async {
                              try {
                                final success = await ref
                                    .read(changePasswordControllerProvider
                                        .notifier)
                                    .changePassword(
                                      passwordController.text,
                                      newPasswordController.text,
                                      requirePasswordChange,
                                    );

                                if (success) {
                                  formNotifier.clearFields();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Contraseña actualizada correctamente'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    final router =
                                        ref.read(routerDelegateProvider);
                                    router.push(AppRoute.home);
                                    ref
                                        .read(isNeedPasswordConfirmationProvider
                                            .notifier)
                                        .state = null;
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'No se pudo actualizar la contraseña.'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Error al actualizar contraseña: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            }
                          : null,
                      textColor: uiUtils.whiteColor,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
