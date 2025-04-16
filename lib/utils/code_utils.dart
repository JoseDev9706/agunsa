import 'package:agunsa/utils/ui_utils.dart';

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
}
