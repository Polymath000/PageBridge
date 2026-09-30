import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/core/utls/setup_service_locator_getit.dart';
import 'package:pagebridge/feature/pages/domain/repo/recent_pages_repo.dart';
import 'package:pagebridge/feature/pages/presentation/controllers/recent_pages_cubit/recent_pages_cubit.dart';
import 'package:pagebridge/core/helpers/custom_app_bar.dart';
import 'package:pagebridge/core/helpers/custom_floating_action_button.dart';
import 'package:pagebridge/feature/pages/presentation/widgets/recent_pages_feed_body.dart';

class RecentPagesFeed extends StatefulWidget {
  const RecentPagesFeed({super.key});

  @override
  State<RecentPagesFeed> createState() => _RecentPagesFeedState();
}

class _RecentPagesFeedState extends State<RecentPagesFeed> {
  final ValueNotifier<bool> _showFab = ValueNotifier<bool>(false);
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      if (_scrollController.offset > 200 && !_showFab.value) {
        _showFab.value = true;
      } else if (_scrollController.offset <= 200 && _showFab.value) {
        _showFab.value = false;
      }
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _showFab.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
              RecentPagesCubit(repo: getit.get<RecentPagesRepo>())
                ..fetchRecentPages(),
          child: Builder(
            builder: (context) {
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<RecentPagesCubit>().fetchRecentPages();
                },
                color: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    CustomAppBar(title: 'Recent Pages', showActions: false),
                    RecentPagesFeedBody(
                      scrollController: _scrollController,
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _showFab,
        builder: (context, show, child) {
          if (!show) return const SizedBox.shrink();
          return CustomFloatingActionButton(onPressed: _scrollToTop);
        },
      ),
    );
  }
}
