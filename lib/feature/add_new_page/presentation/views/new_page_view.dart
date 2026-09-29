import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/feature/add_new_page/presentation/widgets/new_page_bloc_builder.dart';
import 'package:pagebridge/core/utls/setup_service_locator_getit.dart';
import 'package:pagebridge/feature/add_new_page/domain/repo/create_new_page_repo.dart';
import 'package:pagebridge/feature/databases/domain/entities/database_entity.dart';
import 'package:pagebridge/feature/add_new_page/presentation/controllers/new_page_cubit/new_page_cubit.dart';

class NewPageView extends StatelessWidget {
  const NewPageView({super.key, required this.database});
  final DatabaseEntity database;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NewPageCubit(createNewPageRepo: getit.get<CreateNewPageRepo>()),

      child: NewPageBlocBuilder(database: database),
    );
  }
}
