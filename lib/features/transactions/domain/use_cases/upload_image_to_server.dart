import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/domain/entities/photos.dart';
import 'package:agunsa/features/transactions/domain/respositories/transaction_repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

 part 'upload_image_to_server.g.dart';
class UploadImageToServer {
  final TransactionRepositories transactionRepositories;

  UploadImageToServer( this.transactionRepositories);
  Future<Foto> call(Foto image, String idToken) {
    return transactionRepositories.uploadImageToServer(image, idToken);
  }


}

@riverpod
UploadImageToServer uploadImageToServer(UploadImageToServerRef ref) {
  return UploadImageToServer(ref.read(transactionRepositoriesProvider));
}