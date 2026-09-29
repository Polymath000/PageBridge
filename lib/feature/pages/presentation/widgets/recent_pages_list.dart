import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/config/themes/app_icons.dart';
import 'package:pagebridge/core/helpers/custom_empty_state.dart';
import 'package:pagebridge/core/utls/error_widget.dart';
import 'package:pagebridge/feature/pages/presentation/controllers/recent_pages_cubit/recent_pages_cubit.dart';
import 'package:pagebridge/feature/pages/presentation/widgets/custom_skeletonizer_recent_page.dart';
import 'package:pagebridge/feature/pages/presentation/widgets/recent_page_card.dart';

class RecentPagesList extends StatefulWidget {
  final ScrollController controller;
  const RecentPagesList({super.key, required this.controller});

  @override
  State<RecentPagesList> createState() => _RecentPagesListState();
}

class _RecentPagesListState extends State<RecentPagesList> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (widget.controller.position.pixels >=
        widget.controller.position.maxScrollExtent * 0.75) {
      context.read<RecentPagesCubit>().fetchMore();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentPagesCubit, RecentPagesState>(
      builder: (context, state) {
        if (state is RecentPagesLoading) {
          return SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.8,
                child: Column(
                  children: List.generate(
                    (MediaQuery.sizeOf(context).height * 0.007).toInt(),
                    (index) => const CustomSkeletonizerRecentPage(),
                  ),
                ),
              ),
            ]),
          );
        }
        if (state is RecentPagesFailure) {
          return SliverToBoxAdapter(
            child: CustomErrorWidget(errorMessage: state.message),
          );
        }
        if (state is RecentPagesSuccess) {
          final items = state.pages;
          if (items.isEmpty) {
            return SliverToBoxAdapter(
              child: CustomEmptyState(
                icon: AppIcons.description,
                title: 'No recent pages found',
                subtitle: 'No recent pages found or try a different search.',
              ),
            );
          }
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index >= items.length) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CustomSkeletonizerRecentPage(),
                    const CustomSkeletonizerRecentPage(),
                  ],
                );
              }
              return RecentPageCard(page: items[index]);
            }, childCount: items.length + (state.isPaginating ? 1 : 0)),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
