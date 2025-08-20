// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:agunsa/features/biometric/env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

/// ====== LOGGING CONFIG ======
const bool kKeynuaVerboseLogs = true;
String _mask(String s, {int left = 4, int right = 4}) {
  if (s.isEmpty) return '""';
  if (s.length <= left + right) return '*' * s.length;
  return '${s.substring(0, left)}${'*' * (s.length - left - right)}${s.substring(s.length - right)}';
}
String _trunc(String s, [int max = 800]) => s.length <= max ? s : s.substring(0, max);

/// DNI helper: deja solo dígitos; si >8 usa los últimos 8
String _sanitizePeruDni(String input) {
  final digitsOnly = input.replaceAll(RegExp(r'\D'), '');
  if (digitsOnly.length > 8) return digitsOnly.substring(digitsOnly.length - 8);
  return digitsOnly;
}

/// =====================================================
/// 1) CONFIG (directo a Keynua, SIN backend propio)
/// =====================================================
class KeynuaConfig {
  KeynuaConfig({
    required this.baseUrl,
    required this.apiKey,
    required this.apiToken,
    required this.signBase,
  });

  /// https://api.stg.keynua.com | https://api.keynua.com
  final String baseUrl;

  /// x-api-key (NO exponer en producción real: aquí es PoC/móvil)
  final String apiKey;

  /// authorization (en minúsculas, SIN “Bearer ”)
  final String apiToken;

  /// https://sign.stg.keynua.com o https://sign.keynua.com
  final String signBase;
}

/// Lee .env sin tocar main
final keynuaConfigProvider = Provider<KeynuaConfig>((ref) {
  final baseUrl = (Env.getOrThrow('KEYNUA_BASE_URL')).trim();
  final apiKey  = (Env.getOrThrow('KEYNUA_API_KEY')).trim();
  final apiTok  = (Env.getOrThrow('KEYNUA_API_TOKEN')).trim(); // sin Bearer
  final signOverride = (Env.get('KEYNUA_SIGN_URL') ?? '').trim();
  String computeSignBase(String apiBase) {
    if (signOverride.isNotEmpty) return signOverride;
    final isStg = apiBase.contains('stg');
    return isStg ? 'https://sign.stg.keynua.com' : 'https://sign.keynua.com';
  }
  final cfg = KeynuaConfig(
    baseUrl: baseUrl,
    apiKey: apiKey,
    apiToken: apiTok,
    signBase: computeSignBase(baseUrl),
  );
  if (kKeynuaVerboseLogs) {
    debugPrint('[KEYNUA] .env loaded: baseUrl=$baseUrl, signBase=${cfg.signBase}, '
        'x-api-key=${_mask(apiKey)}, token=${_mask(apiTok)}');
  }
  return cfg;
});

/// Estado simple para marcar done/id/tiempo/estado
final biometricDoneProvider = StateProvider<bool>((_) => false);
final biometricVerificationIdProvider = StateProvider<String?>((_) => null);
final timeBiometricCaptureProvider = StateProvider<DateTime?>((_) => null);
final biometricStatusProvider = StateProvider<String?>((_) => null);

/// =====================================================
/// 2) CLIENTE KEYNUA (payload mínimo – SOLO 3D/LIVENESS)
/// =====================================================
class KeynuaClient {
  KeynuaClient(this.config);
  final KeynuaConfig config;

  /// PUT /identity-verification/v1 → { id, userToken }
  ///
  /// Headers EXACTOS:
  ///   - x-api-key: <KEY>
  ///   - authorization: <TOKEN>   (minúsculas, sin Bearer)
  ///   - Content-Type: application/json
  ///
  /// Body mínimo:
  ///   - title
  ///   - documentNumber
  ///   - documentType: "pe-dni"
  ///   - type: "liveness"  (3D)
  ///   - disableInitialNotification: false
  Future<({String verificationId, String userToken})> createLivenessVerification({
    required String documentNumberSanitized, // 8 dígitos
    required String title,
    String documentType = 'pe-dni',
    bool disableInitialNotification = false,
  }) async {
    final url = '${config.baseUrl}/identity-verification/v1';
    final uri = Uri.parse(url);

    final headers = <String, String>{
      'x-api-key': config.apiKey,
      'authorization': config.apiToken, // minúsculas, SIN 'Bearer '
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final bodyMap = <String, dynamic>{
      'title': title,
      'documentNumber': documentNumberSanitized,
      'documentType': documentType,
      'type': 'liveness', // <-- SIEMPRE 3D
      'disableInitialNotification': disableInitialNotification,
    };
    final bodyJson = jsonEncode(bodyMap);

    if (kKeynuaVerboseLogs) {
      debugPrint('[KEYNUA] PUT $url');
      debugPrint('[KEYNUA]   headers: x-api-key=${_mask(config.apiKey)}, '
          'authorization=${_mask(config.apiToken)}');
      debugPrint('[KEYNUA]   body: $bodyJson');
    }

    final res = await http.put(uri, headers: headers, body: bodyJson);

    if (kKeynuaVerboseLogs) {
      debugPrint('[KEYNUA] status=${res.statusCode}, resp=${_trunc(res.body)}');
    }

    if (res.statusCode < 200 || res.statusCode >= 300) {
      try {
        final err = jsonDecode(res.body) as Map<String, dynamic>;
        final code = err['code'] ?? 'Unknown';
        final msg  = err['message'] ?? res.body;
        throw Exception('Keynua error: ${res.statusCode} [$code] $msg');
      } catch (_) {
        throw Exception('Keynua error: ${res.statusCode} ${res.body}');
      }
    }

    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final verificationId = (map['id'] ?? map['verificationId']).toString();
    final token = map['userToken'] as String;
    return (verificationId: verificationId, userToken: token);
  }
}

/// =====================================================
/// 3) WEBVIEW (permisos cámara/mic y callbacks done/error)
/// =====================================================
class KeynuaBiometricScreen extends ConsumerStatefulWidget {
  const KeynuaBiometricScreen({
    super.key,
    required this.token,
    required this.onDone,
  });

  final String token;
  final void Function(String verificationId) onDone;

  @override
  ConsumerState<KeynuaBiometricScreen> createState() =>
      _KeynuaBiometricScreenState();
}

class _KeynuaBiometricScreenState extends ConsumerState<KeynuaBiometricScreen> {
  late final WebViewController _controller;
  final _scheme = 'myapp';
  final _doneHost = 'keynua.done';
  final _errorHost = 'keynua.error';
  final _logHost = 'keynua.log';

  @override
  void initState() {
    super.initState();
    _ensurePermissions();
    _initWebView();
  }

  /// ← aquí va lo que pediste (permisos completos)
  Future<void> _ensurePermissions() async {
    final cam = await Permission.camera.request();
    final mic = await Permission.microphone.request();

    if (cam.isPermanentlyDenied || mic.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activa Cámara y Micrófono en Ajustes → Permisos')),
      );
      await openAppSettings();
      return;
    }
    if (!cam.isGranted || !mic.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permisos de Cámara y Micrófono requeridos')),
      );
    }
  }

  void _initWebView() {
    final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(
      params,
      onPermissionRequest: (request) async {
        // concede cámara y micrófono al WebView
        await request.grant();
      },
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (req) {
            final uri = Uri.parse(req.url);
            if (uri.scheme == _scheme) {
              if (uri.host == _doneHost) {
                final status = uri.queryParameters['status'];
                final id = uri.queryParameters['identificationId'] ??
                    uri.queryParameters['contractId'] ??
                    uri.queryParameters['verificationId'] ??
                    '';
                if (status == 'done' && id.isNotEmpty) {
                  ref.read(biometricDoneProvider.notifier).state = true;
                  ref.read(biometricVerificationIdProvider.notifier).state = id;
                  ref.read(biometricStatusProvider.notifier).state = 'approved';
                  ref.read(timeBiometricCaptureProvider.notifier).state = DateTime.now();
                  widget.onDone(id);
                }
                return NavigationDecision.prevent;
              }
              if (uri.host == _errorHost) {
                final code = uri.queryParameters['errCode'] ?? 'unknown';
                final msg  = uri.queryParameters['errMsg'] ?? 'Error';
                ref.read(biometricStatusProvider.notifier).state = 'error:$code';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Biometría falló ($code): $msg')),
                );
                return NavigationDecision.prevent;
              }
              if (uri.host == _logHost) {
                return NavigationDecision.prevent;
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    final signBase = ref.read(keynuaConfigProvider).signBase;
    final done  = Uri.encodeComponent('$_scheme://$_doneHost');
    final error = Uri.encodeComponent('$_scheme://$_errorHost');
    final log   = Uri.encodeComponent('$_scheme://$_logHost');

    final url = '$signBase/index.html'
        '?token=${Uri.encodeComponent(widget.token)}'
        '&eventDoneURL=$done'
        '&eventErrorURL=$error'
        '&eventLogURL=$log';

    if (kKeynuaVerboseLogs) {
      debugPrint('[KEYNUA] Opening Sign URL (token NO visible): $signBase/index.html?...');
    }

    controller.loadRequest(Uri.parse(url));
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verificación biométrica')),
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}

/// =====================================================
/// 4) FACHADA: inicia el flujo **3D (liveness)** desde Flutter
/// =====================================================
Future<void> startKeynuaLivenessFlow({
  required WidgetRef ref,
  required BuildContext context,
  required String documentNumber, // puede venir "Q44567868"
  String envFile = ".env",        // cargamos .env sin tocar main
}) async {
  await Env.ensureLoaded(fileName: envFile);

  final sanitized = _sanitizePeruDni(documentNumber);
  if (kKeynuaVerboseLogs) {
    debugPrint('[KEYNUA] Raw DNI="$documentNumber" → sanitized="$sanitized"');
  }
  if (sanitized.length != 8) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('El DNI debe tener 8 dígitos. Recibido "$documentNumber" → "$sanitized"')),
    );
    return;
  }

  final cfg = ref.read(keynuaConfigProvider);
  final client = KeynuaClient(cfg);

  try {
    final created = await client.createLivenessVerification(
      documentNumberSanitized: sanitized,
      title: 'Identificación $sanitized',
      documentType: 'pe-dni',
      disableInitialNotification: false,
    );

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProviderScope(
          parent: ProviderScope.containerOf(context),
          child: KeynuaBiometricScreen(
            token: created.userToken,
            onDone: (id) {
              ref.read(biometricDoneProvider.notifier).state = true;
              ref.read(biometricVerificationIdProvider.notifier).state = id;
              Navigator.of(_).pop();
            },
          ),
        ),
      ),
    );
  } catch (e, st) {
    debugPrint('[KEYNUA] EXCEPTION while creating verification: $e');
    debugPrint('[KEYNUA] STACKTRACE: $st');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error biométrico: $e')),
    );
  }
}
