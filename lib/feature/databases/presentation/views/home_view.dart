import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/core/utls/setup_service_locator_getit.dart';
import 'package:quicknotion/feature/databases/data/repos/database_repo_impl.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/add_token_cubit/add_token_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/home_app_bar.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.data});
  static const String routeName = 'home';
  final Map<String, dynamic> data;
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();
  final String _currentSearchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            AddTokenCubit(databaseRepo: getit.get<DatabaseRepoImpl>()),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            HomeAppBar(query: _currentSearchQuery),
            HomeViewBody(
              data: widget.data,
              scrollController: _scrollController,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
