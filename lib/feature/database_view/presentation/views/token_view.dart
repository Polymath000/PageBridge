import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/feature/database_view/data/repos/database_repo_impl.dart';
import 'package:quicknotion/feature/database_view/presentation/controllers/add_token_cubit/add_token_cubit.dart';
import 'package:quicknotion/feature/database_view/presentation/widgets/token_view_body.dart';
import '../../../../core/utls/setup_service_locator_getit.dart';

class TokenView extends StatelessWidget {
  const TokenView({super.key});
  static const String routeName = 'token';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            AddTokenCubit(databaseRepo: getit.get<DatabaseRepoImpl>()),
        child: TokenViewBody(),
      ),
    );
  }
}
