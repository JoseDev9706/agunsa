import 'dart:developer';
import 'dart:io';

import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/widgets/general_bottom.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/display/widgets/transaction_app_bar.dart';
import 'package:agunsa/utils/code_utils.dart';
import 'package:agunsa/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class TakeAditionalPhotos extends ConsumerWidget {
  const TakeAditionalPhotos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    final images = ref.watch(imageProvider);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TransactionAppBar(
              uiUtils: uiUtils,
              title: '',
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    width: uiUtils.screenWidth * 0.6,
                    child: Text(
                      textAlign: TextAlign.center,
                      'Toma dos fotos laterales del contendor',
                      style: TextStyle(
                          color: uiUtils.primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: uiUtils.screenWidth * 0.75,
                    child: Text(
                      textAlign: TextAlign.center,
                      'Estas imágenes no serán procesadas por inteligencia artificial, pero quedarán guardadas como evidencia del proceso.',
                      style: TextStyle(
                        color: uiUtils.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 60),
                    decoration: BoxDecoration(
                        color: uiUtils.labelColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Stack(
                      children: [
                        SvgPicture.asset('assets/svg/camera_port.svg'),
                        Positioned.fill(
                          child: Center(
                            child: SvgPicture.asset('assets/svg/camera.svg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                     if (images.length < 3) {
                         final capturedImage =
                          await CodeUtils().checkCameraPermission(context);
                      if (capturedImage != null) {
                        ref.read(imageProvider.notifier).state = images
                          ..add(capturedImage);
                      }
                      }else {
                        log('Ya se han tomado las fotos necesarias');
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
                  const SizedBox(height: 20),
                  if (images.length >= 3) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        children: [
                          ...images
                              .asMap()
                              .entries
                              .where((entry) => entry.key >= 1)
                              .map((entry) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              height: uiUtils.screenHeight * 0.09,
                              width: uiUtils.screenWidth * 0.2,
                              decoration: BoxDecoration(
                                color: uiUtils.labelColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.file(
                                  File(entry.value!.path),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            );
                          }),
                          Spacer(),
                          GeneralBottom(
                            width: uiUtils.screenWidth * 0.3,
                            color: uiUtils.primaryColor,
                            text: 'CONFIRMAR',
                            onTap: () {
                              ref.read(routerDelegateProvider).push(AppRoute.containerInfo,
                                  args: {
                                    'images': images,
                                    'isContainer': true,
                                  });
                            },
                            textColor: uiUtils.whiteColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
