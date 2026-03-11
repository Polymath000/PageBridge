import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/feature/databases/data/repos/database_repo_impl.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/return_databases_cubit/return_databases_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/token_view_body.dart';

import '../../../../core/utls/setup_service_locator_getit.dart';

class TokenView extends StatelessWidget {
  const TokenView({super.key});
  static const String routeName = 'token';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            DatabasesCubit(databaseRepo: getit.get<DatabaseRepoImpl>()),
        child: TokenViewBody(),
      ),
    );
  }
}
