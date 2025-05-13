import 'package:agunsa/core/exeptions/domain_exeptions.dart';
import 'package:agunsa/features/transactions/domain/entities/photos.dart';
import 'package:agunsa/features/transactions/domain/entities/precint.dart';
import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';
import 'package:agunsa/features/transactions/domain/use_cases/upload_precinto.dart';
import 'package:dartz/dartz.dart';

abstract class TransactionRepositories {
  Future<List<TransactionType>> getAllTransactions();
  Future<List<TransactionType>> getTransactionsByType(String type);
  Future<Foto> uploadImageToServer(Foto image, String idToken);
  Future<Either<DomainExeptions, Precinct>> uploadPrecint(
      PrecinctParam precintParam, String idToken);
}