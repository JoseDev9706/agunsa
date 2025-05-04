import 'dart:developer';

import 'package:agunsa/features/transactions/data/datasources/transaction_remote_datasource.dart';
import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';
import 'package:agunsa/features/transactions/domain/respositories/transaction_repositories.dart';

class TransactionRespositoriesImpl implements TransactionRepositories {
  final TransactionRemoteDatasource remoteDataSource;

  TransactionRespositoriesImpl(this.remoteDataSource);
  @override
  Future<List<TransactionType>> getAllTransactions() {
    try {
      return remoteDataSource.getAllTransactions();
    } catch (e) {
      log('Error in getAllTransactions: $e');
      rethrow;
    }
  }

  @override
  Future<List<TransactionType>> getTransactionsByType(String type) {
    // TODO: implement getTransactionsByType
    throw UnimplementedError();
  }
}