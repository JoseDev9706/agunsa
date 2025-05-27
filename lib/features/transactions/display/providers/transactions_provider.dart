import 'dart:convert';
import 'dart:developer';

import 'package:agunsa/core/class/image_params.dart';
import 'package:agunsa/core/class/svg_item.dart';
import 'package:agunsa/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:agunsa/features/transactions/data/models/pending_transaction.dart';
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
import 'package:agunsa/features/transactions/domain/use_cases/upload_lateral_images.dart';
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
UploadLateralImages uploadLateralImages(UploadLateralImagesRef ref) {
  return UploadLateralImages(ref.watch(transactionRepositoriesProvider));
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
  log('🔃 Cargando transactionTypesProvider...');
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
    WidgetRef ref, PendingTransactionModel transaction) async {
  final createTransactionUsecase = ref.read(createPendingTransactionProvider);
  final result = await createTransactionUsecase.call(transaction);
  return result.fold((failure) {
    sendTransaction(ref, false);
    return failure.message;
  }, (message) {
    sendTransaction(ref, true);
    return message;
  });
}

Future<List<Transaction>> getAllTransactions(WidgetRef ref) => ref
    .watch(getTransactionAllProvider)
    .call('1')
    .then((value) => value.fold((l) => [], (r) => r));

Future<List<PendingTransaction>> getPendingTransactionsFunction(
    WidgetRef ref, int userId) {
  final getPendingTransactionsUsecase =
      ref.read(getPendingTransactionsProvider);
  final result = getPendingTransactionsUsecase.call(userId);

  return result.then((value) => value.fold((l) => [], (r) => r));
}

void sendTransaction(WidgetRef ref, bool value) {
  ref.read(sendTransactionProvider.notifier).state = value;
}

Future<Foto?> uploadImageToServer(
  WidgetRef ref,
  XFile image,
  String idToken,
) async {
  final uploadUsecase = ref.read(uploadImageToServerProvider);
  final bytes = await image.readAsBytes();
  final base64Image = base64Encode(bytes);
  final fileName = (image.path.split('/').last);

  final result = await uploadUsecase.call(
    ImageParams(fileName: fileName, base64: base64Image),
    idToken,
  );

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

Future<String> uploadLateralImagesFunction(WidgetRef ref, XFile image) async {
  final uploadUsecase = ref.read(uploadLateralImagesProvider);

  final bytes = await image.readAsBytes();
  final base64Image = base64Encode(bytes);
  final result = await uploadUsecase.call(base64Image);

  return result.fold((failure) => failure.message, (message) => message);
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
      ref.read(precintProvider.notifier).state = [precinct];
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

final containerImageProvider = StateProvider<List<XFile?>>((ref) => []);
final aditionalImagesProvider = StateProvider<List<XFile?>>((ref) => []);
final precintsImageProvider = StateProvider<List<XFile?>>((ref) => []);
final placaImageProvider = StateProvider<XFile?>((ref) => null);
final dniImageProvider = StateProvider<XFile?>((ref) => null);
final placaProvider = StateProvider<Placa?>((ref) => null);
final dniProvider = StateProvider<Conductor?>((ref) => null);
final precintProvider = StateProvider<List<Precinct>?>((ref) => []);
final fotoProvider = StateProvider<Foto?>((ref) => null);
final sendTransactionProvider = StateProvider<bool>((ref) => false);
final transactionTypeSelectedProvider =
    StateProvider<TransactionType?>((ref) => null);
final selectedFilterIdProvider = StateProvider<int?>((ref) => null);
final uploadingImageProvider = StateProvider<bool>((ref) => false);
final isFromPendingTransactionProvider = StateProvider<bool>((ref) => false);
final selectedPendingTransactionProvider =
    StateProvider<PendingTransaction?>((ref) => null);

final isCompleteTransactionProvider = StateProvider<bool>((ref) => false);

void setIsCompleteTransaction(WidgetRef ref, bool isComplete) {
  ref.read(isCompleteTransactionProvider.notifier).state = isComplete;
}
void getSelectedPendingTransaction(
    WidgetRef ref, PendingTransaction? transaction) {
  if (transaction != null) {
    ref.read(selectedPendingTransactionProvider.notifier).state = transaction;
  }
}

void setIsFromPendingTransaction(WidgetRef ref, bool isFromPendingTransaction) {
  ref.read(isFromPendingTransactionProvider.notifier).state =
      isFromPendingTransaction;
}

void seleteTransactionType(WidgetRef ref, TransactionType transactionType) {
  ref.read(transactionTypeSelectedProvider.notifier).state = transactionType;
}

void setUploadingImage(WidgetRef ref, bool value) {
  ref.read(uploadingImageProvider.notifier).state = value;
}

void resetTransactionProviders(WidgetRef ref) {
  ref.read(containerImageProvider.notifier).state = [];
  ref.read(aditionalImagesProvider.notifier).state = [];
  ref.read(precintsImageProvider.notifier).state = [];
  ref.read(placaImageProvider.notifier).state = null;
  ref.read(dniImageProvider.notifier).state = null;
  ref.read(placaProvider.notifier).state = null;
  ref.read(dniProvider.notifier).state = null;
  ref.read(precintProvider.notifier).state = null;
  ref.read(fotoProvider.notifier).state = null;

  ref.read(sendTransactionProvider.notifier).state = false;

  ref.invalidate(transactionsControllerProvider);

  ref.read(transactionTypeSelectedProvider.notifier).state = null;
  ref.read(selectedFilterIdProvider.notifier).state = null;
  ref.read(selectedPendingTransactionProvider.notifier).state = null;
  ref.invalidate(transactionTypesProvider);
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

final currentPageProvider = StateProvider<int>((ref) => 1);

final filteredTransactionTypesProvider =
    Provider<AsyncValue<List<TransactionType>>>((ref) {
      
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final transactionTypesAsync = ref.watch(transactionTypesProvider);

  return transactionTypesAsync.whenData((transactionTypes) {
    if (searchQuery.isEmpty) return transactionTypes;

    return transactionTypes
        .where((item) => (item.name ?? '').toLowerCase().contains(searchQuery))
        .toList();
  });
});

final searchQueryProvider = StateProvider<String>((ref) => '');
