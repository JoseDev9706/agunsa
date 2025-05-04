// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionRemoteDatasourceHash() =>
    r'c1b83b38aee5638ec3c91045af535145dc50e9aa';

/// See also [transactionRemoteDatasource].
@ProviderFor(transactionRemoteDatasource)
final transactionRemoteDatasourceProvider =
    AutoDisposeProvider<TransactionRemoteDatasource>.internal(
  transactionRemoteDatasource,
  name: r'transactionRemoteDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionRemoteDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionRemoteDatasourceRef
    = AutoDisposeProviderRef<TransactionRemoteDatasource>;
String _$transactionRepositoriesHash() =>
    r'117bb5f2adde8831978348f2b1d292dfd9926f52';

/// See also [transactionRepositories].
@ProviderFor(transactionRepositories)
final transactionRepositoriesProvider =
    AutoDisposeProvider<TransactionRepositories>.internal(
  transactionRepositories,
  name: r'transactionRepositoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionRepositoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionRepositoriesRef
    = AutoDisposeProviderRef<TransactionRepositories>;
String _$transactionsControllerHash() =>
    r'8df28845e7b612102d7eb247a066b9466fddf5bf';

/// See also [TransactionsController].
@ProviderFor(TransactionsController)
final transactionsControllerProvider =
    AutoDisposeAsyncNotifierProvider<TransactionsController, void>.internal(
  TransactionsController.new,
  name: r'transactionsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TransactionsController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
