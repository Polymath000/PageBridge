import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/feature/auth/presentation/widgets/custom_animation_background.dart';
import 'package:quicknotion/core/utls/setup_service_locator_getit.dart';
import 'package:quicknotion/feature/databases/data/repos/database_repo_impl.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/return_databases_cubit/return_databases_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/home_app_bar.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const String routeName = 'home';
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CustomAnimationBackground(),
          BlocProvider(
            create: (context) =>
                DatabasesCubit(databaseRepo: getit.get<DatabaseRepoImpl>()),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                HomeAppBar(),
                HomeViewBody(scrollController: _scrollController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
