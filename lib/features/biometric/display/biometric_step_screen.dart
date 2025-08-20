import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:agunsa/features/biometric/keynua_biometric.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BiometricStepScreen extends ConsumerWidget {
  const BiometricStepScreen({super.key, this.args});
  final Map<String, dynamic>? args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = UiUtils();
    final dniInfo = ref.watch(dniProvider);
    final done = ref.watch(biometricDoneProvider);
    final isRunning = ValueNotifier<bool>(false);

    return Scaffold(
      appBar: AppBar(title: const Text('Paso: Biometría')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ValueListenableBuilder<bool>(
            valueListenable: isRunning,
            builder: (_, running, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Verificación biométrica del conductor',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ui.grayDarkColor)),
                  const SizedBox(height: 16),
                  Text('Documento: ${dniInfo?.codLicence ?? '-'}',
                      style: TextStyle(color: ui.grayLightColor)),
                  const Spacer(),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.shield_outlined),
                    label: Text(running ? 'Iniciando…' : 'CAPTURA BIOMETRÍA (3D)'),
                    onPressed: running
                        ? null
                        : () async {
                            final doc = dniInfo?.codLicence ?? '';
                            if (doc.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Primero captura la licencia (DNI)')),
                              );
                              return;
                            }
                            isRunning.value = true;
                            try {
                              await startKeynuaLivenessFlow(
                                ref: ref,
                                context: context,
                                documentNumber: doc, // vendrá con letra; se sanea adentro
                                envFile: '.env',
                              );
                            } finally {
                              isRunning.value = false;
                            }
                          },
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('FINALIZAR'),
                    onPressed: done
                        ? () {
                            ref.read(routerDelegateProvider).pushAndRemoveAll(
                              AppRoute.resumeTransaction,
                              args: {
                                'images': args?['images'],
                                'isContainer': args?['isContainer'] ?? true,
                              },
                            );
                          }
                        : null,
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
