import 'package:agunsa/core/widgets/general_bottom.dart';
import 'package:agunsa/features/profile/display/widgets/custom_app_bar.dart';
import 'package:agunsa/features/profile/display/widgets/custom_form_field.dart';
import 'package:agunsa/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePassword extends ConsumerWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController passwordController = TextEditingController();
    TextEditingController newPasswordcontroller = TextEditingController();
    TextEditingController repeatPasswordcontroller = TextEditingController();
    bool isButtonEnabled = false;
    UiUtils uiUtils = UiUtils();
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(
              uiUtils: uiUtils,
              title: 'CAMBIO DE CONTRASEÑA',
              subtitle: 'Completa los campos',
            ),
            SizedBox(height: uiUtils.screenHeight * 0.07),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                    left: uiUtils.screenWidth * 0.08,
                    right: uiUtils.screenWidth * 0.08,
                    bottom: uiUtils.screenHeight * 0.08),
                child: Column(
                  children: [
                    CustomFormField(
                        label: 'Contraseña actual',
                        validator: (value) {
                          return null;
                        },
                        icon: null,
                        isPassword: true,
                        isEmail: false,
                        controller: passwordController,
                        isObscure: true),
                    SizedBox(height: uiUtils.screenHeight * 0.03),
                    CustomFormField(
                        label: 'Nueva contraseña',
                        validator: (value) {
                          return null;
                        },
                        icon: null,
                        isPassword: true,
                        isEmail: false,
                        controller: newPasswordcontroller,
                        isObscure: true),
                    SizedBox(height: uiUtils.screenHeight * 0.03),
                    CustomFormField(
                        label: 'Repetir Contraseña',
                        validator: (value) {
                          return null;
                        },
                        icon: null,
                        isPassword: true,
                        isEmail: false,
                        controller: repeatPasswordcontroller,
                        isObscure: true),
                    const Spacer(),
                    GeneralBottom(
                      width: uiUtils.screenWidth * 0.8,
                      color:
                          isButtonEnabled ? uiUtils.primaryColor : Colors.grey,
                      text: 'CONTINUAR',
                      onTap: isButtonEnabled ? () {} : null,
                      textColor: uiUtils.whiteColor,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
