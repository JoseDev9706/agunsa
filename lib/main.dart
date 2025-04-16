import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart'; // Asegúrate de importar tu provider

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget { // Cambia a ConsumerWidget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtiene el RouterDelegate del provider
    final routerDelegate = ref.read(routerDelegateProvider);

    return MaterialApp.router(
      routerDelegate: routerDelegate,
      routeInformationParser: AppRouteInformationParser(), // No olvides esto
      title: 'Agunsa',
      theme: ThemeData(
        fontFamily: 'univers',
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}