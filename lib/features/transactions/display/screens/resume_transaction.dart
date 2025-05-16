import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/widgets/general_bottom.dart';
import 'package:agunsa/features/transactions/data/models/transaction.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/display/widgets/transaction_app_bar.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ResumeTransaction extends ConsumerWidget {
  const ResumeTransaction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    // final transactionState = ref.watch(transactionControllerProvider);
    // final transactionNotifier = ref.read(transactionControllerProvider.notifier);
    final send = ref.watch(sendTransactionProvider);
    final transactionType = ref.watch(transactionTypeSelectedProvider);
    return SafeArea(
        child: Scaffold(
      backgroundColor: uiUtils.modalColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TransactionAppBar(
            uiUtils: uiUtils,
            title: '',
          ),
          const SizedBox(
            height: 120,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
                color: uiUtils.whiteColor,
                borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: send
                ? Column(
                    children: [
                      transactionType?.isInOut ?? false
                          ? SvgPicture.asset(
                              'assets/svg/pending.svg',
                              width: 46,
                              height: 46,
                            )
                          : Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: uiUtils.green, shape: BoxShape.circle),
                              child: Icon(
                                Icons.check,
                                color: uiUtils.whiteColor,
                              )),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        transactionType?.isInOut ?? false
                            ? 'TRANSACCION EN ESTADO PENDIENTE'
                            : 'TRANSACCION COMPLETADA CON EXITO',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: transactionType?.isInOut ?? false
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
                          transactionType: 'DESCARGA',
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
                          transactionType: '15/04/2025 13:00',
                          transactionTypeLabel: 'FECHA Y HORA'),
                      const SizedBox(
                        height: 20,
                      ),
                      LabelInfo(
                          uiUtils: uiUtils,
                          transactionType: 'GCXU 577020 45G1',
                          transactionTypeLabel: 'NÚMERO DE CONTENEDOR'),
                      const SizedBox(
                        height: 40,
                      ),
                      GeneralBottom(
                        width: double.infinity,
                        color: uiUtils.primaryColor,
                        text: 'GUARDAR TRANSACCION',
                        onTap: () async {
                          TransactionModel transaction = TransactionModel(
                              containerNumber: "MSSS1234567",
                              containerTransportLine: "MSC",
                              containerIso: "22G1",
                              containerType: "Dry",
                              containerTara: 2350.0,
                              containerPayload: 28000.0,
                              createdDataContainer: "2025-05-14T12:00:00Z",
                              updatedDataContainer: "2025-05-14T12:00:00Z",
                              driverDni: "12345678-9",
                              driverName: "Carlos",
                              driverLastName: "González",
                              createdDataDriver: "2025-05-14T12:00:00Z",
                              updatedDataDriver: "2025-05-14T12:00:00Z",
                              plate: "XY-1234",
                              createdDataPlate: "2025-05-14T12:00:00Z",
                              updatedDataPlate: "2025-05-14T12:00:00Z",
                              sealCode: "SEAL7890",
                              createdDataSeal: "2025-05-14T12:00:00Z",
                              updatedDataSeal: "2025-05-14T12:00:00Z",
                              transactionNumber: "TRX-00001",
                              initialTransactionId: 1,
                              transactionTypeId: 1,
                              epochCreatedDatetime: 1747244000,
                              createdByUserId: 1,
                              currentStatus: transactionType?.isInOut ?? false
                                  ? true
                                  : false);

                          await createTransactionFuntion(ref, transaction);
                        },
                        textColor: uiUtils.whiteColor,
                      )
                    ],
                  ),
          ),
          Spacer(),
        ],
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
