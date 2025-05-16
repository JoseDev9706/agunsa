import 'dart:convert';
import 'dart:developer';

import 'package:agunsa/core/class/image_params.dart';
import 'package:agunsa/core/class/svg_item.dart';
import 'package:agunsa/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:agunsa/features/transactions/data/models/transaction.dart';
import 'package:agunsa/features/transactions/data/repository_impl/transaction_respositories_impl.dart';
import 'package:agunsa/features/transactions/domain/entities/deliver.dart';
import 'package:agunsa/features/transactions/domain/entities/peding_transaction.dart';
import 'package:agunsa/features/transactions/domain/entities/photos.dart';
import 'package:agunsa/features/transactions/domain/entities/placa.dart';
import 'package:agunsa/features/transactions/domain/entities/precint.dart';
import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';
import 'package:agunsa/features/transactions/domain/entities/transactions.dart';
import 'package:agunsa/features/transactions/domain/respositories/transaction_repositories.dart';
import 'package:agunsa/features/transactions/domain/use_cases/create_pending_transaction.dart';
import 'package:agunsa/features/transactions/domain/use_cases/create_transaction.dart';
import 'package:agunsa/features/transactions/domain/use_cases/get_all_transactions.dart';
import 'package:agunsa/features/transactions/domain/use_cases/get_dni.dart';
import 'package:agunsa/features/transactions/domain/use_cases/get_pending_transactions.dart';
import 'package:agunsa/features/transactions/domain/use_cases/get_transaction_types.dart';
import 'package:agunsa/features/transactions/domain/use_cases/upload_image_to_server.dart';
import 'package:agunsa/features/transactions/domain/use_cases/upload_placa.dart';
import 'package:agunsa/features/transactions/domain/use_cases/upload_precinto.dart';
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
UploadPlaca uploadPlaca(UploadPlacaRef ref) {
  return UploadPlaca(ref.watch(transactionRepositoriesProvider));
}

@riverpod
GetDni getDni(GetDniRef ref) {
  return GetDni(ref.watch(transactionRepositoriesProvider));
}

@riverpod
CreateTransaction createTransaction(CreateTransactionRef ref) {
  return CreateTransaction(ref.watch(transactionRepositoriesProvider));
}

@riverpod
CreatePendingTransaction createPendingTransaction(
    CreatePendingTransactionRef ref) {
  return CreatePendingTransaction(ref.watch(transactionRepositoriesProvider));
}

@riverpod
GetPendingTransactions getPendingTransactions(GetPendingTransactionsRef ref) {
  return GetPendingTransactions(ref.watch(transactionRepositoriesProvider));
}

@riverpod
GetAllTransactions getTransactionAll(GetTransactionAllRef ref) {
  return GetAllTransactions(ref.watch(transactionRepositoriesProvider));
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
Future<String?> createTransactionFuntion(
    WidgetRef ref, TransactionModel transaction) async {
  final createTransactionUsecase = ref.read(createTransactionProvider);
  final result = await createTransactionUsecase.call(transaction);
  return result.fold((failure) {
    sendTransaction(ref, false);
    return failure.message;
  }, (message) {
    sendTransaction(ref, true);
    return message;
  });
}

Future<String?> createPendingTransactionFuntion(
    WidgetRef ref, TransactionModel transaction) async {
  final createTransactionUsecase = ref.read(createPendingTransactionProvider);
  final result = await createTransactionUsecase.call(transaction);
  return result.fold((failure) {
    return failure.message;
  }, (message) {
    return message;
  });
}

Future<List<Transaction>> getAllTransactions(WidgetRef ref) => ref
    .watch(getTransactionAllProvider)
    .call('1')
    .then((value) => value.fold((l) => [], (r) => r));

Future<List<PendingTransaction>> getPendingTransactionsFunction(WidgetRef ref) {
  final getPendingTransactionsUsecase =
      ref.read(getPendingTransactionsProvider);
  final result = getPendingTransactionsUsecase.call();

  return result.then((value) => value.fold((l) => [], (r) => r));
}

void sendTransaction(WidgetRef ref, bool value) {
  ref.read(sendTransactionProvider.notifier).state = value;
}
Future<Foto?> uploadImageToServer(
    WidgetRef ref, XFile image, String idToken) async {
  final uploadUsecase = ref.read(uploadImageToServerProvider);
  final bytes = await image.readAsBytes();
  final base64Image = base64Encode(bytes);
  final fileName = (image.path.split('/').last);
  
  final result = await uploadUsecase.call(
      ImageParams(fileName: fileName, base64: base64Image), idToken);

  return result.fold(
    (failure) {
      ref.read(fotoProvider.notifier).state = null;
      return null;
    },
    (foto) {
      ref.read(fotoProvider.notifier).state = foto;
      return foto;
    },
  );
}


Future<Precinct?> uploadPrecint(
    WidgetRef ref, XFile photoPrecint, String idToken) async {
  final uploadUsecase = ref.read(uploadPrecintoProvider);

  final bytes = await photoPrecint.readAsBytes();
  final base64Image = base64Encode(bytes);
  final fileName = (photoPrecint.path.split('/').last);
  final precint = ImageParams(fileName: fileName, base64: base64Image);
  final result = await uploadUsecase.call(precint, idToken);

  return result.fold(
    (failure) {
      ref.read(precintProvider.notifier).state = null;
      return null;
    },
    (precinct) {
      ref.read(precintProvider.notifier).state = precinct;
      return precinct;
    },
  );
}

Future<Conductor?> getDniInfo(WidgetRef ref, XFile dni) async {
  final getDniUsecase = ref.read(getDniProvider);
  final bytes = await dni.readAsBytes();
  final base64Image = base64Encode(bytes);
  final fileName = (dni.path.split('/').last);
  final result = await getDniUsecase.call(
      ImageParams(fileName: fileName, base64: base64Image), '');

  return result.fold(
    (failure) => null,
    (conductor) {
      ref.read(dniProvider.notifier).state = conductor;
      return conductor;
    },
  );
}

Future<Placa?> getPlacaInfo(WidgetRef ref, XFile placa, String idToken) async {
  final getPlacaUsecase = ref.read(uploadPlacaProvider);
  final bytes = await placa.readAsBytes();
  final base64Image = base64Encode(bytes);
  final fileName = (placa.path.split('/').last);
  final result = await getPlacaUsecase.call(
      ImageParams(fileName: fileName, base64: base64Image), idToken);

  return result.fold(
    (failure) => null,
    (placa) {
      ref.read(placaProvider.notifier).state = placa;
      return placa;
    },
  );
}

final imageProvider = StateProvider<List<XFile?>>((ref) => []);
final placaProvider = StateProvider<Placa?>((ref) => null);
final dniProvider = StateProvider<Conductor?>((ref) => null);
final precintProvider = StateProvider<Precinct?>((ref) => null);
final fotoProvider = StateProvider<Foto?>((ref) => null);
final sendTransactionProvider = StateProvider<bool>((ref) => false);
final transactionTypeSelectedProvider =
    StateProvider<TransactionType?>((ref) => null);
final selectedFilterIdProvider = StateProvider<int?>((ref) => null);

void seleteTransactionType(WidgetRef ref, TransactionType transactionType) {
  ref.read(transactionTypeSelectedProvider.notifier).state = transactionType;
}

void resetTransactionProviders(WidgetRef ref) {
  ref.read(imageProvider.notifier).state = [];
  ref.read(placaProvider.notifier).state = null;
  ref.read(dniProvider.notifier).state = null;
  ref.read(precintProvider.notifier).state = null;
  ref.read(fotoProvider.notifier).state = null;

  ref.read(sendTransactionProvider.notifier).state = false;

  ref.invalidate(transactionsControllerProvider);
}



final expandedPendingTransactionsProvider = StateProvider<bool>((ref) => false);

void toggleExpandedPendingTransactions(WidgetRef ref, bool value) {
  ref.read(expandedPendingTransactionsProvider.notifier).state = value;
}


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
