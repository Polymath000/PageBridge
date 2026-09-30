import 'package:flutter/material.dart';
import 'package:pagebridge/config/themes/app_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/feature/auth/presentation/widgets/custom_animation_background.dart';
import 'package:pagebridge/core/helpers/custom_search_text_field.dart';
import 'package:pagebridge/feature/pages/domain/entities/page_entity.dart';
import 'package:pagebridge/feature/databases/domain/entities/property_entity.dart';
import 'package:pagebridge/feature/pages/presentation/controllers/return_pages_cubit/return_pages_cubit.dart';
import 'package:pagebridge/feature/add_new_page/presentation/widgets/database_list_item_for_relation_search.dart';
import 'package:pagebridge/feature/add_new_page/presentation/widgets/relation_search_app_bar.dart';
import 'package:pagebridge/feature/add_new_page/presentation/widgets/relation_search_card_skeleton.dart';

class RelationSearchView extends StatefulWidget {
  final PropertyEntity property;
  final List<PageEntity> initialSelectedPages;
  final ValueChanged<List<PageEntity>>? onSelectionConfirmed;

  const RelationSearchView({
    super.key,
    required this.property,
    required this.initialSelectedPages,
    this.onSelectionConfirmed,
  });

  @override
  State<RelationSearchView> createState() => _RelationSearchViewState();
}

class _RelationSearchViewState extends State<RelationSearchView> {
  final ScrollController _scrollController = ScrollController();
  late final ValueNotifier<List<PageEntity>> _selectedPagesNotifier;

  @override
  void initState() {
    super.initState();
    _selectedPagesNotifier = ValueNotifier(
      List.from(widget.initialSelectedPages),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReturnPagesCubit>().returnPages(
        databaseId: widget.property.relationDatabaseId ?? "",
      );
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.75) {
      context.read<ReturnPagesCubit>().fetchMore();
    }
  }

  void _onPageSelectionChanged({
    required PageEntity page,
    required bool isSelected,
  }) {
    final currentList = List<PageEntity>.from(_selectedPagesNotifier.value);
    if (isSelected) {
      if (!currentList.any((item) => item.id == page.id)) {
        currentList.add(page);
      }
    } else {
      currentList.removeWhere((item) => item.id == page.id);
    }
    _selectedPagesNotifier.value = currentList;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _selectedPagesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RelationSearchAppBar(
        name: widget.property.name,
        onDone: () {
          widget.onSelectionConfirmed?.call(_selectedPagesNotifier.value);
          Navigator.pop(context, _selectedPagesNotifier.value);
        },
      ),
      body: Stack(
        children: [
          const CustomAnimationBackground(isAnimated: false),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16,
                ),
                child: CustomSearchTextField(
                  getPages: (value) {
                    context.read<ReturnPagesCubit>().returnPages(
                      query: value,
                      databaseId: widget.property.relationDatabaseId ?? "",
                    );
                  },
                  hintText: 'Search pages...',
                ),
              ),
              Expanded(
                child: BlocBuilder<ReturnPagesCubit, ReturnPagesState>(
                  builder: (context, state) {
                    if (state is ReturnPagesFailure) {
                      return Center(child: Text('Error: ${state.message}'));
                    }

                    if (state is ReturnPagesLoading) {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        itemCount: 6,
                        itemBuilder: (context, index) =>
                            const RelationSearchCardSkeleton(),
                      );
                    }

                    if (state is ReturnPagesSuccess) {
                      final pages = state.pages;

                      if (pages.isEmpty) {
                        return _buildEmptyState();
                      }

                      final totalCount =
                          pages.length + (state.isPaginating ? 1 : 0);

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: totalCount,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        itemBuilder: (context, index) {
                          if (index == pages.length) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: const RelationSearchCardSkeleton(),
                            );
                          }

                          final page = pages[index];

                          return ValueListenableBuilder<List<PageEntity>>(
                            valueListenable: _selectedPagesNotifier,
                            builder: (context, selectedPages, child) {
                              final isSelected = selectedPages.any(
                                (p) => p.id == page.id,
                              );

                              return DatabaseListItemForRelationSearch(
                                isSelected: isSelected,
                                page: page,
                                onChanged: (value) => _onPageSelectionChanged(
                                  page: page,
                                  isSelected: value ?? false,
                                ),
                              );
                            },
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppIcons.searchOff, size: 64.sp, color: AppColors.grey),
          SizedBox(height: 16.h),
          Text(
            "No pages found",
            style: AppTextStyles.titleMedium!.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
