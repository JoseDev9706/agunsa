import 'dart:developer';

import 'package:agunsa/core/enum/auth_state.dart';
import 'package:agunsa/features/auth/display/providers/auth_providers.dart';
import 'package:agunsa/features/profile/data/datasources/profile_remote_datasources.dart';
import 'package:agunsa/features/profile/domain/respositories/profile_repository.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository_impl/profile_repository_impl.dart';
part 'profile_provider.g.dart';

@riverpod
ProfileRemoteDatasource profileRemoteDataSource(
    ProfileRemoteDataSourceRef ref) {
  return ProfileRemoteDatasourceImpl();
}

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepositoryImpl(ref.watch(profileRemoteDataSourceProvider));
}

@riverpod
class ChangePasswordFormState extends _$ChangePasswordFormState {
  @override
  ChangePasswordData build() {
    return const ChangePasswordData();
  }

  void updateCurrentPassword(String value) {
    state = state.copyWith(currentPassword: value);
  }

  void updateNewPassword(String value) {
    state = state.copyWith(newPassword: value);
  }

  void updateConfirmNewPassword(String value) {
    state = state.copyWith(confirmNewPassword: value);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void clearFields() {
    state = const ChangePasswordData();
  }

  void setCurrentPasswordError(String error) {
    state = state.copyWith(currentPasswordError: error);
  }

  void setNewPasswordError(String error) {
    state = state.copyWith(newPasswordError: error);
  }

  void setConfirmPasswordError(String error) {
    state = state.copyWith(confirmPasswordError: error);
  }

  void clearCurrentPasswordError() {
    state = state.copyWith(currentPasswordError: null);
  }

  void clearNewPasswordError() {
    state = state.copyWith(newPasswordError: null);
  }

  void clearConfirmPasswordError() {
    state = state.copyWith(confirmPasswordError: null);
  }

  bool validate() {
    final isValid = state.currentPassword.isNotEmpty &&
        state.newPassword.isNotEmpty &&
        state.confirmNewPassword.isNotEmpty &&
        state.newPassword.length >= 6 &&
        state.newPassword == state.confirmNewPassword;

    state = state.copyWith(isValid: isValid);
    return isValid;
  }
}

final isNeedPasswordConfirmationProvider =
    StateProvider<SignInResult?>((ref) => null);

@riverpod
class ChangePasswordController extends _$ChangePasswordController {
  @override
  FutureOr<void> build() {}

Future<bool> changePassword(
    String currentPassword,
    String newPassword,
    SignInResult? isNeedPasswordConfirmation,
  ) async {
    try {
      await ref.read(profileRepositoryProvider).changePassword(
            oldPassword: currentPassword,
            newPassword: newPassword,
            isNeedPasswordConfirmation: isNeedPasswordConfirmation,
          );
      if (isNeedPasswordConfirmation != null &&
          isNeedPasswordConfirmation.nextStep.signInStep.name ==
              'confirmSignInWithNewPassword') {
        ref.read(isNeedPasswordConfirmationProvider.notifier).state = null;
        ref.read(authStateProvider.notifier).state = AuthState.signedIn;
      } else {
        ref.read(isNeedPasswordConfirmationProvider.notifier).state = null;
      }
      return true;
    } catch (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
      return false;
    }
  }

}

class ChangePasswordData {
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;
  final bool obscurePassword;
  final bool isValid;

  final String? currentPasswordError;
  final String? newPasswordError;
  final String? confirmPasswordError;

  const ChangePasswordData(
      {this.currentPassword = '',
      this.newPassword = '',
      this.confirmNewPassword = '',
      this.obscurePassword = true,
      this.isValid = false,
      this.currentPasswordError,
      this.newPasswordError,
      this.confirmPasswordError});

  ChangePasswordData copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmNewPassword,
    bool? obscurePassword,
    bool? isValid,
    String? emailError,
    String? confirmPasswordError,
    String? newPasswordError,
    String? currentPasswordError,
  }) {
    return ChangePasswordData(
        currentPassword: currentPassword ?? this.currentPassword,
        newPassword: newPassword ?? this.newPassword,
        confirmNewPassword: confirmNewPassword ?? this.confirmNewPassword,
        obscurePassword: obscurePassword ?? this.obscurePassword,
        isValid: isValid ?? this.isValid,
        currentPasswordError: currentPasswordError ?? this.currentPasswordError,
        newPasswordError: newPasswordError ?? this.newPasswordError,
        confirmPasswordError:
            confirmPasswordError ?? this.confirmPasswordError);
  }
}
