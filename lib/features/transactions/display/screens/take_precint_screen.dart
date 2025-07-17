// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/widgets/general_bottom.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/display/widgets/container_photo.dart';
import 'package:agunsa/features/transactions/display/widgets/transaction_app_bar.dart';
import 'package:agunsa/core/utils/code_utils.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:agunsa/features/transactions/domain/entities/precint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class TakePrecintScreen extends ConsumerStatefulWidget {
  const TakePrecintScreen({super.key});

  @override
  ConsumerState<TakePrecintScreen> createState() => _TakePrecintScreenState();
}

class _TakePrecintScreenState extends ConsumerState<TakePrecintScreen> {
  UiUtils uiUtils = UiUtils();
  CapturedImageData? fileTaked;

  @override
  Widget build(BuildContext context) {
    final images = ref.watch(precintsImageProvider);
    final isUploadingImage = ref.watch(uploadingImageProvider);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TransactionAppBar(
                uiUtils: uiUtils,
                title: '',
                onTap: () {
                  ref.read(precintsImageProvider.notifier).state = [];
                  ref.read(routerDelegateProvider).popRoute();
                }),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: uiUtils.primaryColor, shape: BoxShape.circle),
                      child: fileTaked != null
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                          : Text(
                              '3',
                              style: TextStyle(
                                  color: uiUtils.whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                    SizedBox(
                      width: uiUtils.screenWidth * 0.6,
                      child: Text(
                        textAlign: TextAlign.center,
                        fileTaked != null
                            ? 'Confirmación'
                            : 'Toma foto del Precindo',
                        style: TextStyle(
                            color: uiUtils.primaryColor,
                            fontSize: uiUtils.screenWidth * 0.065,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: uiUtils.screenWidth * 0.75,
                      child: Text(
                        textAlign: TextAlign.center,
                        fileTaked != null
                            ? 'Confirma que la foto este bien tomada'
                            : 'Asegúrate de que los números y letras del precinto se vean claramente antes de tomar la foto. Podras tomar hasta 4 fotos.',
                        style: TextStyle(
                          color: uiUtils.black,
                          fontSize: uiUtils.screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    fileTaked != null
                        ? Container(
                            height: uiUtils.screenHeight * 0.4,
                            width: uiUtils.screenWidth * 0.75,
                            decoration: BoxDecoration(
                                color: uiUtils.labelColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(fileTaked!.image.path),
                                width: uiUtils.screenWidth * 0.25,
                                // height: uiUtils.screenHeight * 0.1,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : ContainerPhotoWidget(
                            uiUtils: uiUtils,
                          ),
                    const SizedBox(height: 26),
                    GestureDetector(
                      onTap: () async {
                        if (images.length < 4) {
                          final capturedImage = await CodeUtils().checkCameraPermission(context);
if (capturedImage != null) {
  final captureTime = DateTime.now(); // ✅
  setState(() {
    fileTaked = CapturedImageData(
      image: capturedImage,
      captureTime: captureTime,
    );

    ref.read(precintsImageProvider.notifier).state = [
      ...images,
      CapturedImageData(image: capturedImage, captureTime: captureTime)
    ];
  });

  // ✅
  ref.read(timeSealCaptureProvider.notifier).state = captureTime;
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
                          color: uiUtils.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          height: uiUtils.screenHeight * 0.1,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...images.asMap().entries.map((entry) {
                                return Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 28),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          File(entry.value!.image.path),
                                          width: uiUtils.screenWidth * 0.25,
                                          // height: uiUtils.screenHeight * 0.1,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      top: 0,
                                      right: 0,
                                      bottom: 0,
                                      left: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          images.removeAt(entry.key);
                                          setState(() {});
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          padding: const EdgeInsets.all(2),
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              })
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GeneralBottom(
                              width: uiUtils.screenWidth * 0.4,
                              color: isUploadingImage
                                  ? Colors.grey
                                  : uiUtils.primaryColor,
                              text: isUploadingImage
                                  ? 'SUBIENDO...'
                                  : 'CONFIRMAR',
                              onTap: () async {
                                List<Precinct> precints = [];
                                if (!isUploadingImage) {
                                  setUploadingImage(ref, true);
                                  try {
                                    for (var image in images) {
                                      final result =
                                          await uploadPrecint(ref, image!.image, '');
                                      if (result != null) {
                                        precints.add(result);
                                      } else {
                                        log('Error al subir la imagen: $image');
                                        uiUtils.showSnackBar(
                                          context,
                                          'Error al subir una imagen por favor vuelva a tomar la foto y confirme',
                                        );
                                        images.remove(image);
                                        setUploadingImage(ref, false);
                                        return;
                                      }
                                    }
                                  } catch (e) {
                                    log('Error al subir las imágenes: $e');
                                    uiUtils.showSnackBar(
                                      context,
                                      'Error al subir las imágenes',
                                    );
                                    setUploadingImage(ref, false);
                                    return;
                                  }
                                  if (precints.isNotEmpty) {
                                    ref.read(precintProvider.notifier).state =
                                        precints;
                                    ref.read(routerDelegateProvider).push(
                                      AppRoute.containerInfo,
                                      args: {
                                        'images': images,
                                        'isContainer': true,
                                      },
                                    );
                                  }
                                }
                                setUploadingImage(ref, false);
                              },
                              textColor: uiUtils.whiteColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
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
