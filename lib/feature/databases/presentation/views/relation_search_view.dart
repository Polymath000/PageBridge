import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/core/helpers/custom_search_text_field.dart';
import 'package:quicknotion/core/utls/custom_loading_indecator.dart';
import 'package:quicknotion/feature/databases/domain/entities/page_entity.dart';
import 'package:quicknotion/feature/databases/domain/entities/property_entity.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/return_pages_cubit/return_pages_cubit.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/relation_search_app_bar.dart';

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
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<PageEntity> _pages = [];
  List<PageEntity> _selectedPages = [];
  bool isLoading = false;
  String? nextCursor;
  bool hasMore = false;
  bool isPaginating = false;
  bool _isReloading = false;

  @override
  void initState() {
    super.initState();
    _selectedPages = List.from(widget.initialSelectedPages);
    _getPages();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final controller = _scrollController;
    if (controller == null || !controller.hasClients || isLoading || !hasMore) {
      return;
    }
    final maxScroll = controller.position.maxScrollExtent;
    final current = controller.position.pixels;
    if (current >= maxScroll * 0.75) {
      _getPages(isPaginating: true);
    }
  }

  Future<void> _onSearchChanged() async {
    setState(() {
      _pages.clear();
      nextCursor = null;
      hasMore = false;
    });
    await _getPages();
  }

  Future<void> _getPages({bool isPaginating = false}) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
      this.isPaginating = isPaginating;
    });
    final token = await SecureStorage.readData(key: tokenKey);
    context.read<ReturnPagesCubit>().returnPages(
      token: token ?? "",
      query: _searchController.text,
      startCursor: isPaginating ? nextCursor : null,
      databaseId: widget.property.relationDatabaseId ?? "",
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: relationSearchAppBar(
        context: context,
        getPages: _getPages,
        isReloading: _isReloading,
        name: widget.property.name,
        selectedPages: _selectedPages,
        onSelectionConfirmed: widget.onSelectionConfirmed,
      ),
      body: Column(
        children: [
          CustomSearchTextField(
            getPages: _onSearchChanged,
            searchController: _searchController,
            hintText: 'Search pages...',
          ),
          Expanded(
            child: BlocConsumer<ReturnPagesCubit, ReturnPagesState>(
              listener: (context, state) {
                if (state is ReturnPagesLoading) {
                  setState(() {
                    _isReloading = true;
                  });
                  return;
                }

                if (state is ReturnPagesSuccess ||
                    state is ReturnPagesSearchSuccess) {
                  final List<PageEntity> newPagesFromState;
                  final bool newHasMore;
                  final String? newNextCursor;

                  if (state is ReturnPagesSuccess) {
                    newPagesFromState = state.pages;
                    newHasMore = state.hasMore;
                    newNextCursor = state.nextCursor;
                  } else {
                    final searchState = state as ReturnPagesSearchSuccess;
                    newPagesFromState = searchState.pages;
                    newHasMore = searchState.hasMore;
                    newNextCursor = searchState.nextCursor;
                  }

                  setState(() {
                    if (!isPaginating) {
                      _pages.clear();
                    }
                    _pages.addAll(newPagesFromState);
                    hasMore = newHasMore;
                    nextCursor = newNextCursor;
                    isLoading = false;
                    isPaginating = false;
                    _isReloading = false;
                  });
                }
                if (state is ReturnPagesFailure) {
                  setState(() {
                    isLoading = false;
                    isPaginating = false;
                    _isReloading = false;
                  });
                }
              },
              builder: (context, state) {
                if (state is ReturnPagesFailure) {
                  return Center(child: Text('Error: ${state.message}'));
                }

                if (_pages.isEmpty && isLoading) {
                  return const CustomLoadingIndecator(height: 50);
                }

                if (_pages.isEmpty && !isLoading) {
                  return _buildEmptyState();
                }

                final total = _pages.length + (isLoading ? 1 : 0);

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: total,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  itemBuilder: (context, index) {
                    if (index == _pages.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }
                    final page = _pages[index];
                    final isSelected = _selectedPages.any(
                      (p) => p.id == page.id,
                    );
                    return Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: CheckboxListTile(
                        title: Text(
                          page.title,
                          style: AppTextStyles.titleMedium!.copyWith(
                            fontSize: 15.sp,
                            color: isSelected ? AppColors.primary : null,
                          ),
                        ),
                        value: isSelected,
                        activeColor: AppColors.primary,
                        checkColor: Colors.white,
                        controlAffinity: ListTileControlAffinity.trailing,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              if (!_selectedPages.any((p) => p.id == page.id)) {
                                _selectedPages.add(page);
                              }
                            } else {
                              _selectedPages.removeWhere(
                                (p) => p.id == page.id,
                              );
                            }
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
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
