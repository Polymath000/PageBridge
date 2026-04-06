import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/config/themes/app_colors.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/feature/auth/presentation/widgets/custom_animation_background.dart';
import 'package:pagebridge/core/helpers/custom_search_text_field.dart';
import 'package:pagebridge/feature/databases/domain/entities/page_entity.dart';
import 'package:pagebridge/feature/databases/domain/entities/property_entity.dart';
import 'package:pagebridge/feature/databases/presentation/controllers/return_pages_cubit/return_pages_cubit.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/list_of_databases_fo_relation_search.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/relation_search_app_bar.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/relation_search_card_skeleton.dart';

class RelationSearchView extends StatefulWidget {
  static const String routeName = 'relation_search_view';
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
  List<PageEntity> _selectedPages = [];

  @override
  void initState() {
    super.initState();
    _selectedPages = List.from(widget.initialSelectedPages);
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
    setState(() {
      if (isSelected) {
        if (!_selectedPages.any((item) => item.id == page.id)) {
          _selectedPages.add(page);
        }
      } else {
        _selectedPages.removeWhere((item) => item.id == page.id);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: relationSearchAppBar(
        context: context,
        name: widget.property.name,
        selectedPages: _selectedPages,
        onSelectionConfirmed: widget.onSelectionConfirmed,
      ),
      body: Stack(
        children: [
          const CustomAnimationBackground(),
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
                          final isSelected = _selectedPages.any(
                            (p) => p.id == page.id,
                          );

                          return ListOfDatabasesFoRelationSearch(
                            isSelected: isSelected,
                            page: page,
                            onChanged: (value) => _onPageSelectionChanged(
                              page: page,
                              isSelected: value ?? false,
                            ),
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
          Icon(Icons.search_off, size: 64.sp, color: AppColors.grey),
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
