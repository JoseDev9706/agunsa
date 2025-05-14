import 'package:agunsa/core/class/image_params.dart';
import 'package:agunsa/core/exeptions/domain_exeptions.dart';
import 'package:agunsa/features/transactions/domain/entities/deliver.dart';
import 'package:agunsa/features/transactions/domain/respositories/transaction_repositories.dart';
import 'package:dartz/dartz.dart';

class GetDni {
  final TransactionRepositories transactionRepositories;
  GetDni(this.transactionRepositories);

  Future<Either<DomainExeptions, Conductor>> call(ImageParams dniParams, String idToken) {
    return transactionRepositories.getDni(dniParams, idToken);
  }
}