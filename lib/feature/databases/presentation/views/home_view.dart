import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/core/services/shared_preferences_singleton.dart';
import 'package:pagebridge/core/utls/setup_service_locator_getit.dart';
import 'package:pagebridge/feature/auth/presentation/widgets/custom_animation_background.dart';
import 'package:pagebridge/feature/databases/domain/repo/database_repo.dart';
import 'package:pagebridge/feature/databases/presentation/controllers/return_databases_cubit/return_databases_cubit.dart';
import 'package:pagebridge/feature/databases/presentation/views/recent_pages_feed.dart';
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
  final ScrollController _recentPagesScrollController = ScrollController();
  bool _showFab = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _databasesScrollController.addListener(_scrollListener);
    _recentPagesScrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final controller = _currentIndex == 0 ? _databasesScrollController : _recentPagesScrollController;
    if (controller.hasClients) {
      if (controller.offset > 200 && !_showFab) {
        setState(() => _showFab = true);
      } else if (controller.offset <= 200 && _showFab) {
        setState(() => _showFab = false);
      }
    }
  }

  void _scrollToTop() {
    final controller = _currentIndex == 0 ? _databasesScrollController : _recentPagesScrollController;
    if (controller.hasClients) {
      controller.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
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
          if (_currentIndex == 0)
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
                          await context
                              .read<DatabasesCubit>()
                              .returnDatabases();
                        },
                      ),
                      HomeViewBody(scrollController: _databasesScrollController),
                    ],
                  );
                },
              ),
            )
          else
            RecentPagesFeed(scrollController: _recentPagesScrollController),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            final controller = _currentIndex == 0 ? _databasesScrollController : _recentPagesScrollController;
            if (controller.hasClients) {
              _showFab = controller.offset > 200;
            } else {
              _showFab = false;
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Databases',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Recent Pages',
          ),
        ],
      ),
      floatingActionButton: _showFab ? FloatingActionButton(
        onPressed: _scrollToTop,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.arrow_upward),
      ) : null,
    );
  }

  @override
  void dispose() {
    _databasesScrollController.removeListener(_scrollListener);
    _recentPagesScrollController.removeListener(_scrollListener);
    _databasesScrollController.dispose();
    _recentPagesScrollController.dispose();
    super.dispose();
  }
}

