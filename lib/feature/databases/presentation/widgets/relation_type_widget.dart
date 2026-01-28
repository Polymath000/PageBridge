import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/core/helpers/custom_multi_dropdown.dart';
import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/core/utls/error_widget.dart';
import 'package:quicknotion/feature/databases/domain/entities/page_entity.dart';
import 'package:quicknotion/feature/databases/domain/entities/property_entity.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/return_pages_cubit/return_pages_cubit.dart';

class RelationTypeWidget extends StatefulWidget {
  const RelationTypeWidget({super.key, required this.property});
  final PropertyEntity property;

  @override
  State<RelationTypeWidget> createState() => _RelationTypeWidgetState();
}

class _RelationTypeWidgetState extends State<RelationTypeWidget> {
  List<MultiSelectItem<String>> items = [];
  List<String> _selectedPageIds = [];
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  String? nextCursor;
  bool hasMore = false;
  bool isPaginating = false;

  @override
  void initState() {
    super.initState();
    _getPages();
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

  void _onScrollEnd() {
    if (isLoading || !hasMore) return;
    _getPages(isPaginating: true);
  }

  void _searchPages() {
    if (isLoading) return;
    _getPages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFF4CAF50);

    return BlocListener<ReturnPagesCubit, ReturnPagesState>(
      listener: (context, state) {
        if (state is ReturnPagesLoading) {
          setState(() {
            isLoading = true;
          });
          return;
        }

        if (state is ReturnPagesSuccess || state is ReturnPagesSearchSuccess) {
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
            final newItems = newPagesFromState
                .map(
                  (page) => MultiSelectItem<String>(
                    label: page.title,
                    value: page.id,
                  ),
                )
                .toList();

            if (isPaginating) {
              items.addAll(newItems);
            } else {
              items = newItems;
            }

            hasMore = newHasMore;
            nextCursor = newNextCursor;
            isLoading = false;
            isPaginating = false;
          });
        }

        if (state is ReturnPagesFailure) {
          setState(() {
            isLoading = false;
            isPaginating = false;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchField(),
          const SizedBox(height: 8),
          BlocBuilder<ReturnPagesCubit, ReturnPagesState>(
            builder: (context, state) {
              if (state is ReturnPagesFailure && !isPaginating) {
                return CustomErrorWidgetRelationType(
                  errorMessage: state.message,
                );
              }

              var itemsWithLoader = List<MultiSelectItem<String>>.from(items);
              if (isPaginating && hasMore) {
                // This is a bit of a hack to show a loader at the end of the list.
                // A better way would be to have the dropdown support a footer.
                itemsWithLoader.add(
                  MultiSelectItem(
                    value: "loader" as String,
                    label: "Loading...",
                  ),
                );
              }

              if (items.isEmpty && isLoading && !isPaginating) {
                return const Center(child: CircularProgressIndicator());
              }

              return CustomMultiDropdown<String>(
                items: itemsWithLoader,
                selectedValues: _selectedPageIds,
                onSelectionChanged: (values) {
                  setState(() {
                    _selectedPageIds = values
                        .where((v) => v != "loader")
                        .toList();
                  });
                },
                hint: "Select items for ${widget.property.name}",
                chipColor: accentColor,
                scrollController: _scrollController,
                onScrollEnd: _onScrollEnd,
              );
            },
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search pages...',
        // prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: _searchPages,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onSubmitted: (_) => _searchPages(),
    );
  }
}
