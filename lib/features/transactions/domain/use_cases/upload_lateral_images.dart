import 'package:agunsa/core/exeptions/domain_exeptions.dart';
import 'package:agunsa/features/transactions/domain/respositories/transaction_repositories.dart';
import 'package:dartz/dartz.dart';

class UploadLateralImages {
  final TransactionRepositories transactionRepositories;
  UploadLateralImages(this.transactionRepositories);
  Future<Either<DomainExeptions, String>> call(String base64Image){
    return transactionRepositories.uploadLateralImages(base64Image);
  }
}