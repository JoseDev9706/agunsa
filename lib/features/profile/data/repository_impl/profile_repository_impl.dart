import 'package:agunsa/features/profile/data/datasources/profile_remote_datasources.dart';
import 'package:agunsa/features/profile/domain/respositories/profile_repository.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDataSource;
  // final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl(
     this.remoteDataSource,
    // required this.localDataSource,
  );
  
  @override
  Future<void> changePassword({required String oldPassword, required String newPassword, required SignInResult isNeedPasswordConfirmation,})async {
    try {
      return await remoteDataSource.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        isNeedPasswordConfirmation: isNeedPasswordConfirmation,
      );
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<void> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }
  
  @override
  Future<void> updateProfile({required String name, required String email, required String phone, required String address}) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

 
}