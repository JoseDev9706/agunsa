import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/features/auth/display/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routerDelegateProvider = Provider<AppRouterDelegate>((ref) {
  final checkSession = ref.watch(checkSessionUseCaseProvider);
  return AppRouterDelegate(checkSession, ref);
});
