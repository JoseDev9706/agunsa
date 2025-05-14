import 'dart:developer';
import 'dart:io';

import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/widgets/general_bottom.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/display/widgets/transaction_app_bar.dart';
import 'package:agunsa/core/utils/code_utils.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class TakePlacaScreen extends ConsumerStatefulWidget {
  const TakePlacaScreen({super.key});

  @override
  ConsumerState<TakePlacaScreen> createState() => _TakePrecintScreenState();
}

class _TakePrecintScreenState extends ConsumerState<TakePlacaScreen> {
  UiUtils uiUtils = UiUtils();
  XFile? fileTaked;

  @override
  Widget build(BuildContext context) {
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
                children: [
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(18),
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
                          : 'Toma una foto de la placa del camión',
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
                          : 'Asegúrate de que los números y letras de la placa se vean claramente antes de tomar la foto',
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
                              File(fileTaked!.path),
                              width: uiUtils.screenWidth * 0.25,
                              // height: uiUtils.screenHeight * 0.1,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          height: uiUtils.screenHeight * 0.15,
                          width: uiUtils.screenWidth * 0.75,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                              color: uiUtils.labelColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: SvgPicture.asset(
                            'assets/svg/marc_placa.svg',
                            height: uiUtils.screenHeight * 0.40,
                            width: uiUtils.screenWidth * 0.85,
                          ),
                        ),
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
                                  color: uiUtils.primaryColor,
                                  text: 'CONFIRMAR',
                                  onTap: () async {
                                    ref.read(imageProvider.notifier).state =
                                        images..add(fileTaked);
                                    await getPlacaInfo(ref, fileTaked!, '');
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
                                GeneralBottom(
                                  width: uiUtils.screenWidth * 0.4,
                                  color: Colors.transparent,
                                  text: 'REPETIR',
                                  onTap: () async {
                                    fileTaked = null;
                                    final capturedImage = await CodeUtils()
                                        .checkCameraPermission(context);
                                    if (capturedImage != null) {
                                      setState(() {
                                        fileTaked = capturedImage;
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
                            if (images.length < 5) {
                              final capturedImage = await CodeUtils()
                                  .checkCameraPermission(context);
                              if (capturedImage != null) {
                                setState(() {
                                  fileTaked = capturedImage;
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
