import 'package:agunsa/core/exeptions/domain_exeptions.dart';
import 'package:agunsa/features/transactions/data/models/pending_transaction.dart';
import 'package:agunsa/features/transactions/data/models/transaction.dart';
import 'package:agunsa/features/transactions/domain/entities/peding_transaction.dart';
import 'package:agunsa/features/transactions/domain/entities/transactions.dart';
import 'package:agunsa/features/transactions/domain/respositories/transaction_repositories.dart';
import 'package:dartz/dartz.dart';

class CreatePendingTransaction {
  CreatePendingTransaction(this.transactionRepositories);
  final TransactionRepositories transactionRepositories;

  Future<Either<DomainExeptions, String>> call(
      PendingTransactionModel transaction) {
    return transactionRepositories.createPendingTransaction(transaction);
  }
}