import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/core/utls/setup_service_locator_getit.dart';
import 'package:quicknotion/feature/databases/data/repos/return_pages_repo_impl.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';
import 'package:quicknotion/feature/databases/domain/entities/page_entity.dart';
import 'package:quicknotion/feature/databases/domain/entities/property_entity.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/return_pages_cubit/return_pages_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/views/home_view.dart';
import 'package:quicknotion/feature/databases/presentation/views/new_page_view.dart';
import 'package:quicknotion/feature/databases/presentation/views/relation_search_view.dart';
import 'package:quicknotion/feature/databases/presentation/views/token_view.dart';
import 'package:quicknotion/feature/onboarding&splash/presentation/views/splash_view.dart';

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

  static Future<Object?> newPageView(
    final BuildContext context, {
    required final DatabaseEntity database,
  }) => _pushNamed(context, NewPageView.routeName, arguments: database);
  static Future<Object?> tokenView(final BuildContext context) =>
      _pushNamedAndRemoveAll(context, TokenView.routeName);
  static Future<Object?> homeView(final BuildContext context) =>
      _pushNamedAndRemoveAll(context, HomeView.routeName);
  static Future<Object?> splashView(final BuildContext context) =>
      _pushNamedAndRemoveAll(context, SplashView.routeName);

  static Future<Object?> relationSearchView(
    final BuildContext context, {
    required final PropertyEntity property,
    required final List<PageEntity> initialSelectedPages,
    final ValueChanged<List<PageEntity>>? onSelectionConfirmed,
  }) => _pushNamed(
    context,
    RelationSearchView.routeName,
    arguments: {
      'property': property,
      'initialSelectedPages': initialSelectedPages,
      'onSelectionConfirmed': onSelectionConfirmed,
    },
  );
}

Map<String, Widget Function(BuildContext, Object?)> _routes = {
  TokenView.routeName: (_, _) => const TokenView(),

  HomeView.routeName: (_, _) => HomeView(),

  SplashView.routeName: (_, _) => const SplashView(),
  NewPageView.routeName: (_, final args) {
    final data = args! as DatabaseEntity;
    return NewPageView(database: data);
  },
  RelationSearchView.routeName: (_, final args) {
    final data = args! as Map<String, dynamic>;
    return BlocProvider(
      create: (context) =>
          ReturnPagesCubit(repoImpl: getit.get<ReturnPagesRepoImpl>()),
      child: RelationSearchView(
        property: data['property'] as PropertyEntity,
        initialSelectedPages: data['initialSelectedPages'] as List<PageEntity>,
        onSelectionConfirmed:
            data['onSelectionConfirmed'] as ValueChanged<List<PageEntity>>?,
      ),
    );
  },
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
