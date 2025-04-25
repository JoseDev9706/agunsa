import 'dart:developer';

import 'package:agunsa/core/class/auth_result.dart';
import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/widgets/general_bottom.dart';
import 'package:agunsa/features/auth/display/providers/auth_providers.dart';
import 'package:agunsa/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/routes_provider.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(loginFormStateProvider);
    final formNotifier = ref.read(loginFormStateProvider.notifier);
    final loginState = ref.watch(loginControllerProvider);
    final uiUtils = UiUtils();

    // Validadores
    String? validateEmail(String? value) {
      if (value == null || value.isEmpty) return 'Ingrese su email';
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return 'Email inválido';
      }
      return null;
    }

    String? validatePassword(String? value) {
      if (value == null || value.isEmpty) return 'Ingrese su contraseña';
      if (value.length < 6) return 'Mínimo 6 caracteres';
      return null;
    }

    return Padding(
      padding: const EdgeInsets.all(22),
      child: Form(
        // Quitamos el autovalidateMode para validar solo al enviar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo Email
            Text('Email',
                style: TextStyle(
                  color: uiUtils.grayDarkColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
            Container(
              decoration: BoxDecoration(
                color: uiUtils.labelColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: formState.emailError != null
                      ? uiUtils.primaryColor
                      : uiUtils.grayLightColor,
                  width: 1.5,
                ),
              ),
              child: TextFormField(
                onChanged: formNotifier.updateEmail,
                decoration: InputDecoration(
                  hintText: 'name@agunsa.com',
                  hintStyle: TextStyle(color: uiUtils.grayLightColor),
                  prefixIcon:
                      Icon(Icons.person, color: uiUtils.primaryLigthColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 12,
                  ),
                ),
              ),
            ),
            // Mensaje de error fuera del Container
            if (formState.emailError != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  formState.emailError!,
                  style: TextStyle(
                    color: uiUtils.primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Campo Contraseña
            Text('Contraseña',
                style: TextStyle(
                  color: uiUtils.grayDarkColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
            Container(
              decoration: BoxDecoration(
                color: uiUtils.labelColor,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: formState.passwordError != null
                      ? uiUtils.primaryColor
                      : uiUtils.grayLightColor,
                  width: 1.5,
                ),
              ),
              child: TextFormField(
                onChanged: formNotifier.updatePassword,
                obscureText: formState.obscurePassword,
                decoration: InputDecoration(
                  hintText: '********',
                  hintStyle: TextStyle(color: uiUtils.grayLightColor),
                  prefixIcon:
                      Icon(Icons.lock, color: uiUtils.primaryLigthColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 12,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      formState.obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: uiUtils.grayDarkColor,
                    ),
                    onPressed: formNotifier.togglePasswordVisibility,
                  ),
                ),
              ),
            ),
            // Mensaje de error fuera del Container
            if (formState.passwordError != null) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  formState.passwordError!,
                  style: TextStyle(
                    color: uiUtils.primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),

            // Olvidé contraseña
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '¿Has olvidado tu contraseña?',
                  style: TextStyle(
                    color: uiUtils.grayDarkColor,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

            // Botón de enviar
            Center(
              child: GeneralBottom(
                width: uiUtils.screenWidth * 0.7,
                color: loginState.isLoading
                    ? uiUtils.grayLightColor
                    : uiUtils.primaryColor,
                onTap: () async {
                  log('Login form submitted');
                  final emailError = validateEmail(formState.email);
                  final passwordError = validatePassword(formState.password);

                  formNotifier.setEmailError(emailError ?? '');
                  formNotifier.setPasswordError(passwordError ?? '');

                  if (emailError == null && passwordError == null) {
                    final result =
                        await ref.read(loginControllerProvider.notifier).login(
                              formState.email,
                              formState.password,
                            );
                    if (result != null) {
                      log('Login result: ${result.toString()}');
                      if (result is AuthSuccess) {
                        log('Login exitoso: ${result.user.email}');
                        final router = ref.read(routerDelegateProvider);
                        router.pushReplacement(AppRoute.home, args: {
                          'user': result.user,
                        });
                      } else if (result is AuthFailure) {
                        log('Error de login: ${result.message}');
                      } else if (result is RequirePasswordChange) {
                        log('Cambio de contraseña requerido: ${result.nextStep}');
                        final router = ref.read(routerDelegateProvider);
                        router.pushReplacement(AppRoute.home, args: {
                          'nextStep': result.nextStep,
                        });
                      } else {
                        log('Error inesperado: ${result.toString()}');
                      }
                    }
                  }
                },
                text: loginState.isLoading ? 'CARGANDO...' : 'COMENZAR',
                textColor: uiUtils.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
