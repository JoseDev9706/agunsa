import 'package:flutter/material.dart';

class GeneralBottom extends StatelessWidget {
  final double width;
  final Color color;
  final String text;
  final Color textColor;
  final VoidCallback? onTap;

  const GeneralBottom({super.key, required this.width, required this.color, required this.text, required this.onTap, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 38,
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),),),
      ),
    );
    
  }
}
