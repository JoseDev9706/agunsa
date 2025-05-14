import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageCaptureWidget extends ConsumerWidget {
  final String title;
  final String subtitle;
  const ImageCaptureWidget(this.title, this.subtitle, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
              color: uiUtils.primaryColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          textAlign: TextAlign.center,
          subtitle,
          style: TextStyle(
            color: uiUtils.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 40),
        // Add your image capture widget here
        Container(
          width: 300,
          height: 300,
          color: Colors.grey[200],
          child: const Center(
            child: Icon(Icons.camera_alt, size: 50, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
