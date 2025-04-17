import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/widgets/custom_navigation_bar.dart';
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
    final currentPageProvider = StateProvider<int>((ref) => 1);
    const totalPages = 3;
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
                      ),
                    ),
                    SizedBox(height: uiUtils.screenHeight * 0.02),
                    Divider(color: uiUtils.labelColor),
                    SizedBox(height: uiUtils.screenHeight * 0.02),
                    Expanded(
                      child: Wrap(
                        spacing: 40,
                        runSpacing: 30,
                        children: [
                          TransactionsCard(
                            uiUtils: uiUtils,
                            onTap: () {
                              final router = ref.read(routerDelegateProvider);
                              router.push(AppRoute.takeContainer);
                            },
                          ),
                          TransactionsCard(uiUtils: uiUtils),
                          TransactionsCard(uiUtils: uiUtils),
                          TransactionsCard(uiUtils: uiUtils),
                          TransactionsCard(uiUtils: uiUtils),
                          TransactionsCard(uiUtils: uiUtils),
                        ],
                      ),
                    ),
                    SizedBox(height: uiUtils.screenHeight * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Paginator(
                          uiUtils: uiUtils,
                          currentPage: 1,
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
    this.onTap,
  });

  final UiUtils uiUtils;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
            children: [
              SvgPicture.asset("assets/svg/descarga.svg"),
              const SizedBox(height: 10),
              Text(
                textAlign: TextAlign.center,
                'Agunsas',
                style: TextStyle(color: uiUtils.primaryColor, fontSize: 16),
              ),
            ],
          )),
    );
  }
}
