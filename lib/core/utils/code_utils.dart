// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
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
}
