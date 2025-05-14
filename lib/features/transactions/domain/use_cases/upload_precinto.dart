import 'package:agunsa/core/class/image_params.dart';
import 'package:agunsa/core/exeptions/domain_exeptions.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/domain/entities/precint.dart';
import 'package:agunsa/features/transactions/domain/respositories/transaction_repositories.dart';
import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upload_precinto.g.dart';


class UploadPrecinto {
  final TransactionRepositories transactionRepositories;
  UploadPrecinto(this.transactionRepositories);

  Future<Either<DomainExeptions, Precinct>> call(
      ImageParams precintParam, String idToken) {
    return transactionRepositories.uploadPrecint(precintParam, idToken);
  }
}

@riverpod
UploadPrecinto uploadPrecinto(UploadPrecintoRef ref) {
  return UploadPrecinto(ref.read(transactionRepositoriesProvider));
}
    
