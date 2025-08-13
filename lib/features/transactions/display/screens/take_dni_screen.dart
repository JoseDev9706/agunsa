import 'dart:developer';
import 'dart:io';

import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/widgets/general_bottom.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/display/widgets/transaction_app_bar.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
// Quita image_picker
import 'package:camera/camera.dart';

import '../../../../core/utils/camera.dart'; // importa tu cámara

class TakeDniScreen extends ConsumerStatefulWidget {
  const TakeDniScreen({super.key});

  @override
  ConsumerState<TakeDniScreen> createState() => _TakeDniScreenState();
}

class _TakeDniScreenState extends ConsumerState<TakeDniScreen> {
  UiUtils uiUtils = UiUtils();
  CapturedImageData? fileTaked;

  @override
  Widget build(BuildContext context) {
    final image = ref.watch(dniImageProvider);
    final isUploadingImage = ref.watch(uploadingImageProvider);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TransactionAppBar(
                uiUtils: uiUtils,
                title: '',
                onTap: () {
                  ref.read(dniImageProvider.notifier).state = null;
                  ref.read(routerDelegateProvider).popRoute();
                }),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: uiUtils.primaryColor, shape: BoxShape.circle),
                    child: fileTaked != null
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          )
                        : Text(
                            '4',
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
                          : 'Toma una foto de la Licencia del transportista',
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
                      fileTaked != null
                          ? 'Confirma que la foto este bien tomada'
                          : 'Asegúrate de que los datos estén bien visibles y la imagen sea clara para poder extraer la información correctamente.',
                      style: TextStyle(
                        color: uiUtils.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  fileTaked != null
                      ? Container(
                          height: uiUtils.screenHeight * 0.15,
                          width: uiUtils.screenWidth * 0.75,
                          decoration: BoxDecoration(
                              color: uiUtils.labelColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(fileTaked!.image.path),
                              width: uiUtils.screenWidth * 0.25,
                              fit: BoxFit.cover,
                              cacheWidth: (uiUtils.screenWidth * 0.75).toInt(),
                              cacheHeight: (uiUtils.screenHeight * 0.4).toInt(),
                            ),
                          ),
                        )
                      : Container(
                          height: uiUtils.screenHeight * 0.2,
                          width: uiUtils.screenWidth * 0.75,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              color: uiUtils.labelColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                            children: [
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(25),
                                  child: SvgPicture.asset(
                                    'assets/svg/person.svg',
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: SvgPicture.asset(
                                      'assets/svg/marc_placa.svg'),
                                ),
                              ),
                            ],
                          )),
                  const SizedBox(height: 56),
                  fileTaked != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                    if (!isUploadingImage) {
                                      setUploadingImage(ref, true);
                                      if (fileTaked != null) {
                                        ref.read(dniImageProvider.notifier).state =
                                            CapturedImageData(
                                              image: fileTaked!.image,
                                              captureTime: fileTaked!.captureTime,
                                            );
                                        ref.read(timeDriverCaptureProvider.notifier).state =
                                            fileTaked!.captureTime;

                                        final result = await getDniInfo(ref, fileTaked!.image);

                                        if (result != null) {
                                          ref.read(routerDelegateProvider).push(
                                            AppRoute.containerInfo,
                                            args: {'isContainer': true},
                                          );
                                        } else {
                                          fileTaked = null;
                                          ref.read(dniImageProvider.notifier).state = null;
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Ocurrió un error al obtener la información de la Licencia'),
                                            ),
                                          );
                                          log('Error al obtener la información de la Licencia');
                                        }
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
                                  onTap: () async {
                                    fileTaked = null;
                                    PaintingBinding.instance.imageCache.clear();
                                    log('==> Abrir cámara custom');
                                    final XFile? capturedImage = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const CustomCameraScreen(),
                                      ),
                                    );
                                    if (capturedImage != null) {
                                      final capturedData = CapturedImageData(
                                        image: capturedImage,
                                        captureTime: DateTime.now(),
                                      );

                                      ref.read(dniImageProvider.notifier).state = capturedData;

                                      setState(() {
                                        fileTaked = capturedData;
                                      });
                                    }
                                  },
                                  textColor: uiUtils.primaryColor,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        )
                      : GestureDetector(
                          onTap: () async {
                            try {
                              if (image == null) {
                                PaintingBinding.instance.imageCache.clear();
                                log('==> Abrir cámara custom');
                                final XFile? capturedImage = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CustomCameraScreen(),
                                  ),
                                );
                                if (capturedImage != null) {
                                  final captureTime = DateTime.now();
                                  setState(() {
                                    fileTaked = CapturedImageData(
                                      image: capturedImage,
                                      captureTime: captureTime,
                                    );
                                  });
                                  ref.read(timeCreationTransactionProvider.notifier).state ??= captureTime;
                                }
                              } else {
                                log('Ya se han tomado las fotos necesarias');
                              }
                            } catch (e, st) {
                              log('ERROR capturando imagen: $e\n$st');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error al tomar foto: $e')),
                              );
                            }
                          },
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: uiUtils.labelColor,
                            child: SvgPicture.asset(
                              'assets/svg/camera.svg',
                              width: 25,
                              color: uiUtils.primaryColor,
                            ),
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
