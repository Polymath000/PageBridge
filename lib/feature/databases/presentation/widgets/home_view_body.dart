import 'package:flutter/material.dart';
import 'package:quicknotion/core/helpers/custom_search_text_field.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/databases_list.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({
    super.key,
    required this.data,
    required this.scrollController,
  });
  final Map<String, dynamic> data;
  final ScrollController scrollController;
  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  Future<void> _onSearchChanged() async {
    _searchController.addListener(() {
      _searchQueryNotifier.value = _searchController.text;
    });
  }

  final ValueNotifier<String> _searchQueryNotifier = ValueNotifier<String>("");

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: CustomSearchTextField(
              getPages: _onSearchChanged,
              hintText: "Search Databases",
              searchController: _searchController,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 6)),
          ValueListenableBuilder<String>(
            valueListenable: _searchQueryNotifier,
            builder: (context, value, _) {
              return DatabasesList(
                dataFromToken: widget.data,
                controller: widget.scrollController,
                currentQuery: value,
              );
            },
          ),
        ],
      ),
    );
  }
}
