import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/core/utls/setup_service_locator_getit.dart';
import 'package:pagebridge/feature/auth/presentation/veiw/auth_view.dart';
import 'package:pagebridge/feature/databases/domain/repo/return_pages_repo.dart';
import 'package:pagebridge/feature/databases/domain/entities/database_entity.dart';
import 'package:pagebridge/feature/databases/domain/entities/page_entity.dart';
import 'package:pagebridge/feature/databases/domain/entities/property_entity.dart';
import 'package:pagebridge/feature/databases/presentation/controllers/return_pages_cubit/return_pages_cubit.dart';
import 'package:pagebridge/feature/databases/presentation/views/home_view.dart';
import 'package:pagebridge/feature/databases/presentation/views/new_page_view.dart';
import 'package:pagebridge/feature/databases/presentation/views/relation_search_view.dart';
import 'package:pagebridge/feature/onStartedViews/presentation/views/onboarding_view.dart';
import 'package:pagebridge/feature/onStartedViews/presentation/views/splash_view.dart';
import 'package:pagebridge/core/helpers/page_not_found_view.dart';

sealed class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String newPage = '/newPage';
  static const String relationSearch = '/relationSearch';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _fadeRoute(const SplashView());
      case onboarding:
        return _fadeRoute(const OnboardingView());
      case auth:
        return _fadeRoute(const AuthView());
      case home:
        return _fadeRoute(HomeView());
      case newPage:
        final data = settings.arguments! as DatabaseEntity;
        return _fadeRoute(NewPageView(database: data));
      case relationSearch:
        final data = settings.arguments! as Map<String, dynamic>;
        return _fadeRoute(
          BlocProvider(
            create: (context) =>
                ReturnPagesCubit(repo: getit.get<ReturnPagesRepo>()),
            child: RelationSearchView(
              property: data['property'] as PropertyEntity,
              initialSelectedPages: data['initialSelectedPages'] as List<PageEntity>,
              onSelectionConfirmed:
                  data['onSelectionConfirmed'] as ValueChanged<List<PageEntity>>?,
            ),
          ),
        );
      default:
        return _fadeRoute(const PageNotFoundView());
    }
  }

  static PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
