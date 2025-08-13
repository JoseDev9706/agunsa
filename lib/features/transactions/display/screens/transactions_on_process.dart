import 'dart:developer';

import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:agunsa/features/auth/display/providers/auth_providers.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/display/widgets/filter_drop.dart';
import 'package:agunsa/features/transactions/display/widgets/transaction_app_bar.dart';
import 'package:agunsa/features/transactions/domain/entities/peding_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:collection/collection.dart';


class TransactionsOnProcess extends ConsumerWidget {
  const TransactionsOnProcess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiUtils = UiUtils();
    final isExpanded = ref.watch(expandedPendingTransactionsProvider);
    final user = ref.watch(userProvider);
    final placaInfo = ref.watch(placaProvider);

    // Null-safe read and lowercase of search query
    final searchQuery = ref.watch(searchQueryProvider);
    


    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // AppBar + Buscar + Filtro
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(color: uiUtils.grayLightColor),
                child: Column(
                  children: [
                    TransactionAppBar(
                      uiUtils: uiUtils,
                      title: 'Transacciones en Proceso',
                      titleColor: uiUtils.whiteColor,
                      iconColor: uiUtils.whiteColor,
                      onTap: () => ref.read(routerDelegateProvider).popRoute(),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: uiUtils.screenHeight * 0.15,
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
                              child: TextField(
                                onChanged: (value) {
                                  ref.read(searchQueryProvider.notifier).state = value;
                                },
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
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(flex: 1, child: FilterDropdown()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Toggle expandido
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: uiUtils.whiteColor,
                child: GestureDetector(
                  onTap: () => toggleExpandedPendingTransactions(ref, !isExpanded),
                  child: Row(
                    children: [
                      Transform.rotate(
                        angle: !isExpanded ? -1.5708 : 0,
                        child: SvgPicture.asset(
                          'assets/svg/drop_rigth.svg',
                          color: uiUtils.primaryColor,
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
              ),
            ),
            // Lista filtrada
            if (isExpanded)
              SliverToBoxAdapter(
                child: FutureBuilder<List<PendingTransaction>>(
                  future: getPendingTransactionsFunction(ref, user?.id.hashCode ?? 0),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator()));
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Ocurrió un error'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Sin transacciones'));
                    }

                    final original = snapshot.data!;
                    // Filtrar según el query de búsqueda
                    final filteredBySearch = searchQuery.isEmpty
                        ? original
                        : original.where((t) {
                            final num = t.transactionNumber.toLowerCase();
                            final txType = ref
                                .read(filteredTransactionTypesProvider)
                                .maybeWhen(
                                  data: (types) => types
                                      .firstWhereOrNull((type) =>
                                          type.id == t.transactionTypeId),
                                  orElse: () => null,
                                );
                            final name = (txType?.name ?? '').toLowerCase();
                            return num.contains(searchQuery) || name.contains(searchQuery);
                          }).toList();
                          final selectedIds = ref.watch(selectedFilterIdsProvider);

                    // Filtrar según selección
                    final filtered = selectedIds.isEmpty
    ? filteredBySearch
    : filteredBySearch.where((t) => selectedIds.contains(t.transactionTypeId)).toList();

                    final transactionTypesAsync = ref.watch(filteredTransactionTypesProvider);
                    return transactionTypesAsync.when(
                      data: (transactionTypes) {
                        return ListView.separated(
                          separatorBuilder: (_, __) => const Divider(),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final transaction = filtered[index];
                            final transactionType = transactionTypes.firstWhereOrNull(
                              (type) => type.id == transaction.transactionTypeId,
                              
                            );
                            log('placaInfo: $placaInfo — código: ${placaInfo?.codigo}');
                            return ListTile(
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // NUMERO DE TRANSACCION
      Row(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'NÚMERO DE TRANSACCIÓN:',
                style: TextStyle(
                  fontSize: 16,
                  color: uiUtils.grayLightColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                transaction.transactionNumber,
                style: TextStyle(
                  fontSize: 16,
                  color: uiUtils.grayLightColor,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),

      // TRANSACCION
      Row(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'TRANSACCIÓN:',
                style: TextStyle(
                  fontSize: 16,
                  color: uiUtils.grayLightColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                transactionType?.name ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: uiUtils.grayLightColor,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),

      // PLACA DEL VEHICULO
      Row(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'PLACA DEL VEHÍCULO:',
                style: TextStyle(
                  fontSize: 16,
                  color: uiUtils.grayLightColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                transaction.plate ?? '– sin placa –',
                style: TextStyle(
                  fontSize: 16,
                  color: uiUtils.grayLightColor,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  ),
  subtitle: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      GestureDetector(
        onTap: () {
          setIsFromPendingTransaction(ref, true);
          setTimeCreationTransaction(ref, DateTime.now());
          getSelectedPendingTransaction(ref, transaction);
          ref.read(routerDelegateProvider).push(
                AppRoute.takeContainer,
                args: {'transaction': transaction},
              );
        },
        child: Container(
          decoration: BoxDecoration(color: uiUtils.orange),
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
      ),
    ],
  ),
);

                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const Center(child: Text('Error cargando tipos')),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
