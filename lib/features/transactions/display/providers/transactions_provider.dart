import 'dart:developer';

import 'package:agunsa/core/class/svg_item.dart';
import 'package:agunsa/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:agunsa/features/transactions/data/repository_impl/transaction_respositories_impl.dart';
import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';
import 'package:agunsa/features/transactions/domain/respositories/transaction_repositories.dart';
import 'package:agunsa/features/transactions/domain/use_cases/get_transaction_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transactions_provider.g.dart';

@riverpod
TransactionRemoteDatasource transactionRemoteDatasource(
    TransactionRemoteDatasourceRef ref) {
  return TransactionRemoteDatasourceImpl();
}

@riverpod
TransactionRepositories transactionRepositories(
    TransactionRepositoriesRef ref) {
  return TransactionRespositoriesImpl(
      ref.watch(transactionRemoteDatasourceProvider));
}

@riverpod
class TransactionsController extends _$TransactionsController {
  @override
  FutureOr<List<TransactionType>> build() async {
    return [];
  }

  Future<List<TransactionType>> fetchTransactionTypes() async {
    final transactionTypes = await ref.read(getTransactionTypesProvider).call();
    return transactionTypes;
  }
}

final transactionTypesProvider =
    FutureProvider<List<TransactionType>>((ref) async {
  return await ref
      .read(transactionsControllerProvider.notifier)
      .fetchTransactionTypes();
});


final imageProvider = StateProvider<List<XFile?>>((ref) => []);
final svgItemsProvider = Provider<List<SvgItem>>((ref) {
  final Map<String, String> svgAssets = {
    'Descarga': 'assets/svg/ICONOS TRAN-02.svg',
    'Devolucion Vacio': 'assets/svg/ICONOS TRAN-03.svg',
    'Embarque': 'assets/svg/ICONOS TRAN-04.svg',
    'Exportacion': 'assets/svg/ICONOS TRAN-05.svg',
    'Falso Embarque': 'assets/svg/ICONOS TRAN-06.svg',
    'Ing llenos Backus': 'assets/svg/ICONOS TRAN-07.svg',
    'Ing Transito': 'assets/svg/ICONOS TRAN-08.svg',
    'Ing vacios Backus': 'assets/svg/ICONOS TRAN-09.svg',
    'Recep Vacios': 'assets/svg/ICONOS TRAN-10.svg',
    'Retiro': 'assets/svg/ICONOS TRAN-11.svg',
    'Sal Carg Cli': 'assets/svg/ICONOS TRAN-12.svg',
    'Sal Dep Simple': 'assets/svg/ICONOS TRAN-13.svg',
    'Logout': 'assets/svg/ICONOS TRAN-14.svg',
    'Sal Llenos Backus': 'assets/svg/ICONOS TRAN-15.svg',
    'Sal Transito': 'assets/svg/ICONOS TRAN-16.svg',
    'Sal Vacios Backus': 'assets/svg/ICONOS TRAN-17.svg',
  };

  return svgAssets.entries
      .map((entry) => SvgItem(name: entry.key, path: entry.value))
      .toList();
});

final searchQueryProvider = StateProvider<String>((ref) => '');
final currentPageProvider = StateProvider<int>((ref) => 1);

final filteredSvgItemsProvider = Provider<List<SvgItem>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final items = ref.watch(svgItemsProvider);

  if (query.isEmpty) return items;

  return items
      .where((item) => item.name.toLowerCase().contains(query))
      .toList();
});

final expandedContainersProvider =
    StateNotifierProvider<ExpandedContainersNotifier, Map<String, bool>>(
  (ref) => ExpandedContainersNotifier(),
);

class ExpandedContainersNotifier extends StateNotifier<Map<String, bool>> {
  ExpandedContainersNotifier() : super({});

  void toggle(String id) {
    state = {
      ...state,
      id: !(state[id] ?? false),
    };
  }

  bool isExpanded(String id) => state[id] ?? false;
}
