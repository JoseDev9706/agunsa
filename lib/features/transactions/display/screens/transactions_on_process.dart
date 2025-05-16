import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/display/widgets/filter_drop.dart';
import 'package:agunsa/features/transactions/display/widgets/transaction_app_bar.dart';
import 'package:agunsa/features/transactions/domain/entities/peding_transaction.dart';
import 'package:agunsa/features/transactions/domain/entities/transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionsOnProcess extends ConsumerWidget {
  const TransactionsOnProcess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    final isExpanded =
        ref.watch(expandedPendingTransactionsProvider.select((state) => state));
    return SafeArea(
        child: Scaffold(
      body: Column(children: [
        Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(color: uiUtils.grayLightColor),
              child: Column(children: [
                TransactionAppBar(
                  uiUtils: uiUtils,
                  title: 'Transacciones en Proceso',
                  titleColor: uiUtils.whiteColor,
                  iconColor: uiUtils.whiteColor,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 100,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 10),
                              )
                            ],
                            color: uiUtils.whiteColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Buscar transacción',
                              hintStyle: TextStyle(
                                  color: uiUtils.labelColor, fontSize: 18),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                color: uiUtils.primaryColor,
                                size: 25,
                              ),
                            ),
                            // onChanged: (value) => ref
                            //     .read(searchQueryProvider.notifier)
                            //     .state = value,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(flex: 1, child: FilterDropdown()),
                    ],
                  ),
                ),
              ]),
            )),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(color: uiUtils.whiteColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () =>
                      toggleExpandedPendingTransactions(ref, !isExpanded),
                  child: Row(
                    children: [
                      Transform.rotate(
                        angle: !isExpanded ? -1.5708 : 0,
                        child: SvgPicture.asset(
                          'assets/svg/drop_rigth.svg',
                          color: UiUtils().primaryColor,
                          height: 8,
                          width: 8,
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Transacciones en Proceso',
                        style: TextStyle(
                          fontSize: 21,
                          color: uiUtils.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 10),
                  FutureBuilder<List<PendingTransaction>>(
                    future: getPendingTransactionsFunction(ref),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text('Ocurrió un error'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('Sin transacciones'));
                      } else {
                        final transactions = snapshot.data!;
                        return ListView.separated(
                          separatorBuilder: (context, index) => const Divider(),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return ListTile(
                              title: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'NÚMERO DE CONTENEDOR: ',
                                        style: TextStyle(
                                          color: uiUtils.grayLightColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        transaction.transactionNumber,
                                        style: TextStyle(
                                            color: uiUtils.grayLightColor),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'TRANSACCIÓN: ',
                                        style: TextStyle(
                                          color: uiUtils.grayLightColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        transaction.transactionNumber,
                                        style: TextStyle(
                                            color: uiUtils.grayLightColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    decoration:
                                        BoxDecoration(color: uiUtils.orange),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/svg/pending.svg',
                                          color: uiUtils.whiteColor,
                                          height: 15,
                                          width: 15,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'PENDIENTE',
                                          style: TextStyle(
                                            color: uiUtils.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ]
              ],
            ),
          ),
        )
      ]),
    ));
  }
}
