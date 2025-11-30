import 'package:flutter/material.dart';
import 'package:quicknotion/feature/databases/presentation/views/home_view.dart';
import 'package:quicknotion/feature/onboarding&splash/presentation/views/splash_view.dart';
import 'package:quicknotion/feature/databases/presentation/views/token_view.dart';

sealed class AppRoutes {
  const AppRoutes();
  static void pop<T extends Object?>(
    final BuildContext context, [
    final T? result,
  ]) => Navigator.pop<T>(context);

  static Future<T?> _pushNamed<T extends Object?>(
    final BuildContext context,
    final String routeName, {
    final Object? arguments,
  }) => Navigator.pushNamed<T>(context, routeName, arguments: arguments);

  static Future<T?> _pushNamedAndRemoveAll<T extends Object?>(
    final BuildContext context,
    final String newRouteName, {
    final Object? arguments,
  }) => Navigator.pushNamedAndRemoveUntil<T>(
    context,
    newRouteName,
    (_) => false,
    arguments: arguments,
  );

  // Routes with arguments

  // static Future<Object?> createNewPasswordView(
  //   final BuildContext context, {
  //   required final String email,
  //   required final String code,
  // }) => _pushNamed(
  //   context,
  //   CreateNewPasswordView.routeName,
  //   arguments: CreateNewPasswordViewArgs(email: email, code: code),
  // );

  // Routes without arguments
  // static Future<Object?> onboardingView(final BuildContext context) =>
  // _pushNamedAndRemoveAll(context, OnboardingView.routeName);
  static Future<Object?> tokenView(final BuildContext context) =>
      _pushNamedAndRemoveAll(context, TokenView.routeName);
  static Future<Object?> homeView(final BuildContext context) =>
      _pushNamedAndRemoveAll(context, HomeView.routeName);
  static Future<Object?> splashView(final BuildContext context) =>
      _pushNamedAndRemoveAll(context, SplashView.routeName);
}

class CreateNewPasswordViewArgs {
  const CreateNewPasswordViewArgs({required this.email, required this.code});
  final String email;
  final String code;
}

Map<String, Widget Function(BuildContext, Object?)> _routes = {
  TokenView.routeName: (_, _) => const TokenView(),
  HomeView.routeName: (_, _) => const HomeView(),
  SplashView.routeName: (_, _) => const SplashView(),

  // OnboardingView.routeName: (_, _) => const OnboardingView(),
  // CreateNewPasswordView.routeName: (_, final args) {
  //   final data = args! as CreateNewPasswordViewArgs;
  //   return CreateNewPasswordView(email: data.email, code: data.code);
  // },
};

Route<dynamic>? Function(RouteSettings)? onGenerateRoute = (final settings) {
  final builder =
      _routes[settings.name] ??
      (_, _) => const Scaffold(body: Center(child: Text('Page not found')));
  return MaterialPageRoute(
    builder: (final context) => builder(context, settings.arguments),
    settings: settings,
  );
};
