import 'package:flutter/material.dart';

class GeneralBottom extends StatelessWidget {
  final double width;
  final Color color;
  final String text;
  final Color textColor;
  final VoidCallback? onTap;
  final Widget? icon;

  const GeneralBottom(
      {super.key,
      required this.width,
      required this.color,
      required this.text,
      required this.onTap,
      required this.textColor,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 38,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: textColor, width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? const SizedBox.shrink(),
            const SizedBox(width: 10),
            Center(
              child: Text(
                text,
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
