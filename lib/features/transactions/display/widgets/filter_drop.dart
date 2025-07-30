import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';

final selectedFilterIdsProvider = StateProvider<Set<int>>((ref) => <int>{});

class FilterDropdown extends ConsumerWidget {
  const FilterDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiUtils = UiUtils();
    final transactionTypesAsync = ref.watch(transactionTypesProvider);
    final selectedIds = ref.watch(selectedFilterIdsProvider);

    return transactionTypesAsync.when(
      data: (filters) {
        return Container(
          height: uiUtils.screenHeight * 0.05,
          width: uiUtils.screenWidth * 0.1,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 10)),
            ],
            color: uiUtils.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(
              Icons.filter_list,
              color: selectedIds.isEmpty ? Colors.white : uiUtils.whiteColor,
              size: 25,
            ),
            onPressed: () async {
              final tempSelectedIds = Set<int>.from(selectedIds);
              await showDialog(
                context: context,
                barrierColor: Colors.black38,
                builder: (_) {
                  final media = MediaQuery.of(context);
                  final dialogWidth = media.size.width * 0.88; // 88% del ancho pantalla
                  final dialogMaxHeight = media.size.height * 0.80; // máximo 80% alto
                  final filterListHeight = media.size.height * 0.60; // máximo 60% alto para la lista

                  return Dialog(
                    backgroundColor: const Color(0xFFF7F3F9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: dialogWidth,
                        maxHeight: dialogMaxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                        child: StatefulBuilder(
                          builder: (context, setState) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Seleccionar filtros',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.black45),
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
                                ],
                              ),
                              const Divider(height: 5),
                              Flexible(
                                child: SizedBox(
                                  height: filterListHeight,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: filters.map<Widget>((filter) {
                                      final checked = tempSelectedIds.contains(filter.id!);
                                      return Theme(
                                        data: ThemeData(
                                          unselectedWidgetColor: Colors.red[700],
                                        ),
                                        child: CheckboxListTile(
                                          controlAffinity: ListTileControlAffinity.leading,
                                          activeColor: Colors.red[700], // color de check
                                          checkColor: Colors.white,
                                          value: checked,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                          title: Text(
                                            filter.name ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Colors.black87,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value == true) {
                                                tempSelectedIds.add(filter.id!);
                                              } else {
                                                tempSelectedIds.remove(filter.id!);
                                              }
                                            });
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => setState(() {
                                      tempSelectedIds.clear();
                                    }),
                                    child: const Text('Limpiar'),
                                  ),
                                  const SizedBox(width: 20),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cancelar'),
                                  ),
                                  const SizedBox(width: 13),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[700],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      ref.read(selectedFilterIdsProvider.notifier).state = tempSelectedIds;
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Aplicar', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      loading: () => Container(
        height: uiUtils.screenHeight * 0.05,
        width: uiUtils.screenWidth * 0.1,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 10)),
          ],
          color: uiUtils.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Icon(Icons.filter_list, color: Colors.white, size: 25),
        ),
      ),
      error: (_, __) => const Icon(Icons.error),
    );
  }
}
