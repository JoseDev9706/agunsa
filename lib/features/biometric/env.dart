import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static bool _loaded = false;

  /// Carga un archivo .env UNA SOLA VEZ, on-demand.
  /// Si no se indica, intenta con ".env".
  static Future<void> ensureLoaded({String fileName = ".env"}) async {
    if (_loaded) return;
    await dotenv.load(fileName: fileName);
    _loaded = true;
  }

  static String? get(String key) => dotenv.maybeGet(key);
  static String getOrThrow(String key) {
    final v = dotenv.maybeGet(key);
    if (v == null || v.trim().isEmpty) {
      throw Exception("ENV '$key' no definido");
    }
    return v;
    }
}
