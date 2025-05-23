// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<XFile?> checkCameraPermission(BuildContext context) async {
    try {
      final cameraStatus = await Permission.camera.request();
      final storageStatus = await Permission.photos.request();

      final bool cameraAllowed =
          cameraStatus.isGranted || cameraStatus.isLimited;
      final bool storageAllowed =
          storageStatus.isGranted || storageStatus.isLimited;

      if (cameraAllowed && storageAllowed) {
        return await _openCamera(context);
      } else {
        log('Permisos: Cámara=$cameraAllowed, Almacenamiento=$storageAllowed');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Se requieren permisos de cámara y almacenamiento.'),
          ),
        );
        await openAppSettings();
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al solicitar permisos: $e')),
      );
      return null;
    }
  }

  Future<XFile?> _openCamera(BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image != null) {
        return image; // Retorna el XFile directamente
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se seleccionó ninguna imagen')),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al abrir la cámara: ${e.toString()}')),
      );
      return null;
    }
  }

  String getNextStepText({
    required List<XFile?> aditionalImages,
    required List<XFile?> precintsImage,
    required XFile? placaImage,
    required XFile? dniImage,
    required bool isInOut,
    required bool isFromPendingTransaction,
  }) {
    if (isInOut && isFromPendingTransaction) {
      if (precintsImage.isEmpty) {
        return 'CAPTURA PRECINTOS';
      }
      if (placaImage == null) {
        return 'CAPTURA PLACA';
      } else if (dniImage == null) {
        return 'CAPTURA DNI';
      } else {
        return 'FINALIZAR';
      }
    } else {
      if (aditionalImages.isNotEmpty && precintsImage.isEmpty) {
        return 'CAPTURA PRECINTOS';
      } else if (precintsImage.isNotEmpty && placaImage == null) {
        return 'CAPTURA PLACA';
      } else if (placaImage != null && dniImage == null) {
        return 'CAPTURA DNI';
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

      case 'CAPTURA DNI':
        ref.read(routerDelegateProvider).push(
          AppRoute.takeDni,
          args: {
            'images': args?['images'],
            'isContainer': true,
          },
        );
        break;

      case 'FINALIZAR':
        ref.read(routerDelegateProvider).push(
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
    return parsedDate.toIso8601String();
  }
}
