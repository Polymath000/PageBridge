import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:quicknotion/config/themes/app_icons.dart';
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
  final controller = MultiSelectController<String>();
  List<DropdownItem<String>> items = [];
  String _currentSearchQuery = "";
  final ScrollController _scrollController = ScrollController();
  List<PageEntity> pages = [];
  bool isLoading = false;
  String? nextCursor;
  bool hasMore = false;
  bool isPaginating = false;
  final _formKey = GlobalKey<FormState>();

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
    List<PageEntity> pages = await context.read<ReturnPagesCubit>().returnPages(
      token: token ?? "",
      query: _currentSearchQuery,
      startCursor: isPaginating ? nextCursor : null,
      databaseId: widget.property.relationDatabaseId ?? "",
    );
    for (var page in pages) {
      DropdownItem<String> value = DropdownItem(
        label: page.title,
        value: page.id,
      );
      items.add(value);
    }
  }

  // @override
  // void didUpdateWidget(covariant RelationTypeWidget  oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget. != _currentSearchQuery) {
  //     _getPages();
  //   }
  // }
  void _onScroll() {
    if (!_scrollController.hasClients || isLoading || !hasMore) {
      return;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    if (current >= maxScroll * 0.8) {
      _getPages(isPaginating: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color fieldBg = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final Color borderColor = isDark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFDDDDDD);
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color hintColor = isDark
        ? const Color(0xFFA0A0A0)
        : const Color(0xFF777777);
    final Color dropdownBg = isDark
        ? const Color(0xFF2F2F2F)
        : const Color(0xFFF5F5F5);
    final Color selectedBg = isDark
        ? const Color(0xFF3D3D3D)
        : const Color(0xFFE0E0E0);
    const Color accentColor = Color(0xFF4CAF50);

    return SingleChildScrollView(
      controller: _scrollController,
      child: Form(
        key: _formKey,
        child: BlocConsumer<ReturnPagesCubit, ReturnPagesState>(
          listener: (context, state) {
            if (state is ReturnPagesLoading) {
              setState(() {
                isLoading = true;
              });
              return;
            }

            if (state is ReturnPagesSuccess) {
              setState(() {
                if (!isPaginating) {
                  pages.clear();
                }

                pages.addAll(state.pages);

                for (var page in pages) {
                  DropdownItem<String> value = DropdownItem(
                    label: page.title,
                    value: page.id,
                  );
                  items.add(value);
                }
                hasMore = state.hasMore;
                nextCursor = state.nextCursor;
                isLoading = false;
                isPaginating = false;
              });
            }
            if (state is ReturnPagesSearchSuccess) {
              setState(() {
                if (!isPaginating) {
                  pages.clear();
                }
                pages.addAll(state.pages);
                hasMore = state.hasMore;
                nextCursor = state.nextCursor;
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
          builder: (context, state) {
            if (state is ReturnPagesFailure) {
              return SliverToBoxAdapter(
                child: CustomErrorWidget(errorMessage: state.message),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),

                MultiDropdown<String>(
                  items: items,
                  controller: controller,
                  searchEnabled: true,
                  onSearchChange: (value) {
                    setState(() {
                      _currentSearchQuery = value;
                    });
                  },
                  chipDecoration: ChipDecoration(
                    backgroundColor: accentColor,
                    labelStyle: const TextStyle(color: Colors.white),
                    wrap: true,
                    runSpacing: 4,
                    spacing: 6,
                  ),

                  fieldDecoration: FieldDecoration(
                    backgroundColor: fieldBg,
                    labelText: widget.property.name,
                    labelStyle: TextStyle(color: textColor),
                    hintText: "Select items",
                    hintStyle: TextStyle(color: hintColor, fontSize: 14.sp),
                    showClearIcon: false,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: accentColor),
                    ),
                  ),

                  dropdownItemDecoration: DropdownItemDecoration(
                    backgroundColor: dropdownBg,
                    selectedBackgroundColor: selectedBg,
                    textColor: textColor,
                    selectedIcon: Icon(AppIcons.checkbox, color: accentColor),
                    disabledIcon: Icon(Icons.lock, color: hintColor),
                  ),
                ),

                const SizedBox(height: 5),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    controller.removeListener(_onScroll);
    super.dispose();
  }
}
