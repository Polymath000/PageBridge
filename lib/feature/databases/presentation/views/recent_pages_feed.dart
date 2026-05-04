import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/core/utls/setup_service_locator_getit.dart';
import 'package:pagebridge/feature/databases/domain/repo/recent_pages_repo.dart';
import 'package:pagebridge/feature/databases/presentation/controllers/recent_pages_cubit/recent_pages_cubit.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/home_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class RecentPagesFeed extends StatefulWidget {
  const RecentPagesFeed({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  State<RecentPagesFeed> createState() => _RecentPagesFeedState();
}

class _RecentPagesFeedState extends State<RecentPagesFeed> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent * 0.9) {
      context.read<RecentPagesCubit>().fetchMore();
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RecentPagesCubit(repo: getit.get<RecentPagesRepo>())..fetchRecentPages(),
      child: Builder(
        builder: (context) {
          return CustomScrollView(
            controller: widget.scrollController,
            slivers: [
              HomeAppBar(title: 'Recent Pages', showActions: false),
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  await context.read<RecentPagesCubit>().fetchRecentPages();
                },
              ),
              BlocBuilder<RecentPagesCubit, RecentPagesState>(
                builder: (context, state) {
                  if (state is RecentPagesLoading) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is RecentPagesFailure) {
                    return SliverFillRemaining(
                      child: Center(child: Text(state.message)),
                    );
                  } else if (state is RecentPagesSuccess) {
                    if (state.pages.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(child: Text('No recent pages found.')),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index >= state.pages.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                            final page = state.pages[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                                ),
                                child: ListTile(
                                  leading: page.iconEmoji != null
                                      ? Text(page.iconEmoji!, style: const TextStyle(fontSize: 24))
                                      : page.iconUrl != null
                                          ? Image.network(
                                              page.iconUrl!,
                                              width: 24,
                                              height: 24,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  const Icon(Icons.description),
                                            )
                                          : const Icon(Icons.description),
                                  title: Text(
                                    page.title,
                                    style: AppTextStyles.titleMedium?.copyWith(fontSize: 15),
                                  ),
                                  trailing: const Icon(Icons.open_in_new, size: 20, color: Colors.grey),
                                  onTap: () {
                                    if (page.url.isNotEmpty) {
                                      launchUrl(
                                        Uri.parse(page.url),
                                        mode: LaunchMode.externalApplication,
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                          childCount: state.hasMore
                              ? state.pages.length + 1
                              : state.pages.length,
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
