import 'package:agunsa/features/auth/display/screens/login_screen.dart';
import 'package:agunsa/features/auth/display/screens/register_screen.dart';
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
import 'package:agunsa/features/transactions/display/screens/transtacions_screen.dart';
import 'package:agunsa/features/home/display/screens/home_screen.dart';
import 'package:agunsa/utils/ui_utils.dart';
import 'package:flutter/material.dart';

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
}

class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final List<AppRoute> _routeStack = [AppRoute.splash];
  Map<String, dynamic>? _args;

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  void push(AppRoute route, {dynamic args}) {
    if (_routeStack.isNotEmpty && _routeStack.last == route) {
      return;
    }
    _routeStack.add(route);
    _args = args;
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

  @override
  Widget build(BuildContext context) {
    UiUtils().getDeviceSize(context);

    if (_routeStack.first == AppRoute.splash) {
      Future.delayed(const Duration(seconds: 6), () {
        _routeStack.first = AppRoute.login;
        notifyListeners();
      });
    }
    return Navigator(
      key: navigatorKey,
      pages: _routeStack
          .map((route) => MaterialPage(child: _buildPage(route)))
          .toList(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        popRoute();
        return true;
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
        return ChangePassword(_args?['nextStep']);
      case AppRoute.transactions:
        return TransactionsScreen(
          user: _args?['user'],
        );
      case AppRoute.takeContainer:
        return TakeContainerScreen(
          user: _args?['user'],
          transactionType: _args?['transactionType'],
        );
      case AppRoute.takeAditionalPhotos:
        return const TakeAditionalPhotos();
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
