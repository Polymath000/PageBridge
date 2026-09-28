import 'package:pagebridge/config/themes/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:pagebridge/feature/main_layout/presentation/cubit/main_layout_cubit.dart";
import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:pagebridge/core/utls/setup_service_locator_getit.dart';
import 'package:pagebridge/feature/auth/presentation/widgets/custom_animation_background.dart';
import 'package:pagebridge/feature/databases/domain/repo/database_repo.dart';
import 'package:pagebridge/feature/databases/presentation/controllers/return_databases_cubit/return_databases_cubit.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/home_app_bar.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const String routeName = 'home';
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _databasesScrollController = ScrollController();
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _databasesScrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_databasesScrollController.hasClients) {
      if (_databasesScrollController.offset > 200 && !_showFab) {
        setState(() => _showFab = true);
      } else if (_databasesScrollController.offset <= 200 && _showFab) {
        setState(() => _showFab = false);
      }
    }
  }

  void _scrollToTop() {
    if (_databasesScrollController.hasClients) {
      _databasesScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const CustomAnimationBackground(),
            BlocProvider(
              create: (context) =>
                  DatabasesCubit(databaseRepo: getit.get<DatabaseRepo>()),
              child: Builder(
                builder: (context) {
                  final workspaceName = context
                      .read<MainLayoutCubit>()
                      .workspaceName;
                  final databasesTitle = workspaceName ?? 'Databases';
                  return CustomScrollView(
                    controller: _databasesScrollController,
                    slivers: [
                      HomeAppBar(title: databasesTitle),
                      HomeViewBody(
                        scrollController: _databasesScrollController,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _showFab
          ? Padding(
              padding: const EdgeInsets.only(bottom: 70.0),
              child: FloatingActionButton(
                onPressed: _scrollToTop,
                backgroundColor: AppColors.darkGrey,
                foregroundColor: AppColors.topaz,
                tooltip: 'scroll up',
                child: Icon(AppIcons.arrowUp),
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _databasesScrollController.removeListener(_scrollListener);
    _databasesScrollController.dispose();
    super.dispose();
  }
}
