import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/config/themes/app_icons.dart';
import 'package:quicknotion/core/utls/setup_service_locator_getit.dart';
import 'package:quicknotion/feature/databases/data/repos/database_repo_impl.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/add_token_cubit/add_token_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const String routeName = 'home';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            AddTokenCubit(databaseRepo: getit.get<DatabaseRepoImpl>()),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Theme.of(context).brightness == Brightness.light
                            ? Icon(AppIcons.darkMode)
                            : Icon(AppIcons.lightMode),
                        onPressed: () => context
                            .read<ThemeModeCubit>()
                            .changeThemeMode(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  const HomeViewBody(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
