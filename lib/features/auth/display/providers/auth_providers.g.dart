// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRemoteDataSourceHash() =>
    r'819c04331aefb3fa516b00df705e29aad40356f4';

/// See also [authRemoteDataSource].
@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider =
    AutoDisposeProvider<AuthRemoteDataSource>.internal(
  authRemoteDataSource,
  name: r'authRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRemoteDataSourceRef = AutoDisposeProviderRef<AuthRemoteDataSource>;
String _$authRepositoryHash() => r'6268e0ddfbe44b94edfab963f0c223b425f6717b';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = AutoDisposeProviderRef<AuthRepository>;
String _$checkSessionUseCaseHash() =>
    r'6aeea886c8e396250356b4f2e71d931fc615997d';

/// See also [checkSessionUseCase].
@ProviderFor(checkSessionUseCase)
final checkSessionUseCaseProvider = AutoDisposeProvider<CheckSession>.internal(
  checkSessionUseCase,
  name: r'checkSessionUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$checkSessionUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CheckSessionUseCaseRef = AutoDisposeProviderRef<CheckSession>;
String _$logoutUsecaseHash() => r'454fe19963a86df829aaa198fac7fc2049b66831';

/// See also [logoutUsecase].
@ProviderFor(logoutUsecase)
final logoutUsecaseProvider = AutoDisposeProvider<LogoutUsecase>.internal(
  logoutUsecase,
  name: r'logoutUsecaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$logoutUsecaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LogoutUsecaseRef = AutoDisposeProviderRef<LogoutUsecase>;
String _$loginFormStateHash() => r'3d19c77776e77a79b2113450df7a5ccd746d2920';

/// See also [LoginFormState].
@ProviderFor(LoginFormState)
final loginFormStateProvider =
    AutoDisposeNotifierProvider<LoginFormState, LoginFormData>.internal(
  LoginFormState.new,
  name: r'loginFormStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loginFormStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LoginFormState = AutoDisposeNotifier<LoginFormData>;
String _$loginControllerHash() => r'2cc8230d3562553626e12b3c71baf5d47281d7b1';

/// See also [LoginController].
@ProviderFor(LoginController)
final loginControllerProvider =
    AutoDisposeAsyncNotifierProvider<LoginController, void>.internal(
  LoginController.new,
  name: r'loginControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loginControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LoginController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
