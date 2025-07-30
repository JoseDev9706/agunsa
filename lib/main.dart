import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agunsa/core/amplify_connet/configure_amplify.dart';
import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';

void main() {
  // Hace que los errores de zona sean fatales para detectar mismatches
  BindingBase.debugZoneErrorsAreFatal = true;

  // Captura errores de Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    log('FlutterError capturado: ${details.exception}', stackTrace: details.stack);
  };

  // Ejecuta la app dentro de la misma zona donde se inicializa el binding
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await configureAmplify();
    runApp(const ProviderScope(child: MyApp()));
  }, (error, stack) {
    log('Error asíncrono no capturado: $error', stackTrace: stack);
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerDelegate = ref.read(routerDelegateProvider);

    return MaterialApp.router(
      routerDelegate: routerDelegate,
      routeInformationParser: AppRouteInformationParser(),
      title: 'Agunsa',
      theme: ThemeData(
        fontFamily: 'univers',
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
