import 'package:agunsa/core/class/image_params.dart';
import 'package:agunsa/core/exeptions/domain_exeptions.dart';
import 'package:agunsa/features/transactions/domain/entities/placa.dart';
import 'package:agunsa/features/transactions/domain/respositories/transaction_repositories.dart';
import 'package:dartz/dartz.dart';

class UploadPlaca {
  final TransactionRepositories transactionRepositories;

  UploadPlaca(this.transactionRepositories);

  Future<Either<DomainExeptions, Placa>> call(
      ImageParams image, String idToken) {
    return transactionRepositories.uploadPlaca(image, idToken);
  }

}