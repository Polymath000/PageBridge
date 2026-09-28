import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/core/services/shared_preferences_singleton.dart';
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
      _databasesScrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final workspaceName = SharedPreferencesSingleton.getString('workspaceName');
    final databasesTitle = workspaceName ?? 'Databases';

    return Scaffold(
      body: Stack(
        children: [
          const CustomAnimationBackground(),
          BlocProvider(
            create: (context) =>
                DatabasesCubit(databaseRepo: getit.get<DatabaseRepo>()),
            child: Builder(
              builder: (context) {
                return CustomScrollView(
                  controller: _databasesScrollController,
                  slivers: [
                    HomeAppBar(title: databasesTitle),
                    CupertinoSliverRefreshControl(
                      onRefresh: () async {
                        await context.read<DatabasesCubit>().returnDatabases();
                      },
                    ),
                    HomeViewBody(scrollController: _databasesScrollController),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              child: const Icon(Icons.arrow_upward),
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

