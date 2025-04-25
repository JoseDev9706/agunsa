import 'package:agunsa/features/profile/display/providers/profile_provider.dart';
import 'package:agunsa/features/profile/domain/respositories/profile_repository.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'update_password.g.dart';

class UpdatePassordUseCase {
  final ProfileRepository _profileRepository;

  UpdatePassordUseCase(this._profileRepository);

  Future<void> call(String password, String newPassword,  SignInResult isNeedPasswordConfirmation,) async {
    return await _profileRepository.changePassword(
      oldPassword: password,
      newPassword: newPassword,
      isNeedPasswordConfirmation: isNeedPasswordConfirmation,
    );
  }
}

@riverpod
UpdatePassordUseCase updatePassordUseCase(UpdatePassordUseCaseRef ref) {
  return UpdatePassordUseCase(ref.watch(profileRepositoryProvider));
}