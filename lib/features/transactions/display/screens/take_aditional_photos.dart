import 'dart:developer';
import 'dart:io';

import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/widgets/general_bottom.dart';
import 'package:agunsa/features/auth/domain/entities/user_entity.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/display/widgets/transaction_app_bar.dart';
import 'package:agunsa/core/utils/code_utils.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class TakeAditionalPhotos extends ConsumerStatefulWidget {
  // final UserEntity user;
  const TakeAditionalPhotos({
    super.key,
    // required this.user,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TakeAditionalPhotosState();
}

class _TakeAditionalPhotosState extends ConsumerState<TakeAditionalPhotos> {
  @override
  Widget build(BuildContext context) {
    UiUtils uiUtils = UiUtils();
    final images = ref.watch(imageProvider);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
          children: [
            TransactionAppBar(
              uiUtils: uiUtils,
              title: '',
              ),
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
              const SizedBox(height: 20),
              Container(
                width: uiUtils.screenWidth * 0.7,
                height: uiUtils.screenWidth * 0.7,
                decoration: BoxDecoration(
                  color: uiUtils.labelColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SvgPicture.asset(
                        'assets/svg/camera_port.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/svg/camera.svg',
                          width: uiUtils.screenWidth * 0.2,
                          height: uiUtils.screenWidth * 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: uiUtils.screenHeight * 0.05),
              GestureDetector(
                onTap: () async {
                  if (images.length < 3) {
                    final capturedImage =
                        await CodeUtils().checkCameraPermission(context);
                    if (capturedImage != null) {
                      setState(() {
                        ref.read(imageProvider.notifier).state = images
                          ..add(capturedImage);
                      });
                    }
                  } else {
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
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (images.length >= 2) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...images
                          .asMap()
                          .entries
                          .where((entry) => entry.key >= 1)
                          .map(
                        (entry) {
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
                        },
                      ),
                      Expanded(
                        child: GeneralBottom(
                          width: uiUtils.screenWidth * 0.3,
                          color: uiUtils.primaryColor,
                          text: 'CONFIRMAR',
                          onTap: () {
                            ref.read(routerDelegateProvider).push(
                              AppRoute.containerInfo,
                              args: {
                                'images': images,
                                'isContainer': true,
                              },
                            );
                          },
                          textColor: uiUtils.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
