import 'dart:developer';

import 'package:agunsa/core/class/auth_result.dart';
import 'package:agunsa/core/enum/auth_state.dart';
import 'package:agunsa/features/auth/data/datasources/remote_datasources/auth_remote_datasources.dart';
import 'package:agunsa/features/auth/data/repository_impl/auth_repository_impl.dart';
import 'package:agunsa/features/auth/domain/entities/user_entity.dart';
import 'package:agunsa/features/auth/domain/respositories/auth_repository.dart';
import 'package:agunsa/features/auth/domain/use_cases/check_session.dart';
import 'package:agunsa/features/auth/domain/use_cases/login_usecase.dart';
import 'package:agunsa/features/auth/domain/use_cases/logout_usecase.dart';
import 'package:agunsa/features/profile/display/providers/profile_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

// Proveedores de datos y repositorios
@riverpod
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  return AuthRemoteDataSourceImpl(Dio());
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
}

@riverpod
CheckSession checkSessionUseCase(AutoDisposeProviderRef<CheckSession> ref) {
  return CheckSession(ref.watch(authRepositoryProvider));
}

@riverpod
LogoutUsecase logoutUsecase(AutoDisposeProviderRef<LogoutUsecase> ref) {
  return LogoutUsecase(ref.watch(authRepositoryProvider));
}

// Estado del formulario de login
@riverpod
class LoginFormState extends _$LoginFormState {
  @override
  LoginFormData build() {
    return const LoginFormData();
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void setEmailError(String error) {
    state = state.copyWith(emailError: error);
  }

  void setPasswordError(String error) {
    state = state.copyWith(passwordError: error);
  }

  void clearEmailError() {
    state = state.copyWith(emailError: null);
  }

  void clearPasswordError() {
    state = state.copyWith(passwordError: null);
  }

  bool validate() {
    final isValid = state.email.isNotEmpty &&
        state.password.isNotEmpty &&
        state.password.length >= 6;
    state = state.copyWith(isValid: isValid);
    return isValid;
  }
}

final authStateProvider = StateProvider<AuthState>((ref) => AuthState.unknown);

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {}

  Future<AuthResult?> login(String email, String password) async {
    try {
      state = const AsyncLoading();

      final result =
          await ref.read(loginUseCaseProvider).execute(email, password);

      state = AsyncData(result);
      return result;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      await ref.read(logoutUsecaseProvider).call();

      ref.read(userProvider.notifier).state = null;
      ref.read(authStateProvider.notifier).state = AuthState.signedOut;
      ref.read(isNeedPasswordConfirmationProvider.notifier).state = null;
      return true;
    } catch (error, stackTrace) {
      log(error.toString(), stackTrace: stackTrace);
      return false;
    }
  }
}

final userProvider = StateProvider<UserEntity?>((ref) => null);
void setUser(UserEntity user, WidgetRef ref) =>
    ref.read(userProvider.notifier).state = user;
    

class LoginFormData {
  final String email;
  final String password;
  final bool obscurePassword;
  final bool isValid;
  final String? emailError;
  final String? passwordError;

  const LoginFormData({
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
    this.isValid = false,
    this.emailError,
    this.passwordError,
  });

  LoginFormData copyWith({
    String? email,
    String? password,
    bool? obscurePassword,
    bool? isValid,
    String? emailError,
    String? passwordError,
  }) {
    return LoginFormData(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isValid: isValid ?? this.isValid,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
    );
  }

  
}
