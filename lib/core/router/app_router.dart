import 'dart:developer';

import 'package:agunsa/core/class/auth_result.dart';
import 'package:agunsa/core/enum/auth_state.dart';
import 'package:agunsa/features/auth/display/providers/auth_providers.dart';
import 'package:agunsa/features/auth/display/screens/login_screen.dart';
import 'package:agunsa/features/auth/display/screens/register_screen.dart';
import 'package:agunsa/features/auth/domain/use_cases/check_session.dart';
import 'package:agunsa/features/general_info/display/screens/splash_screen.dart';
import 'package:agunsa/features/profile/display/screens/change_password.dart';
import 'package:agunsa/features/profile/display/screens/profile_screen.dart';
import 'package:agunsa/features/profile/display/screens/security_screen.dart';
import 'package:agunsa/features/transactions/display/screens/container_info.dart';
import 'package:agunsa/features/transactions/display/screens/resume_transaction.dart';
import 'package:agunsa/features/transactions/display/screens/take_aditional_photos.dart';
import 'package:agunsa/features/transactions/display/screens/take_container_screen.dart';
import 'package:agunsa/features/transactions/display/screens/take_dni_screen.dart';
import 'package:agunsa/features/transactions/display/screens/take_place_screen.dart';
import 'package:agunsa/features/transactions/display/screens/take_precint_screen.dart';
import 'package:agunsa/features/transactions/display/screens/transactions_on_process.dart';
import 'package:agunsa/features/transactions/display/screens/transtacions_screen.dart';
import 'package:agunsa/features/home/display/screens/home_screen.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppRoute {
  splash,
  login,
  register,
  home,
  profile,
  security,
  changePassword,
  transactions,
  takeContainer,
  takeAditionalPhotos,
  containerInfo,
  takePrecint,
  takeDni,
  talePlaca,
  resumeTransaction,
  proccess
}

class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final List<AppRoute> _routeStack = [AppRoute.splash];
  Map<String, dynamic>? _args;
  final CheckSession checkSessionUseCase;
  bool _hasCheckedSession = false;
  final Ref ref;
  AppRouterDelegate(this.checkSessionUseCase, this.ref)
      : navigatorKey = GlobalKey<NavigatorState>() {
    ref.listen<AuthState>(authStateProvider, (_, state) {
      _updateRouteStack(state);
    });
  }
  AppRoute _currentRoute = AppRoute.splash;
  AppRoute get currentRoute => _currentRoute;
  set currentRoute(AppRoute route) {
    _currentRoute = route;
    notifyListeners();
  }

  void push(AppRoute route, {dynamic args}) {
    if (_routeStack.isNotEmpty && _routeStack.last == route) {
      return;
    }
    log('Pushing route: $route with args: $args');
    _routeStack.add(route);
    _args = args;
    currentRoute = route;
    notifyListeners();
  }

  void pushReplacement(AppRoute route, {dynamic args}) {
    if (_routeStack.isNotEmpty && _routeStack.last == route) {
      return;
    }
    if (_routeStack.isNotEmpty) {
      _routeStack.removeLast();
    }
    _routeStack.add(route);
    _args = args;
    currentRoute = route;
    notifyListeners();
  }

  @override
  Future<bool> popRoute() async {
    if (_routeStack.length > 1) {
      _routeStack.removeLast();
      notifyListeners();
      return true;
    }
    return false;
  }

  void _updateRouteStack(AuthState state) {
    _routeStack.clear();
    switch (state) {
      case AuthState.unknown:
        _routeStack.add(AppRoute.splash);
        break;
      case AuthState.signedIn:
        _routeStack.add(AppRoute.home);
        break;
      case AuthState.signedOut:
        _routeStack.add(AppRoute.login);
        break;
    }
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    if (_routeStack.first == AppRoute.splash && !_hasCheckedSession) {
      _hasCheckedSession = true;

      checkSessionUseCase().then((result) {
        result.fold(
          (failure) {
            log('Verificación de sesión fallida: $failure');
            _routeStack.first = AppRoute.login;
            ref.read(authStateProvider.notifier).state = AuthState.signedOut;
          },
          (success) {
            if (success is AuthFailure) {
              log('Error inesperado: Sesión marcada como éxito pero es AuthFailure');
              _routeStack.first = AppRoute.login;
              ref.read(authStateProvider.notifier).state = AuthState.signedOut;
            } else {
              log('Inicio sesión verificado correctamente: ${success}');
              _routeStack.first = AppRoute.home;
              ref.read(authStateProvider.notifier).state = AuthState.signedIn;
            }
          },
        );
        notifyListeners();
      });
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        UiUtils().getDeviceSize(
          context,
          height: constraints.maxHeight,
          width: constraints.maxWidth,
        );
        return Navigator(
          key: navigatorKey,
          pages: _routeStack
              .map((route) => MaterialPage(child: _buildPage(route)))
              .toList(),
          onPopPage: (route, result) {
            if (!route.didPop(result)) return false;
            if (_routeStack.isNotEmpty) {
              _routeStack.removeLast();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                notifyListeners(); // ← Notificación segura
              });
            }
            return true;
          },
        );
      },
    );
  }

  Widget _buildPage(AppRoute route) {
    switch (route) {
      case AppRoute.splash:
        return const SplashScreen();
      case AppRoute.login:
        return const LoginScreen();
      case AppRoute.register:
        return const RegisterScreen();
      case AppRoute.home:
        return HomeScreen(
            isNeedPasswordConfirmation: _args?['nextStep'],
            user: _args?['user']);
      case AppRoute.profile:
        return const ProfileScreen();
      case AppRoute.security:
        return const SecurityScreen();
      case AppRoute.changePassword:
        return ChangePassword(_args?['nextStep'],
            isfromChangePassword: _args?['isfromChangePassword']);
      case AppRoute.transactions:
        return TransactionsScreen(
          user: _args?['user'],
        );
      case AppRoute.takeContainer:
        return TakeContainerScreen(
          transactionType: _args?['transactionType'],
        );
      case AppRoute.takeAditionalPhotos:
        return TakeAditionalPhotos(
            // user: _args?['user'],
            );
      case AppRoute.containerInfo:
        return ContainerInfo(args: _args);
      case AppRoute.takePrecint:
        return const TakePrecintScreen();
      case AppRoute.takeDni:
        return const TakeDniScreen();
      case AppRoute.talePlaca:
        return const TakePlacaScreen();
      case AppRoute.resumeTransaction:
        return const ResumeTransaction();
      case AppRoute.proccess:
        return const TransactionsOnProcess();
    }
  }

  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    _routeStack.clear();
    _routeStack.add(configuration);
    notifyListeners();
  }
}

class AppRouteInformationParser extends RouteInformationParser<AppRoute> {
  @override
  Future<AppRoute> parseRouteInformation(RouteInformation info) async {
    final uri = Uri.parse(info.location);
    switch (uri.path) {
      case '/login':
        return AppRoute.login;
      case '/home':
        return AppRoute.home;
      default:
        return AppRoute.splash;
    }
  }

  @override
  RouteInformation restoreRouteInformation(AppRoute configuration) {
    switch (configuration) {
      case AppRoute.login:
        return const RouteInformation(location: '/login');
      case AppRoute.home:
        return const RouteInformation(location: '/home');
      default:
        return const RouteInformation(location: '/');
    }
  }
}
