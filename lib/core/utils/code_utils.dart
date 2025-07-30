// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class CodeUtils {
  CodeUtils._privateConstructor();
  static final CodeUtils _instance = CodeUtils._privateConstructor();
  factory CodeUtils() => _instance;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Ingrese su email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Ingrese su contraseña';
    if (value.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  /// --- Pide permisos y abre cámara, con logs extra para debug ---
  Future<XFile?> checkCameraPermission(BuildContext context) async {
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      log('=== [Camera] SDK version: $sdkInt');

      bool cameraGranted = false;
      bool mediaGranted = false;

      // ===== Permisos para Android =====
      if (Platform.isAndroid) {
        log('=== [Camera] Chequeando permiso de cámara');
        final cameraStatus = await Permission.camera.status;
        log('=== [Camera] Estado permiso cámara: $cameraStatus');

        if (!cameraStatus.isGranted) {
          final result = await Permission.camera.request();
          log('=== [Camera] Permiso de cámara solicitado, resultado: $result');
          cameraGranted = result.isGranted;
        } else {
          cameraGranted = true;
        }

        if (sdkInt < 33) {
          // Android 12 o menor (API 32 o menor) -> Pedir READ_EXTERNAL_STORAGE
          log('=== [Camera] Chequeando permiso de storage');
          final storageStatus = await Permission.storage.status;
          log('=== [Camera] Estado permiso storage: $storageStatus');
          if (!storageStatus.isGranted) {
            final result = await Permission.storage.request();
            log('=== [Camera] Permiso de storage solicitado, resultado: $result');
            mediaGranted = result.isGranted;
          } else {
            mediaGranted = true;
          }
        } else {
          // Android 13+ (API 33 o mayor) -> Pedir READ_MEDIA_IMAGES
          log('=== [Camera] Chequeando permiso de media/photos');
          final mediaStatus = await Permission.photos.status;
          log('=== [Camera] Estado permiso photos: $mediaStatus');
          if (!mediaStatus.isGranted && !mediaStatus.isLimited) {
            final result = await Permission.photos.request();
            log('=== [Camera] Permiso de photos solicitado, resultado: $result');
            mediaGranted = result.isGranted || result.isLimited;
          } else {
            mediaGranted = true;
          }
        }

        // Si ambos permisos están concedidos
        log('=== [Camera] cameraGranted: $cameraGranted, mediaGranted: $mediaGranted');
        if (cameraGranted && mediaGranted) {
          log('=== [Camera] Permisos OK. Abriendo cámara...');
          final result = await _openCamera(context);
          log('=== [Camera] Cámara cerrada, resultado: $result');
          return result;
        } else {
          _showPermissionDeniedSnack(context);
          log('=== [Camera] Permiso denegado. Abriendo ajustes si está denegado permanentemente.');
          if (await Permission.camera.isPermanentlyDenied ||
              (sdkInt < 33 && await Permission.storage.isPermanentlyDenied) ||
              (sdkInt >= 33 && await Permission.photos.isPermanentlyDenied)) {
            await openAppSettings();
          }
          return null;
        }
      }

      // ===== Permisos para iOS =====
      else if (Platform.isIOS) {
        final cameraStatus = await Permission.camera.status;
        final photosStatus = await Permission.photos.status;

        if (!cameraStatus.isGranted) {
          final result = await Permission.camera.request();
          cameraGranted = result.isGranted;
        } else {
          cameraGranted = true;
        }

        if (!photosStatus.isGranted && !photosStatus.isLimited) {
          final result = await Permission.photos.request();
          mediaGranted = result.isGranted || result.isLimited;
        } else {
          mediaGranted = true;
        }

        log('=== [Camera] [iOS] cameraGranted: $cameraGranted, mediaGranted: $mediaGranted');
        if (cameraGranted && mediaGranted) {
          log('PERMISOS OK. Abriendo cámara...');
          final result = await _openCamera(context);
          log('Cámara cerrada, resultado: $result');
          return result;
        } else {
          _showPermissionDeniedSnack(context);
          if (await Permission.camera.isPermanentlyDenied ||
              await Permission.photos.isPermanentlyDenied) {
            await openAppSettings();
          }
          return null;
        }
      }

      // Si no es Android ni iOS
      return null;
    } catch (e, st) {
      log('[ERROR] checkCameraPermission: $e\n$st');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al verificar permisos: $e')),
      );
      return null;
    }
  }

  void _showPermissionDeniedSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Se requieren permisos de cámara y almacenamiento.'),
      ),
    );
  }

  Future<XFile?> _openCamera(BuildContext context) async {
    try {
      PaintingBinding.instance.imageCache.clear();
      log('=== [Camera] Llamando ImagePicker().pickImage...');
      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
        maxWidth: 800,
        maxHeight: 600,
      );
      log('=== [Camera] Resultado de pickImage: $image');

      if (image != null) {
        return image;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se seleccionó ninguna imagen')),
        );
        return null;
      }
    }
    on PlatformException catch (e, st) {
      // Errores lanzados por el canal de plataforma (Android/iOS)
      log('[PlatformException] _openCamera: $e', stackTrace: st);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de plataforma al abrir cámara: ${e.message}')),
      );
      return null;
    }
    catch (e, st) {
      // Cualquier otro error
      log('[ERROR genérico] _openCamera: $e', stackTrace: st);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al abrir la cámara: $e')),
      );
      return null;
    }
  }

  // --- Métodos utilitarios (sin cambios) ---
  String getNextStepText({
    required List<XFile?> aditionalImages,
    required List<XFile?> precintsImage,
    required XFile? placaImage,
    required XFile? dniImage,
    required bool isInOut,
    required bool isFromPendingTransaction,
  }) {
    if (isInOut && isFromPendingTransaction) {
      if (precintsImage.isEmpty) return 'CAPTURA PRECINTOS';
      if (placaImage == null) return 'CAPTURA PLACA';
      if (dniImage == null) return 'CAPTURA LICENCIA';
      return 'FINALIZAR';
    } else {
      if (aditionalImages.isNotEmpty && precintsImage.isEmpty) {
        return 'CAPTURA PRECINTOS';
      } else if (precintsImage.isNotEmpty && placaImage == null) {
        return 'CAPTURA PLACA';
      } else if (placaImage != null && dniImage == null) {
        return 'CAPTURA LICENCIA';
      } else if (dniImage != null) {
        return 'FINALIZAR';
      } else {
        return 'INICIAR';
      }
    }
  }

  void handleNextStep({
    required WidgetRef ref,
    required String stepText,
    required Map<String, dynamic>? args,
  }) {
    log('Step: $stepText');
    switch (stepText) {
      case 'CAPTURA PRECINTOS':
        ref.read(routerDelegateProvider).push(
          AppRoute.takePrecint,
          args: {
            'images': args?['images'],
            'isContainer': true,
          },
        );
        break;
      case 'CAPTURA PLACA':
        ref.read(routerDelegateProvider).push(
          AppRoute.talePlaca,
          args: {
            'images': args?['images'],
            'isContainer': true,
          },
        );
        break;
      case 'CAPTURA LICENCIA':
        ref.read(routerDelegateProvider).push(
          AppRoute.takeDni,
          args: {
            'images': args?['images'],
            'isContainer': true,
          },
        );
        break;
      case 'FINALIZAR':
        ref.read(routerDelegateProvider).pushAndRemoveAll(
          AppRoute.resumeTransaction,
          args: {
            'images': args?['images'],
            'isContainer': true,
          },
        );
        break;
      default:
        ref.read(routerDelegateProvider).push(
          AppRoute.containerInfo,
          args: {
            'images': args?['images'],
            'isContainer': true,
          },
        );
        break;
    }
  }

  String formatDateToIso8601(String date) {
    DateTime parsedDate = DateTime.parse(date);
    parsedDate = parsedDate.copyWith(millisecond: 0, microsecond: 0);
    // Devuelve solo hasta los segundos, sin los .000
    return parsedDate.toIso8601String().replaceAll('.000', '');
  }
}
