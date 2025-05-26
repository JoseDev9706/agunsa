import 'package:agunsa/core/exeptions/domain_exeptions.dart';
import 'package:agunsa/features/transactions/domain/entities/peding_transaction.dart';
import 'package:agunsa/features/transactions/domain/entities/transactions.dart';
import 'package:agunsa/features/transactions/domain/respositories/transaction_repositories.dart';
import 'package:dartz/dartz.dart';

class GetPendingTransactions {
  final TransactionRepositories transactionRepositories;
  GetPendingTransactions(this.transactionRepositories);

  Future<Either<DomainExeptions, List<PendingTransaction>>> call(
      int userId) async {
    return transactionRepositories.getPendingTransactions(userId);
  }
  
}