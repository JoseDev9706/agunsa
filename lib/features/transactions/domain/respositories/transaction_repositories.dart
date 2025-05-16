import 'package:agunsa/core/class/image_params.dart';
import 'package:agunsa/core/exeptions/domain_exeptions.dart';
import 'package:agunsa/features/transactions/data/models/transaction.dart';
import 'package:agunsa/features/transactions/domain/entities/deliver.dart';
import 'package:agunsa/features/transactions/domain/entities/peding_transaction.dart';
import 'package:agunsa/features/transactions/domain/entities/photos.dart';
import 'package:agunsa/features/transactions/domain/entities/placa.dart';
import 'package:agunsa/features/transactions/domain/entities/precint.dart';
import 'package:agunsa/features/transactions/domain/entities/transaction_type.dart';
import 'package:agunsa/features/transactions/domain/entities/transactions.dart';
import 'package:agunsa/features/transactions/domain/use_cases/upload_precinto.dart';
import 'package:dartz/dartz.dart';

abstract class TransactionRepositories {
  Future<List<TransactionType>> getAllTransactions();
  Future<List<TransactionType>> getTransactionsByType(String type);
  Future<Either<DomainExeptions, Foto>> uploadImageToServer(
      ImageParams image, String idToken);
  Future<Either<DomainExeptions, Precinct>> uploadPrecint(
      ImageParams precintParam, String idToken);

  Future<Either<DomainExeptions, Placa>> uploadPlaca(
      ImageParams image, String idToken);

  Future<Either<DomainExeptions, Conductor>> getDni(
      ImageParams dniParams, String idToken);

  Future<Either<DomainExeptions, String?>> createTransaction(
      TransactionModel transaction);

  Future<Either<DomainExeptions, List<Transaction>>> getTransactionById(
      String id);
  Future<Either<DomainExeptions, List<PendingTransaction>>>
      getPendingTransactions();

  Future<Either<DomainExeptions, String>> createPendingTransaction(
      TransactionModel transaction);



}
