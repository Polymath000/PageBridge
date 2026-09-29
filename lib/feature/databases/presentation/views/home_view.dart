import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:pagebridge/feature/main_layout/presentation/cubit/main_layout_cubit.dart";
import 'package:pagebridge/core/utls/setup_service_locator_getit.dart';
import 'package:pagebridge/feature/databases/domain/repo/database_repo.dart';
import 'package:pagebridge/feature/databases/presentation/controllers/return_databases_cubit/return_databases_cubit.dart';
import 'package:pagebridge/core/helpers/custom_app_bar.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/home_view_body.dart';
import 'package:pagebridge/core/helpers/custom_floating_action_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _databasesScrollController = ScrollController();
  final ValueNotifier<bool> _showFab = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _databasesScrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_databasesScrollController.hasClients) {
      if (_databasesScrollController.offset > 200 && !_showFab.value) {
        _showFab.value = true;
      } else if (_databasesScrollController.offset <= 200 && _showFab.value) {
        _showFab.value = false;
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
  void dispose() {
    _showFab.dispose();
    _databasesScrollController.removeListener(_scrollListener);
    _databasesScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            BlocProvider(
              create: (context) =>
                  DatabasesCubit(databaseRepo: getit.get<DatabaseRepo>()),
              child: Builder(
                builder: (context) {
                  final workspaceName = context
                      .read<MainLayoutCubit>()
                      .workspaceName;
                  final databasesTitle = workspaceName ?? 'Databases';
                  final theme = Theme.of(context);
                  return RefreshIndicator(
                    onRefresh: () async {
                      await context.read<DatabasesCubit>().returnDatabases();
                    },
                    color: theme.colorScheme.primary,
                    backgroundColor: theme.colorScheme.surface,
                    child: CustomScrollView(
                      controller: _databasesScrollController,
                      slivers: [
                        CustomAppBar(title: databasesTitle),
                        HomeViewBody(
                          scrollController: _databasesScrollController,
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 60)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _showFab,
        builder: (context, show, child) {
          if (!show) return const SizedBox.shrink();
          return CustomFloatingActionButton(onPressed: _scrollToTop);
        },
      ),
    );
  }
}
