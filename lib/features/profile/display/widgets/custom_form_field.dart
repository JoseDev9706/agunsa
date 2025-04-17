import 'package:agunsa/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isPassword;
  final bool isEmail;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool isObscure;
  const CustomFormField(
      {super.key,
      required this.label,
      this.icon,
      required this.isPassword,
      required this.isEmail,
      this.validator,
      required this.controller,
      required this.isObscure});

  @override
  Widget build(BuildContext context) {
    UiUtils uiUtils = UiUtils();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: uiUtils.optionsColor),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
            color: uiUtils.whiteColor,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 10, offset: Offset(0, 10))
            ],
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            obscureText: isObscure,
            decoration: InputDecoration(
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                prefixIcon: icon == null ? null : Icon(icon),
                suffixIcon: isPassword
                    ? IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_red_eye),
                      )
                    : null),
          ),
        )
      ],
    );
  }
}
