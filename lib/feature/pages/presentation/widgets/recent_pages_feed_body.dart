import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/core/helpers/custom_search_text_field.dart';
import 'package:pagebridge/feature/pages/presentation/controllers/recent_pages_cubit/recent_pages_cubit.dart';
import 'package:pagebridge/feature/pages/presentation/widgets/recent_pages_list.dart';

class RecentPagesFeedBody extends StatelessWidget {
  const RecentPagesFeedBody({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: CustomSearchTextField(
              hintText: "Search Recent Pages",
              getPages: (value) {
                context.read<RecentPagesCubit>().search(value);
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          RecentPagesList(controller: scrollController),
        ],
      ),
    );
  }
}
