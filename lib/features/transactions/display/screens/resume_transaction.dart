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

String? validateWeightString(String? input) {
  if (input == null || input.trim().isEmpty) return null;

  // Extraer solo la parte numérica al inicio
  final match = RegExp(r'^([\d.,\-]+)').firstMatch(input.trim());

  if (match != null) {
    final numericPart = match.group(1)!.replaceAll(',', '.');

    // Validar que la parte numérica sea realmente un número
    if (double.tryParse(numericPart) != null) {
      return input.trim(); // ✅ válido, se devuelve tal cual
    }
  }

  return null; // ❌ no es un valor numérico válido al inicio
}

class ResumeTransaction extends ConsumerWidget {
  const ResumeTransaction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    CodeUtils codeUtils = CodeUtils();
    TextEditingController transactionNumberController = TextEditingController();
    // final isfromPending = ref.watch(transactionControllerProvider);
    // final transactionNotifier = ref.read(transactionControllerProvider.notifier);
    final send = ref.watch(sendTransactionProvider);
    final transactionType = ref.watch(transactionTypeSelectedProvider);
    final isfromPending = ref.watch(isFromPendingTransactionProvider);
    final containerInfo = ref.watch(fotoProvider);
    final pendingTransaction = ref.watch(selectedPendingTransactionProvider);
    final user = ref.watch(userProvider);
    final driverInfo = ref.watch(dniProvider);
    final placaInfo = ref.watch(placaProvider);
    final precintList = ref.watch(precintProvider);

    final urlPrecint =
        precintList?.map((precinto) => precinto.imageUrl).toList();
    final precintsCodes =
        precintList?.map((precinto) => precinto.codPrecinto).toList();
    final lateralsImages = ref.watch(aditionalImageUrlsProvider);
    final lateralPhotos =
        lateralsImages.map((image) => image['imageUrl'] as String).toList();
    //final timeToResponseLateralPhotos = lateralsImages.map((image) {
    //  final timeString = image['createdDataContainerLatRespoonse'] as String;
    //  final numberOnly = int.parse(timeString.replaceAll(' ms', ''));
    //  return numberOnly;
    //}).toList();

    final timeToResponseLateralPhotos = lateralsImages.map((image) {
      final timeString = image['createdDataContainerLatRespoonse'] as String;
      final dateTime =
          DateTime.parse(timeString); // ya no es int.parse, sino DateTime.parse
      return dateTime;
    }).toList();
    //final totalTime =
    //    timeToResponseLateralPhotos.fold(0, (sum, item) => sum + item);

    final isUploadingTransaction = ref.watch(uploadingImageProvider);
    if (pendingTransaction != null) {
      transactionNumberController.text = pendingTransaction.transactionNumber;
    }

    final isPendingFromCreated = isfromPending && pendingTransaction != null;
    final isPendingTransaction = transactionType?.isInOut == true;
    final shouldShowAsPending = isPendingTransaction && !isPendingFromCreated;
    log("isInOut: ${transactionType?.isInOut}, isfromPending: $isfromPending, pendingTransaction: $pendingTransaction");
    log("isPending from created: $isPendingFromCreated");
    log("isPending: $isPendingTransaction");
    return PopScope(
      canPop: false,
      child: SafeArea(
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
                Container(
                  padding: const EdgeInsets.all(18),
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
                            shouldShowAsPending
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
                              shouldShowAsPending
                                  ? 'TRANSACCION EN ESTADO PENDIENTE'
                                  : 'TRANSACCION COMPLETADA CON EXITO',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: shouldShowAsPending
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
                                  try {
                                    resetTransactionProviders(ref);
                                    setIsFromPendingTransaction(ref, false);
                                    setIsCompleteTransaction(ref, false);
                                    ref
                                        .read(routerDelegateProvider)
                                        .pushReplacement(AppRoute.home);
                                  } catch (e, stackTrace) {
                                    log("Error durante navegación: $e",
                                        stackTrace: stackTrace);
                                  }
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
                                  setIsCompleteTransaction(ref, false);
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

                                      try {
                                        if (pendingTransaction != null) {
                                          TransactionModel transaction =
                                              TransactionModel(
                                            containerNumber:
                                                containerInfo?.numSerie,
                                            transactionTypeName:
                                                transactionType?.name ?? '',
                                            containerTransportLine:
                                                containerInfo?.numControl ??
                                                    "MSC",
                                            containerIso:
                                                containerInfo?.tipoContenedor,
                                            containerType: containerInfo
                                                ?.getTipoContenedor(
                                                    containerInfo
                                                        .tipoContenedor),
                                            containerTara: validateWeightString(
                                                containerInfo?.taraKg),
                                            containerPayload:
                                                validateWeightString(
                                                    containerInfo?.payloadKg),
                                            createdDataContainer:
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            updatedDataContainer: containerInfo
                                                    ?.updateDataContainer ??
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            createDateContainerDateTimeRespone:
                                                codeUtils.formatDateToIso8601(
                                              containerInfo?.responseDateTime
                                                      ?.toIso8601String() ??
                                                  codeUtils.formatDateToIso8601(
                                                      DateTime.now()
                                                          .toString()),
                                            ),
                                            containerUrlImageLat: lateralPhotos,
                                            createdDataContainerLat:
                                                lateralsImages[0][
                                                        'createdDataContainerLat']
                                                    .toString(),
                                            createdDataContainerLatResponse:
                                                codeUtils.formatDateToIso8601(
                                              containerInfo?.responseDateTime
                                                      ?.toIso8601String() ??
                                                  codeUtils.formatDateToIso8601(
                                                      DateTime.now()
                                                          .toString()),
                                            ),
                                            driverDni:
                                                driverInfo?.codLicence ?? "",
                                            driverName:
                                                driverInfo?.fullName ?? "",
                                            driverLastName:
                                                driverInfo?.fullLastName ?? "",
                                            createdDataDriver:
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            updatedDataDriver: driverInfo
                                                    ?.updateConductorDateTime ??
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            createdDataDriverResponse:
                                                codeUtils.formatDateToIso8601(
                                              driverInfo?.responseDateTime
                                                      ?.toIso8601String() ??
                                                  codeUtils.formatDateToIso8601(
                                                      DateTime.now()
                                                          .toString()),
                                            ),
                                            plate:
                                                placaInfo?.codigo ?? "XY-1234",
                                            createdDataPlate:
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            updatedDataPlate: placaInfo
                                                    ?.updatePlateDateTime ??
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            createdDataPlateResponse:
                                                codeUtils.formatDateToIso8601(
                                              placaInfo?.responseDateTime
                                                      .toString() ??
                                                  codeUtils.formatDateToIso8601(
                                                      DateTime.now()
                                                          .toString()),
                                            ),
                                            sealCode: "",
                                            sealcodesList: precintsCodes,
                                            createdDataSealResponse:
                                                codeUtils.formatDateToIso8601(
                                              precintList?[0]
                                                      .responseDateTime
                                                      ?.toIso8601String() ??
                                                  codeUtils.formatDateToIso8601(
                                                      DateTime.now()
                                                          .toString()),
                                            ),
                                            createdDataSeal:
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            updatedDataSeal: precintList
                                                    ?.last.updateDataSeal ??
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            transactionNumber:
                                                pendingTransaction
                                                    .transactionNumber,
                                            initialTransactionId:
                                                transactionType?.id ?? 0,
                                            transactionTypeId:
                                                pendingTransaction
                                                    .transactionTypeId,
                                            epochCreatedDatetime:
                                                pendingTransaction
                                                    .epochCreatedDatetime,
                                            cratedDataTimeTransaction: ref
                                                    .watch(
                                                        timeCreationTransactionProvider)
                                                    ?.millisecondsSinceEpoch ??
                                                0,
                                            createdByUserId: pendingTransaction
                                                .createdByUserId,
                                            containerUrlImage:
                                                containerInfo?.imageUrl,
                                            driverUrlImage:
                                                driverInfo?.imageUrl,
                                            plateUrlImage: placaInfo?.imageUrl,
                                            precintImagesUrl: urlPrecint,
                                          );
                                          log('transaction: ${transaction.toJson()}');
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
                                              transactionNumber:
                                                  pendingTransaction
                                                      .transactionNumber,
                                              transactionTypeName:
                                                  pendingTransaction
                                                      .transactionTypeName,
                                              transactionTypeId:
                                                  pendingTransaction
                                                      .transactionTypeId,
                                              initialTransactionId:
                                                  transactionType?.id ?? 0,
                                              epochCreatedDatetime:
                                                  pendingTransaction
                                                      .epochCreatedDatetime,
                                              createdByUserId:
                                                  pendingTransaction
                                                      .createdByUserId,
                                              currentStatus: false,
                                              createdDataTimeTransaction:
                                                  pendingTransaction
                                                      .createdDataTimeTransaction,
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
                                              // setIsFromPendingTransaction(
                                              //     ref, false);
                                              // getSelectedPendingTransaction(
                                              //     ref, null);
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
                                            false || isfromPending) {
                                          PendingTransactionModel
                                              pendingTransaction =
                                              PendingTransactionModel(
                                            transactionNumber:
                                                transactionNumberController
                                                    .text,
                                            transactionTypeName:
                                                transactionType?.name ?? '',
                                            transactionTypeId:
                                                transactionType?.id ?? 0,
                                            initialTransactionId:
                                                transactionType?.id ?? 0,
                                            epochCreatedDatetime: DateTime.now()
                                                .millisecondsSinceEpoch,
                                            createdByUserId:
                                                user?.id.hashCode ?? 1,
                                            currentStatus: true,
                                            createdDataTimeTransaction:
                                                DateTime.now()
                                                    .millisecondsSinceEpoch,
                                          );

                                          await createPendingTransactionFuntion(
                                              ref, pendingTransaction);
                                          log('creo la transaccion pendiente');
                                          setUploadingImage(ref, false);
                                          uiUtils.showSnackBar(context,
                                              'Transacción pendiente creada exitosamente');
                                        } else {
                                          log('user : ${user?.id.hashCode}');
                                          TransactionModel transaction =
                                              TransactionModel(
                                            containerNumber:
                                                containerInfo?.numSerie,
                                            transactionTypeName:
                                                transactionType?.name ?? '',
                                            containerTransportLine:
                                                containerInfo?.numControl ?? '',
                                            containerIso:
                                                containerInfo?.tipoContenedor,
                                            containerType: containerInfo
                                                ?.getTipoContenedor(
                                                    containerInfo
                                                        .tipoContenedor),
                                            containerTara: validateWeightString(
                                                containerInfo?.taraKg),
                                            containerPayload:
                                                validateWeightString(
                                                    containerInfo?.payloadKg),
                                            createdDataContainer:
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            updatedDataContainer: containerInfo
                                                    ?.updateDataContainer ??
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            createDateContainerDateTimeRespone:
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            createdDataContainerLat:
                                                lateralsImages[0]
                                                    ['createdDataContainerLat'],
                                            createdDataContainerLatResponse:
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            containerUrlImageLat: lateralPhotos,
                                            driverDni:
                                                driverInfo?.codLicence ?? "",
                                            driverName:
                                                driverInfo?.fullName ?? "",
                                            driverLastName:
                                                driverInfo?.fullLastName ?? "",
                                            createdDataDriver:
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            updatedDataDriver: driverInfo
                                                    ?.updateConductorDateTime ??
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            createdDataDriverResponse:
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            plate: placaInfo?.codigo ?? "",
                                            createdDataPlate:
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            updatedDataPlate: placaInfo
                                                    ?.updatePlateDateTime ??
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            createdDataPlateResponse: placaInfo
                                                        ?.responseDateTime !=
                                                    null
                                                ? codeUtils.formatDateToIso8601(
                                                    placaInfo!
                                                        .responseDateTime!)
                                                : codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            sealCode: "",
                                            createdDataSeal:
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            updatedDataSeal: precintList
                                                    ?.last.updateDataSeal ??
                                                codeUtils.formatDateToIso8601(
                                                    DateTime.now().toString()),
                                            sealcodesList: precintsCodes,
                                            createdDataSealResponse:
                                                codeUtils.formatDateToIso8601(
                                                    precintList?[0]
                                                            .responseDateTime
                                                            ?.toIso8601String() ??
                                                        DateTime.now()
                                                            .toIso8601String()),
                                            transactionNumber:
                                                transactionNumberController
                                                    .text,
                                            initialTransactionId:
                                                transactionType?.id ?? 0,
                                            transactionTypeId:
                                                transactionType?.id ?? 0,
                                            epochCreatedDatetime: DateTime.now()
                                                .millisecondsSinceEpoch,
                                            cratedDataTimeTransaction: ref
                                                    .watch(
                                                        timeCreationTransactionProvider)
                                                    ?.millisecondsSinceEpoch ??
                                                DateTime.now()
                                                    .millisecondsSinceEpoch,
                                            createdByUserId:
                                                user?.id.hashCode ?? 1,
                                            currentStatus: false,
                                            containerUrlImage:
                                                containerInfo?.imageUrl,
                                            driverUrlImage:
                                                driverInfo?.imageUrl,
                                            plateUrlImage: placaInfo?.imageUrl,
                                            precintImagesUrl: urlPrecint,
                                          );
                                          log('transaction: ${transaction.toJson()}');
                                          final result =
                                              await createTransactionFuntion(
                                                  ref, transaction);
                                          if (result ==
                                              'Item registered successfully') {
                                            setUploadingImage(ref, false);
                                            setIsCompleteTransaction(ref, true);
                                            setTimeCreationTransaction(
                                                ref, null);
                                            uiUtils.showSnackBar(context,
                                                'Transacción creada exitosamente');
                                            log('creo la transaccion completa');
                                          } else {
                                            log('Error al crear la transacción');
                                            uiUtils.showSnackBar(context,
                                                'Error al crear la transacción sola');
                                            setUploadingImage(ref, false);
                                            return;
                                          }
                                        }
                                      } catch (e) {
                                        log('Error al crear la transacción: $e');
                                        uiUtils.showSnackBar(context,
                                            'Error al crear la transacción: $e');
                                        setUploadingImage(ref, false);
                                        return;
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
      )),
    );
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
            Text(transactionTypeLabel ?? '',
                style: TextStyle(
                    color: uiUtils.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            Text(
              transactionType ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: uiUtils.grayLightColor),
            )
          ],
        ));
  }
}
