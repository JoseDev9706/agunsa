
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterDropdown extends ConsumerWidget {
  const FilterDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    final transactionTypesAsync = ref.watch(transactionTypesProvider);
    final selectedId = ref.watch(selectedFilterIdProvider);

    return transactionTypesAsync.when(
      data: (filters) {
        return PopupMenuButton<Object>(
          onSelected: (value) {
            print('Seleccionado: $value');
          },
          itemBuilder: (context) => filters
              .map(
                (filter) => PopupMenuItem(
                  value: filter.id,
                  child: ListTile(
                    leading: Icon(
                      selectedId == filter.id
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: uiUtils.primaryColor,
                    ),
                    title: Text(filter.name ?? ''),
                    onTap: () {
                      final selected =
                          ref.read(selectedFilterIdProvider.notifier);
                      selected.state = filter.id;
                      Navigator.pop(context);
                    },
                  ),
                ),
              )
              .toList(),
          child: Container(
            height: uiUtils.screenHeight * 0.05,
            width: uiUtils.screenWidth * 0.1,
            
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                )
              ],
              color: uiUtils.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.filter_list,
              color: Colors.white,
              size: 25,
            ),
          ),
        );
      },
      loading: () =>  SizedBox(
        height: 45,
        width: 45,
        child: Center(child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                )
              ],
              color: uiUtils.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.filter_list,
              color: Colors.white,
              size: 25,
            ),
          ),),
      ),
      error: (error, stack) => const Icon(Icons.error),
    );
  }
}
