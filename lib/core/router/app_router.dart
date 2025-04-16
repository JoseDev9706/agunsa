import 'package:agunsa/features/auth/display/screens/login_screen.dart';
import 'package:agunsa/features/auth/display/screens/register_screen.dart';
import 'package:agunsa/features/profile/display/screens/profile_screen.dart';
import 'package:agunsa/home/display/screens/home_screen.dart';
import 'package:agunsa/utils/ui_utils.dart';
import 'package:flutter/material.dart';

enum AppRoute { splash,login, register, home, profile,  }

class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  @override
  final GlobalKey<NavigatorState> navigatorKey; 
  AppRoute _currentRoute = AppRoute.splash;
  Map<String, dynamic>? _args;

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  void push(AppRoute route, {dynamic args}) {
    _currentRoute = route;
    _args = args;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    UiUtils().getDeviceSize(context);
    if (_currentRoute == AppRoute.splash) {
      Future.delayed(const Duration(seconds: 2), () {
        _currentRoute = AppRoute.login;
        notifyListeners();
      });
    }
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey('SplashPage'),
          child: _buildPage(_currentRoute),
        ),
      ],
      onPopPage: (route, result) => false,
    );
  }

  Widget _buildPage(AppRoute route) {
    switch (route) {
      case AppRoute.splash:
        return const Placeholder();
      case AppRoute.login:
        return const LoginScreen();
      case AppRoute.register:
        return const RegisterScreen();
      case AppRoute.home:
        return const HomeScreen();
      case AppRoute.profile:
        return const ProfileScreen();
      default:
        return const LoginScreen();
    }
  }

  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    _currentRoute = configuration;
  }
}

class AppRouteInformationParser extends RouteInformationParser<AppRoute> {
  @override
  Future<AppRoute> parseRouteInformation(RouteInformation routeInformation) async {
    return AppRoute.splash;
  }

  @override
  RouteInformation restoreRouteInformation(AppRoute configuration) {
    return const RouteInformation(location: '/');
  }
}
