import 'dart:developer';

import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/utils/code_utils.dart';
import 'package:agunsa/core/widgets/general_bottom.dart';
import 'package:agunsa/features/auth/display/providers/auth_providers.dart';
import 'package:agunsa/features/transactions/data/models/pending_transaction.dart';
import 'package:agunsa/features/transactions/data/models/transaction.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/display/widgets/transaction_app_bar.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class ResumeTransaction extends ConsumerWidget {
  const ResumeTransaction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    CodeUtils codeUtils = CodeUtils();
    TextEditingController transactionNumberController = TextEditingController();
    // final transactionState = ref.watch(transactionControllerProvider);
    // final transactionNotifier = ref.read(transactionControllerProvider.notifier);
    final send = ref.watch(sendTransactionProvider);
    final transactionType = ref.watch(transactionTypeSelectedProvider);
    final transactionState = ref.watch(isFromPendingTransactionProvider);
    final containerInfo = ref.watch(fotoProvider);
    final pendingTransaction = ref.watch(selectedPendingTransactionProvider);
    final user = ref.watch(userProvider);
    final isUploadingTransaction = ref.watch(uploadingImageProvider);
    if (pendingTransaction != null) {
      transactionNumberController.text = pendingTransaction.transactionNumber;
    }

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: uiUtils.modalColor,
      body: SizedBox(
        height: uiUtils.screenHeight * 0.9,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              send
                  ? Container(
                      padding: const EdgeInsets.all(18),
                    )
                  : TransactionAppBar(
                      uiUtils: uiUtils,
                      title: '',
                      onTap: () {
                        ref.read(routerDelegateProvider).popRoute();
                      },
                    ),
              const SizedBox(
                height: 120,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                    color: uiUtils.whiteColor,
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: send
                    ? Column(
                        children: [
                          (transactionType!.isInOut != null &&
                                  transactionType.isInOut == true &&
                                  transactionState &&
                                  pendingTransaction != null)
                              ? SvgPicture.asset(
                                  'assets/svg/pending.svg',
                                  width: 46,
                                  height: 46,
                                )
                              : Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      color: uiUtils.green,
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.check,
                                    color: uiUtils.whiteColor,
                                  )),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            (transactionType.isInOut != null &&
                                    transactionType.isInOut == true &&
                                    transactionState &&
                                    pendingTransaction != null)
                                ? 'TRANSACCION EN ESTADO PENDIENTE'
                                : 'TRANSACCION COMPLETADA CON EXITO',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: (transactionType.isInOut != null &&
                                        transactionType.isInOut == true &&
                                        transactionState &&
                                        pendingTransaction != null)
                                    ? uiUtils.orange
                                    : uiUtils.grayDarkColor),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GeneralBottom(
                              icon: Icon(
                                Icons.home,
                                color: uiUtils.whiteColor,
                              ),
                              width: uiUtils.screenWidth * 0.5,
                              color: uiUtils.primaryColor,
                              text: 'HOME',
                              onTap: () {
                                resetTransactionProviders(ref);
                                setIsFromPendingTransaction(ref, false);
                                ref
                                    .read(routerDelegateProvider)
                                    .pushReplacement(AppRoute.home);
                              },
                              textColor: uiUtils.whiteColor),
                          const SizedBox(
                            height: 20,
                          ),
                          GeneralBottom(
                              icon: Icon(
                                Icons.add_circle_outline_outlined,
                                color: uiUtils.whiteColor,
                              ),
                              width: uiUtils.screenWidth * 0.5,
                              color: uiUtils.primaryColor,
                              text: 'NUEVA TRANSACCION',
                              onTap: () {
                                resetTransactionProviders(ref);
                                setIsFromPendingTransaction(ref, false);
                                ref
                                    .read(routerDelegateProvider)
                                    .pushReplacement(AppRoute.transactions);
                              },
                              textColor: uiUtils.whiteColor),
                        ],
                      )
                    : Column(
                        children: [
                          Text(
                            'RESUMEN DE LA TRANSACCION',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: uiUtils.grayDarkColor),
                          ),
                          Divider(
                            color: uiUtils.grayLightColor,
                            thickness: 1,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          LabelInfo(
                              uiUtils: uiUtils,
                              transactionType: transactionType?.name,
                              transactionTypeLabel: 'TIPO DE TRANSACCION'),
                          const SizedBox(
                            height: 20,
                          ),
                          Text('NÚMERO DE TRANSACCION',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: uiUtils.black)),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              color: uiUtils.whiteColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: uiUtils.labelColor,
                                width: 1.5,
                              ),
                            ),
                            child: TextFormField(
                              readOnly: pendingTransaction != null &&
                                  pendingTransaction
                                      .transactionNumber.isNotEmpty,
                              controller: transactionNumberController,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: 'Ingrese el número de transacción',
                                hintStyle: TextStyle(color: Colors.black38),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          LabelInfo(
                              uiUtils: uiUtils,
                              transactionType: DateFormat('yyyy-MM-dd HH:mm')
                                  .format(DateTime.now().toLocal()),
                              transactionTypeLabel: 'FECHA Y HORA'),
                          const SizedBox(
                            height: 20,
                          ),
                          LabelInfo(
                              uiUtils: uiUtils,
                              transactionType: containerInfo?.numSerie ?? '',
                              transactionTypeLabel: 'NÚMERO DE CONTENEDOR'),
                          const SizedBox(
                            height: 40,
                          ),
                          GeneralBottom(
                            width: double.infinity,
                            color: isUploadingTransaction
                                ? Colors.grey
                                : uiUtils.primaryColor,
                            text: isUploadingTransaction
                                ? 'GUARDANDO...'
                                : 'GUARDAR TRANSACCION',
                            onTap: isUploadingTransaction
                                ? () {
                                    uiUtils.showSnackBar(context,
                                        'Espere a que se complete la transacción');
                                  }
                                : () async {
                                    setUploadingImage(ref, true);
                                    if (transactionNumberController
                                        .text.isEmpty) {
                                      uiUtils.showSnackBar(context,
                                          'Ingrese el número de transacción');
                                      setUploadingImage(ref, false);
                                      return;
                                    }

                                    if (pendingTransaction != null) {
                                      TransactionModel transaction =
                                          TransactionModel(
                                        containerNumber:
                                            containerInfo?.numSerie,
                                        containerTransportLine: "MSC",
                                        containerIso:
                                            containerInfo?.codPropietario,
                                        containerType:
                                            containerInfo?.tipoContenedor,
                                        containerTara:
                                            containerInfo?.taraKg ?? '0.0',
                                        containerPayload:
                                            containerInfo?.payloadKg ?? '0.0',
                                        createdDataContainer:
                                            codeUtils.formatDateToIso8601(
                                                DateTime.now().toString()),
                                        updatedDataContainer:
                                            codeUtils.formatDateToIso8601(
                                                DateTime.now().toString()),
                                        driverDni: "12345678-9",
                                        driverName: "Carlos",
                                        driverLastName: "González",
                                        createdDataDriver:
                                            "2025-05-14T12:00:00Z",
                                        updatedDataDriver:
                                            "2025-05-14T12:00:00Z",
                                        plate: "XY-1234",
                                        createdDataPlate:
                                            "2025-05-14T12:00:00Z",
                                        updatedDataPlate:
                                            "2025-05-14T12:00:00Z",
                                        sealCode: "SEAL7890",
                                        createdDataSeal:
                                            codeUtils.formatDateToIso8601(
                                                DateTime.now().toString()),
                                        updatedDataSeal:
                                            codeUtils.formatDateToIso8601(
                                                DateTime.now().toString()),
                                        transactionNumber: pendingTransaction
                                            .transactionNumber,
                                        initialTransactionId: pendingTransaction
                                            .initialTransactionId,
                                        transactionTypeId: pendingTransaction
                                            .transactionTypeId,
                                        epochCreatedDatetime: pendingTransaction
                                            .epochCreatedDatetime,
                                        createdByUserId:
                                            pendingTransaction.createdByUserId,
                                        currentStatus: false,
                                      );

                                      final resultTransaction =
                                          await createTransactionFuntion(
                                              ref, transaction);

                                      if (resultTransaction ==
                                          'Item registered successfully') {
                                        log('resultTransaction1: $resultTransaction');
                                        // 2️⃣ Crear nueva PendingTransactionModel ajustada
                                        PendingTransactionModel
                                            newPendingTransaction =
                                            PendingTransactionModel(
                                          transactionNumber: pendingTransaction
                                              .transactionNumber,
                                          transactionTypeId: pendingTransaction
                                              .transactionTypeId,
                                          initialTransactionId:
                                              pendingTransaction
                                                  .initialTransactionId,
                                          epochCreatedDatetime:
                                              pendingTransaction
                                                  .epochCreatedDatetime,
                                          createdByUserId: pendingTransaction
                                              .createdByUserId,
                                          currentStatus: false,
                                        );
                                        final resultPendingTransaction =
                                            await createPendingTransactionFuntion(
                                                ref, newPendingTransaction);
                                        if (resultPendingTransaction ==
                                            'Item registered successfully') {
                                          log('creo la transaccion pendiente');
                                          uiUtils.showSnackBar(context,
                                              'Transacción creada exitosamente');
                                          log('resultPendingTransaction: $resultPendingTransaction');
                                          setIsFromPendingTransaction(
                                              ref, false);
                                          getSelectedPendingTransaction(
                                              ref, null);
                                        }
                                        log('creo las dos transacciones');
                                        setUploadingImage(ref, false);
                                      } else {
                                        log('Error al crear la transacción');
                                        uiUtils.showSnackBar(context,
                                            'Error al crear la transacción');
                                        setUploadingImage(ref, false);
                                        return;
                                      }
                                    } else if (transactionType?.isInOut ??
                                        false || transactionState) {
                                      PendingTransactionModel
                                          pendingTransaction =
                                          PendingTransactionModel(
                                        transactionNumber:
                                            transactionNumberController.text,
                                        transactionTypeId:
                                            transactionType?.id ?? 0,
                                        initialTransactionId: DateTime.now()
                                            .millisecondsSinceEpoch,
                                        epochCreatedDatetime: DateTime.now()
                                            .millisecondsSinceEpoch,
                                        createdByUserId: user?.id.hashCode ?? 1,
                                        currentStatus: true,
                                      );

                                      await createPendingTransactionFuntion(
                                          ref, pendingTransaction);
                                      log('creo la transaccion pendiente');
                                      setUploadingImage(ref, false);
                                      uiUtils.showSnackBar(context,
                                          'Transacción pendiente creada exitosamente');
                                    } else {
                                      TransactionModel transaction =
                                          TransactionModel(
                                        containerNumber:
                                            containerInfo?.numSerie,
                                        containerTransportLine: "MSC",
                                        containerIso:
                                            containerInfo?.codPropietario,
                                        containerType:
                                            containerInfo?.tipoContenedor,
                                        containerTara:
                                            containerInfo?.taraKg ?? '0.0',
                                        containerPayload:
                                            containerInfo?.payloadKg ?? '0.0',
                                        createdDataContainer:
                                            codeUtils.formatDateToIso8601(
                                                DateTime.now().toString()),
                                        updatedDataContainer:
                                            codeUtils.formatDateToIso8601(
                                                DateTime.now().toString()),
                                        driverDni: "12345678-9",
                                        driverName: "Carlos",
                                        driverLastName: "González",
                                        createdDataDriver:
                                            "2025-05-14T12:00:00Z",
                                        updatedDataDriver:
                                            "2025-05-14T12:00:00Z",
                                        plate: "XY-1234",
                                        createdDataPlate:
                                            "2025-05-14T12:00:00Z",
                                        updatedDataPlate:
                                            "2025-05-14T12:00:00Z",
                                        sealCode: "SEAL7890",
                                        createdDataSeal: "2025-05-14T12:00:00Z",
                                        updatedDataSeal: "2025-05-14T12:00:00Z",
                                        transactionNumber:
                                            transactionNumberController.text,
                                        initialTransactionId: DateTime.now()
                                            .millisecondsSinceEpoch,
                                        transactionTypeId:
                                            transactionType?.id ?? 0,
                                        epochCreatedDatetime: DateTime.now()
                                            .millisecondsSinceEpoch,
                                        createdByUserId: user?.id.hashCode ?? 1,
                                        currentStatus: false,
                                      );

                                      await createTransactionFuntion(
                                          ref, transaction);
                                      setUploadingImage(ref, false);
                                      uiUtils.showSnackBar(context,
                                          'Transacción creada exitosamente');
                                      log('creo la transaccion completa');
                                    }
                                  },
                            textColor: uiUtils.whiteColor,
                          )
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class LabelInfo extends StatelessWidget {
  const LabelInfo({
    super.key,
    required this.uiUtils,
    required this.transactionType,
    required this.transactionTypeLabel,
  });

  final UiUtils uiUtils;
  final String? transactionType;
  final String? transactionTypeLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: uiUtils.screenWidth,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        decoration: BoxDecoration(
          color: uiUtils.labelColor,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          children: [
            Text(transactionTypeLabel!,
                style: TextStyle(
                    color: uiUtils.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            Text(
              transactionType!,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: uiUtils.grayLightColor),
            )
          ],
        ));
  }
}
