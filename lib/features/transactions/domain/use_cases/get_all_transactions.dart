import 'package:agunsa/core/exeptions/domain_exeptions.dart';
import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';
import 'package:agunsa/features/transactions/domain/entities/transactions.dart';
import 'package:agunsa/features/transactions/domain/respositories/transaction_repositories.dart';
import 'package:dartz/dartz.dart';

class GetAllTransactions {
  final TransactionRepositories transactionRepositories;
  GetAllTransactions(this.transactionRepositories);

  Future<Either<DomainExeptions, List<Transaction>>> call(String id) {
    return transactionRepositories.getTransactionById(id);
  }
}