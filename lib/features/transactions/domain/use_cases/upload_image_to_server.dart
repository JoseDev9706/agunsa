import 'package:agunsa/core/class/image_params.dart';
import 'package:agunsa/core/exeptions/domain_exeptions.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/domain/entities/photos.dart';
import 'package:agunsa/features/transactions/domain/respositories/transaction_repositories.dart';
import 'package:dartz/dartz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

 part 'upload_image_to_server.g.dart';
class UploadImageToServer {
  final TransactionRepositories transactionRepositories;

  UploadImageToServer( this.transactionRepositories);
  Future<Either<DomainExeptions, Foto>> call(
      ImageParams image, String idToken) {
    return transactionRepositories.uploadImageToServer(image, idToken);
  }


}

@riverpod
UploadImageToServer uploadImageToServer(UploadImageToServerRef ref) {
  return UploadImageToServer(ref.read(transactionRepositoriesProvider));
}

