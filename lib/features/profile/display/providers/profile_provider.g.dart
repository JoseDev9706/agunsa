// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileRemoteDataSourceHash() =>
    r'fe496d2ad1044a93b56c7757bd06df8e7b1206c9';

/// See also [profileRemoteDataSource].
@ProviderFor(profileRemoteDataSource)
final profileRemoteDataSourceProvider =
    AutoDisposeProvider<ProfileRemoteDatasource>.internal(
  profileRemoteDataSource,
  name: r'profileRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileRemoteDataSourceRef
    = AutoDisposeProviderRef<ProfileRemoteDatasource>;
String _$profileRepositoryHash() => r'e8f6dfbf2f102fbeb34125e9a2b39faaafb5d305';

/// See also [profileRepository].
@ProviderFor(profileRepository)
final profileRepositoryProvider =
    AutoDisposeProvider<ProfileRepository>.internal(
  profileRepository,
  name: r'profileRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProfileRepositoryRef = AutoDisposeProviderRef<ProfileRepository>;
String _$changePasswordFormStateHash() =>
    r'4a4e860ca1083a81d3224203bd8a78a6d59a651b';

/// See also [ChangePasswordFormState].
@ProviderFor(ChangePasswordFormState)
final changePasswordFormStateProvider = AutoDisposeNotifierProvider<
    ChangePasswordFormState, ChangePasswordData>.internal(
  ChangePasswordFormState.new,
  name: r'changePasswordFormStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$changePasswordFormStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChangePasswordFormState = AutoDisposeNotifier<ChangePasswordData>;
String _$changePasswordControllerHash() =>
    r'f9f7f16f8669124d5ed70dec0494fcfe87919af4';

/// See also [ChangePasswordController].
@ProviderFor(ChangePasswordController)
final changePasswordControllerProvider =
    AutoDisposeAsyncNotifierProvider<ChangePasswordController, void>.internal(
  ChangePasswordController.new,
  name: r'changePasswordControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$changePasswordControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ChangePasswordController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
