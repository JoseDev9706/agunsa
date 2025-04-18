import 'dart:io';

import 'package:agunsa/core/widgets/general_bottom.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/display/widgets/transaction_app_bar.dart';
import 'package:agunsa/utils/code_utils.dart';
import 'package:agunsa/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class TakeContainerScreen extends ConsumerWidget {
  const TakeContainerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    final image = ref.watch(imageProvider);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TransactionAppBar(
              uiUtils: uiUtils,
              title: '',
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                          color: uiUtils.primaryColor, shape: BoxShape.circle),
                      child: Text(
                        '1',
                        style: TextStyle(
                            color: uiUtils.whiteColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Toma una foto del contenedor',
                      style: TextStyle(
                          color: uiUtils.primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Usamos inteligencia artificial para leer los datos.',
                      style: TextStyle(
                        color: uiUtils.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Asegurate de que la imagen sea clara y enfocada.',
                      style: TextStyle(
                        color: uiUtils.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (image != null) ...[
                      Container(
                        height: uiUtils.screenHeight * 0.4,
                        width: uiUtils.screenWidth * 0.75,
                        decoration: BoxDecoration(
                            color: uiUtils.labelColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Image.file(
                            File(
                              image.path,
                            ),
                            fit: BoxFit.fill),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GeneralBottom(
                            width: uiUtils.screenWidth * 0.4,
                            color: uiUtils.primaryColor,
                            text: 'CONFIRMAR',
                            onTap: () {},
                            textColor: uiUtils.whiteColor,
                          ),
                          GeneralBottom(
                            width: uiUtils.screenWidth * 0.4,
                            color: Colors.transparent,
                            text: 'REPETIR',
                            onTap: () =>
                                ref.read(imageProvider.notifier).state = null,
                            textColor: uiUtils.primaryColor,
                          ),
                        ],
                      )
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 60),
                        decoration: BoxDecoration(
                            color: uiUtils.labelColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Stack(
                          children: [
                            SvgPicture.asset('assets/svg/camera_port.svg'),
                            Positioned.fill(
                              child: Center(
                                child:
                                    SvgPicture.asset('assets/svg/camera.svg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          final capturedImage =
                              await CodeUtils().checkCameraPermission(context);
                          if (capturedImage != null) {
                            ref.read(imageProvider.notifier).state =
                                capturedImage;
                          }
                        },
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: uiUtils.labelColor,
                          child: SvgPicture.asset(
                            'assets/svg/camera.svg',
                            width: 25,
                            height: 25,
                            color: uiUtils.primaryColor,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
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
