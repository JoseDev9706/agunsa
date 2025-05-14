import 'package:agunsa/features/auth/display/widgets/login_form.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UiUtils uiUtils = UiUtils();
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: SvgPicture.asset(
            "assets/svg/primary-logo.svg",
            height: uiUtils.screenHeight * 0.04,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "GATE.AI",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const LoginForm()
      ]),
    );
  }
}
