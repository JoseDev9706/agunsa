import 'package:agunsa/core/amplify_connet/configure_amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureAmplify();
  runApp(const ProviderScope(child: MyApp()));
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
