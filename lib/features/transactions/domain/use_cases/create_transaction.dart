import 'package:agunsa/core/exeptions/domain_exeptions.dart';
import 'package:agunsa/features/transactions/data/models/transaction.dart';
import 'package:agunsa/features/transactions/domain/entities/transactions.dart';
import 'package:agunsa/features/transactions/domain/respositories/transaction_repositories.dart';
import 'package:dartz/dartz.dart';

class CreateTransaction {
  final TransactionRepositories transactionRepositories;

  CreateTransaction(this.transactionRepositories);
  Future<Either<DomainExeptions, String?>> call(TransactionModel transaction) {
    return transactionRepositories.createTransaction(transaction);
  }
}