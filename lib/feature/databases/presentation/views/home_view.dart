import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/core/utls/setup_service_locator_getit.dart';
import 'package:quicknotion/feature/databases/data/repos/database_repo_impl.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/add_token_cubit/add_token_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String routeName = 'home';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            AddTokenCubit(databaseRepo: getit.get<DatabaseRepoImpl>()),
        child: const SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16, top: 16),
              child: HomeViewBody(),
            ),
          ),
        ),
      ),
    );
  }
}
