import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/core/utls/custom_loading_indecator.dart';
import 'package:quicknotion/feature/databases/domain/entities/page_entity.dart';
import 'package:quicknotion/feature/databases/domain/entities/property_entity.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/return_pages_cubit/return_pages_cubit.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';

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
  List<PageEntity> _pages = [];
  List<PageEntity> _selectedPages = [];
  bool isLoading = false;
  String? nextCursor;
  bool hasMore = false;
  bool isPaginating = false;

  @override
  void initState() {
    super.initState();
    _selectedPages = List.from(widget.initialSelectedPages);
    _getPages();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (!isLoading && hasMore) {
        _getPages(isPaginating: true);
      }
    }
  }

  Future<void> _getPages({bool isPaginating = false}) async {
    if (isLoading && !isPaginating) return;
    setState(() {
      isLoading = true;
      this.isPaginating = isPaginating;
    });
    final token = await SecureStorage.readData(key: tokenKey);
    if (!mounted) return;
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Search in ${widget.property.name}",
          style: AppTextStyles.titleMedium!.copyWith(fontSize: 18.sp),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.onSelectionConfirmed?.call(_selectedPages);
              Navigator.pop(context, _selectedPages);
            },
            child: Text(
              "Done",
              style: AppTextStyles.titleMedium!.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _getPages(),
              decoration: InputDecoration(
                hintText: 'Search pages...',
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkSurface
                    : AppColors.lightSurface,
                prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _getPages();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
          Expanded(
            child: BlocListener<ReturnPagesCubit, ReturnPagesState>(
              listener: (context, state) {
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
                    if (isPaginating) {
                      _pages.addAll(newPagesFromState);
                    } else {
                      _pages = newPagesFromState;
                    }
                    hasMore = newHasMore;
                    nextCursor = newNextCursor;
                    isLoading = false;
                    isPaginating = false;
                  });
                } else if (state is ReturnPagesFailure) {
                  setState(() {
                    isLoading = false;
                    isPaginating = false;
                  });
                }
              },
              child: _pages.isEmpty && isLoading && !isPaginating
                  ? const CustomLoadingIndecator(height: 50)
                  : _pages.isEmpty && !isLoading
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _pages.length + (hasMore ? 1 : 0),
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
                                  if (!_selectedPages.any(
                                    (p) => p.id == page.id,
                                  )) {
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
                    ),
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
