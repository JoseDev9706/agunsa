import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';

abstract class TransactionRepositories {
  Future<List<TransactionType>> getAllTransactions();
  Future<List<TransactionType>> getTransactionsByType(String type);
}