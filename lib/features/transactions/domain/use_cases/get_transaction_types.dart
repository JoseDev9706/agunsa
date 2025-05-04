import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';
import 'package:agunsa/features/transactions/domain/respositories/transaction_repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_transaction_types.g.dart';

class GetTransactionTypes {
  final TransactionRepositories transactionRepository;
  const GetTransactionTypes(this.transactionRepository);

  Future<List<TransactionType>> call() {
    return transactionRepository.getAllTransactions();
   
  }


}

@riverpod
GetTransactionTypes getTransactionTypes(GetTransactionTypesRef ref) {
  return GetTransactionTypes(ref.watch(transactionRepositoriesProvider));
}


