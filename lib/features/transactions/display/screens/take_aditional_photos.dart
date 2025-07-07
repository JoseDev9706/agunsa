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
    final images = ref.watch(aditionalImagesProvider);
    final isUploadingImage = ref.watch(uploadingImageProvider);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              TransactionAppBar(
                  uiUtils: uiUtils,
                  title: '',
                  onTap: () {
                    ref.read(aditionalImagesProvider.notifier).state = [];
                    ref.read(routerDelegateProvider).popRoute();
                  }),
              const SizedBox(height: 10),
              SizedBox(
                width: uiUtils.screenWidth * 0.6,
                child: Text(
                  textAlign: TextAlign.center,
                  'Toma  fotos laterales del contendor',
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
                  'Estas imágenes no serán procesadas por inteligencia artificial, pero quedarán guardadas como evidencia del proceso.(Hasta 4 fotos)',
                  style: TextStyle(
                    color: uiUtils.black,
                    fontSize: uiUtils.screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: uiUtils.screenWidth * 0.75,
                height: uiUtils.screenWidth * 0.75,
                decoration: BoxDecoration(
                  color: uiUtils.labelColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    Center(
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
                  if (images.length < 4) {
                    final capturedImage =
                        await CodeUtils().checkCameraPermission(context);
                    if (capturedImage != null) {
                      setState(() {
                        ref.read(aditionalImagesProvider.notifier).state =
                            images..add(capturedImage);
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Ya se han tomado las fotos necesarias')),
                    );
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
              SizedBox(height: uiUtils.screenHeight * 0.03),
              if (images.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: uiUtils.screenWidth,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...images.asMap().entries.map(
                          (entry) {
                            return Stack(
                              children: [
                                Container(
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
                                ),
                                Positioned.fill(
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
                          },
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ],
              SizedBox(height: uiUtils.screenHeight * 0.05),
              if (images.length >= 2)
                GeneralBottom(
                  width: uiUtils.screenWidth * 0.3,
                  color: isUploadingImage ? Colors.grey : uiUtils.primaryColor,
                  text: isUploadingImage ? 'SUBIENDO...' : 'CONFIRMAR',
                  onTap: () async {
                    List<Map<String, dynamic>> succesResults = [];

                    if (!isUploadingImage) {
                      setUploadingImage(ref, true);

                      try {
                        for (var image in images) {
                          final result = await uploadLateralImagesFunction(
                            ref,
                            image!,
                          );

                          log('Imagen subida: $result');
                          if (!result['imageUrl'].contains('http')) {
                            throw Exception(
                                'Error al subir una de las imágenes');
                          } else {
                            succesResults.add(result);

                            if (succesResults.length == images.length) {
                              addAdtionalUrlImages(ref, succesResults);
                              log('Todas las imágenes subidas correctamente');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Imágenes subidas correctamente'),
                                ),
                              );
                              ref.read(routerDelegateProvider).push(
                                AppRoute.containerInfo,
                                args: {
                                  'images': images,
                                  'isContainer': true,
                                },
                              );
                            }
                          }
                        }
                      } catch (e) {
                        log('Error subiendo imágenes: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Ocurrió un error al subir las imágenes'),
                          ),
                        );
                      } finally {
                        setUploadingImage(ref, false);
                      }
                    }
                  },
                  textColor: uiUtils.whiteColor,
                ),
              SizedBox(height: uiUtils.screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}