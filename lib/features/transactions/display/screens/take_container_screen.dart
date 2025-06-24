// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/widgets/general_bottom.dart';
import 'package:agunsa/features/transactions/data/models/foto.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/display/widgets/container_photo.dart';
import 'package:agunsa/features/transactions/display/widgets/transaction_app_bar.dart';
import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';
import 'package:agunsa/core/utils/code_utils.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class TakeContainerScreen extends ConsumerWidget {
  final TransactionType? transactionType;
  const TakeContainerScreen({super.key, this.transactionType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    final images = ref.watch(containerImageProvider);
    final isUploadingImage = ref.watch(uploadingImageProvider);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TransactionAppBar(
              uiUtils: uiUtils,
              title: '',
              onTap: () {
                ref.read(containerImageProvider.notifier).state = [];
                ref.read(routerDelegateProvider).popRoute();
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: uiUtils.primaryColor, shape: BoxShape.circle),
                    child: images.isNotEmpty && images.first != null
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                        : Text(
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
                        fontSize: uiUtils.screenWidth * 0.065,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Usamos inteligencia artificial para leer los datos.',
                    style: TextStyle(
                      color: uiUtils.black,
                      fontSize: uiUtils.screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Asegúrate de que la imagen sea clara y enfocada.',
                    style: TextStyle(
                      color: uiUtils.black,
                      fontSize: uiUtils.screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  if (images.isNotEmpty && images.first != null) ...[
                    Container(
                      height: uiUtils.screenHeight * 0.4,
                      width: uiUtils.screenWidth * 0.75,
                      decoration: BoxDecoration(
                          color: uiUtils.labelColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Image.file(
                        File(images.first!.path),
                        fit: BoxFit.fill,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GeneralBottom(
                          width: uiUtils.screenWidth * 0.4,
                          color: isUploadingImage
                              ? Colors.grey
                              : uiUtils.primaryColor,
                          text: isUploadingImage ? 'SUBIENDO...' : 'CONFIRMAR',
                          onTap: () async {
                            log('uploading image: $isUploadingImage');
                            if (!isUploadingImage) {
                              setUploadingImage(ref, true);
                              final result = await uploadImageToServer(
                                  ref, images.first!, '', null);
                              if (result != null) {
                                final re = FotoModel(
                                    codPropietario: result.codPropietario,
                                    numSerie: result.numSerie,
                                    numControl: result.numControl,
                                    tipoContenedor: result.tipoContenedor,
                                    maxGrossKg: result.maxGrossKg,
                                    maxGrossLbs: result.maxGrossLbs,
                                    taraKg: result.taraKg,
                                    taraLbs: result.taraLbs,
                                    payloadKg: result.payloadKg,
                                    payloadLbs: result.payloadLbs,
                                    responseDateTime: result.responseDateTime,
                                    imageUrl: result.imageUrl);
                                log('Image uploaded successfully: ${re.toJson()}');
                                ref.read(routerDelegateProvider).push(
                                  AppRoute.takeAditionalPhotos,
                                  args: {
                                    'images': images,
                                    'isContainer': true,
                                  },
                                );
                              } else {
                                // Mostrar SnackBar en la parte superior
                                final snackBar = SnackBar(
                                  content: const Text(
                                    'Ocurrió un error, por favor vuelve a tomar la imagen. '
                                    'Asegúrate de que sea clara y los valores sean legibles.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).padding.top + 8,
                                    left: 16,
                                    right: 16,
                                  ),
                                  backgroundColor: Colors.red.shade600,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  duration: const Duration(seconds: 4),
                                );

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                              }
                              setUploadingImage(ref, false);
                            }
                          },
                          textColor: uiUtils.whiteColor,
                        ),
                        GeneralBottom(
                          width: uiUtils.screenWidth * 0.4,
                          color: Colors.transparent,
                          text: 'REPETIR',
                          onTap: () => ref
                              .read(containerImageProvider.notifier)
                              .state = [],
                          textColor: uiUtils.primaryColor,
                        ),
                      ],
                    )
                  ] else ...[
                    ContainerPhotoWidget(uiUtils: uiUtils),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        final capturedImage =
                            await CodeUtils().checkCameraPermission(context);
                        if (capturedImage != null) {
                          ref.read(containerImageProvider.notifier).state = [
                            capturedImage
                          ];
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
                  SizedBox(height: uiUtils.screenHeight * 0.1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
