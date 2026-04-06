import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/core/utls/error_widget.dart';
import 'package:pagebridge/feature/databases/presentation/controllers/return_databases_cubit/return_databases_cubit.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/custom_skeletonizer_database.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/database_card.dart';

class DatabasesList extends StatefulWidget {
  final ScrollController controller;
  const DatabasesList({super.key, required this.controller});

  @override
  State<DatabasesList> createState() => _DatabasesListState();
}

class _DatabasesListState extends State<DatabasesList> {
  @override
  void initState() {
    context.read<DatabasesCubit>().returnDatabases();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.controller.addListener(() {
      if (widget.controller.position.pixels >=
          widget.controller.position.maxScrollExtent * 0.75) {
        context.read<DatabasesCubit>().fetchMore();
      }
    });
    return BlocBuilder<DatabasesCubit, DatabasesState>(
      builder: (context, state) {
        if (state is DatabasesLoading) {
          return SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.8,
                child: Column(
                  children: List.generate(
                    (MediaQuery.sizeOf(context).height * 0.007).toInt(),
                    (index) => CustomSkeletonizerDatabase(),
                  ),
                ),
              ),
            ]),
          );
        }
        if (state is DatabasesFailure) {
          return SliverToBoxAdapter(
            child: CustomErrorWidget(errorMessage: state.message),
          );
        }
        if (state is DatabasesSuccess) {
          final items = state.databases;
          if (items.isEmpty) {
            return const SliverToBoxAdapter(
              child: CustomErrorWidget(
                errorMessage: "There are no databases found.",
              ),
            );
          }
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index >= items.length) {
                return SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  child: Column(
                    children: List.generate(
                      (MediaQuery.sizeOf(context).height * 0.012).toInt(),
                      (index) => CustomSkeletonizerDatabase(),
                    ),
                  ),
                );
              }
              return DatabaseCard(database: items[index]);
            }, childCount: items.length + (state.isPaginating ? 1 : 0)),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
