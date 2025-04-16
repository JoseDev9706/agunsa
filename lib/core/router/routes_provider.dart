import 'package:agunsa/core/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routerDelegateProvider = Provider<AppRouterDelegate>((ref) {
  return AppRouterDelegate();
});