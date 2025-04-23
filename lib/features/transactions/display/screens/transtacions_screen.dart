import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/widgets/custom_navigation_bar.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/display/widgets/paginator_widget.dart';
import 'package:agunsa/features/transactions/display/widgets/transaction_app_bar.dart';
import 'package:agunsa/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    final currentPage = ref.watch(currentPageProvider);
    final svgItems = ref.watch(filteredSvgItemsProvider);
    const itemsPerPage = 6;
    final totalPages = (svgItems.length / itemsPerPage).ceil();

    final pagedItems = svgItems
        .skip((currentPage - 1) * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TransactionAppBar(
              uiUtils: uiUtils,
              title: 'Transacciones',
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
                                offset: Offset(0, 10))
                          ],
                          color: uiUtils.whiteColor,
                          borderRadius: BorderRadius.circular(25)),
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
                                  name: item.name,
                                  svgPath: item.path,
                                  onTap: () {
                                    final router =
                                        ref.read(routerDelegateProvider);
                                    router.push(AppRoute.takeContainer);
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: uiUtils.screenHeight * 0.04),
                    Row(
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
                    Divider(color: uiUtils.labelColor),
                  ],
                ),
              ),
            ),
          ],
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 133,
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
            SvgPicture.asset(
              svgPath,
              width: 73,
              height: 58,
              color: uiUtils.primaryColor,
            ),
            const SizedBox(height: 10),
            Text(
              textAlign: TextAlign.center,
              name,
              style: TextStyle(
                  color: uiUtils.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
