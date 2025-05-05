import 'package:agunsa/features/transactions/domain/entities/photos.dart';
import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';

abstract class TransactionRepositories {
  Future<List<TransactionType>> getAllTransactions();
  Future<List<TransactionType>> getTransactionsByType(String type);
  Future<Foto> uploadImageToServer(Foto image, String idToken);
}