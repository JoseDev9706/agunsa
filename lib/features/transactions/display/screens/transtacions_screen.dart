import 'dart:developer';

import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/widgets/custom_navigation_bar.dart';
import 'package:agunsa/features/auth/domain/entities/user_entity.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/display/widgets/paginator_widget.dart';
import 'package:agunsa/features/transactions/display/widgets/transaction_app_bar.dart';
import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class TransactionsScreen extends ConsumerWidget {
  final UserEntity? user;

  const TransactionsScreen({
    super.key,
    this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    final currentPage = ref.watch(currentPageProvider);
    final transactionTypesAsync = ref.watch(filteredTransactionTypesProvider);
    final timeCreation = ref.watch(timeCreationTransactionProvider);

    const itemsPerPage = 6;

    return SafeArea(
      child: Scaffold(
        body: transactionTypesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (transactionTypes) {
            final totalPages = (transactionTypes.length / itemsPerPage).ceil();

            final pagedItems = transactionTypes
                .skip((currentPage - 1) * itemsPerPage)
                .take(itemsPerPage)
                .toList();

            return Column(
              children: [
                TransactionAppBar(
                  uiUtils: uiUtils,
                  title: 'Transacciones',
                  onTap: () {
                    ref.read(routerDelegateProvider).popRoute();
                    ref.read(timeCreationTransactionProvider.notifier).state =
                        null;
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: uiUtils.screenWidth * 0.05),
                    child: Column(
                      children: [
                        Container(
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
                            onChanged: (value) => ref
                                .read(searchQueryProvider.notifier)
                                .state = value,
                          ),
                        ),
                        SizedBox(height: uiUtils.screenHeight * 0.02),
                        Divider(color: uiUtils.labelColor),
                        SizedBox(height: uiUtils.screenHeight * 0.02),
                        Expanded(
                          child: Wrap(
                            spacing: 40,
                            runSpacing: 30,
                            children: pagedItems
                                .map((item) => TransactionsCard(
                                      uiUtils: uiUtils,
                                      name: item.name ?? 'Sin nombre',
                                      svgPath: item.imageUrl ??
                                          'https://thenounproject.com/icon/default-image-4595376/',
                                      onTap: () {
                                        final router =
                                            ref.read(routerDelegateProvider);
                                        timeCreation != null
                                            ? setTimeCreationTransaction(
                                                ref, null)
                                            : setTimeCreationTransaction(
                                                ref, DateTime.now()); 
                                        seleteTransactionType(ref, item);
                                        if (item.isInOut == true) {
                                          router.push(AppRoute.talePlaca,
                                              args: {
                                                'user': user,
                                                'transactionType': item
                                              });
                                        } else {
                                          router.push(AppRoute.takeContainer,
                                              args: {
                                                'user': user,
                                                'transactionType': item
                                              });
                                        }
                                        ref
                                            .read(searchQueryProvider.notifier)
                                            .state = '';
                                      },
                                    ))
                                .toList(),
                          ),
                        ),
                        SizedBox(height: uiUtils.screenHeight * 0.04),
                      ],
                    ),
                  ),
                ),
                Divider(color: uiUtils.labelColor),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Paginator(
                        uiUtils: uiUtils,
                        currentPage: currentPage,
                        totalPages: totalPages,
                        onPageChanged: (newPage) {
                          ref.read(currentPageProvider.notifier).state =
                              newPage;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: CustomBottomNavitionBar(
          uiUtils: uiUtils,
        ),
      ),
    );
  }
}

class TransactionsCard extends StatelessWidget {
  const TransactionsCard({
    super.key,
    required this.uiUtils,
    required this.name,
    required this.svgPath,
    this.onTap,
  });

  final UiUtils uiUtils;
  final String name;
  final String svgPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    log('SVG Path card: $svgPath');
    final uri = Uri.tryParse(svgPath);
    final isValidUrl = uri != null && uri.isAbsolute;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: uiUtils.screenWidth * 0.35,
        height: uiUtils.screenHeight * 0.15,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: uiUtils.whiteColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(0, 10))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isValidUrl)
              SvgPicture.network(
                svgPath,
                width: 73,
                height: 58,
                color: uiUtils.primaryColor,
                placeholderBuilder: (_) => const CircularProgressIndicator(),
              )
            else
              SvgPicture.asset(
                'assets/svg/primary-logo.svg',
                height: 25,
                width: 25,
              ),
            const SizedBox(height: 5),
            Text(
              textAlign: TextAlign.center,
              name,
              style: TextStyle(
                  color: uiUtils.primaryColor,
                  fontSize: uiUtils.screenWidth * 0.04,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
