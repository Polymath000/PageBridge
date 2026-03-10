import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/core/helpers/custom_search_text_field.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/return_databases_cubit/return_databases_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/databases_list.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({
    super.key,
    required this.data,
    required this.scrollController,
  });
  final Map<String, dynamic> data;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: CustomSearchTextField(
              getPages: (value) {
                context.read<DatabasesCubit>().returnDatabases(query: value);
              },
              hintText: "Search Databases",
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 6)),
          DatabasesList(
            dataFromToken: data,
            controller: scrollController,
          ),
        ],
      ),
    );
  }
}
