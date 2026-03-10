import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/core/utls/error_widget.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/return_databases_cubit/return_databases_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/custom_skeletonizer_database.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/database_card.dart';

class DatabasesList extends StatefulWidget {
  final Map<String, dynamic> dataFromToken;
  final ScrollController? controller;
  const DatabasesList({
    super.key,
    this.controller,
    required this.dataFromToken,
  });

  @override
  State<DatabasesList> createState() => _DatabasesListState();
}

class _DatabasesListState extends State<DatabasesList> {
  List<DatabaseEntity> databases = [];
  bool isLoading = false;
  String? nextCursor;
  bool hasMore = false;
  bool isPaginating = false;
  String currentQuery = '';

  @override
  void initState() {
    super.initState();
    if (widget.dataFromToken.isEmpty) {
      _getDatabases();
    } else {
      databases.addAll(widget.dataFromToken["databases"]);
      hasMore = widget.dataFromToken["hasMore"];
      nextCursor = widget.dataFromToken["nextCursor"];
      isLoading = false;
      isPaginating = false;
    }
    widget.controller?.addListener(_onScroll);
  }

  void _onScroll() {
    final controller = widget.controller;
    if (controller == null || !controller.hasClients || isLoading || !hasMore) {
      return;
    }
    final maxScroll = controller.position.maxScrollExtent;
    final current = controller.position.pixels;
    if (current >= maxScroll * 0.75) {
      _getDatabases(isPaginating: true);
    }
  }

  Future<void> _getDatabases({bool isPaginating = false}) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
      this.isPaginating = isPaginating;
    });
    context.read<DatabasesCubit>().returnDatabases(
      query: currentQuery,
      startCursor: isPaginating ? nextCursor : null,
    );
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DatabasesCubit, DatabasesState>(
      listener: (context, state) {
        if (state is DatabasesLoading) {
          setState(() {
            isLoading = true;
            if (state.query != currentQuery) {
              currentQuery = state.query;
              databases.clear();
              nextCursor = null;
              hasMore = false;
              isPaginating = false;
            }
          });
          return;
        }

        if (state is DatabasesSuccess || state is DatabasesSearchSuccess) {
          final List<DatabaseEntity> newDatabasesFromState;
          final bool newHasMore;
          final String? newNextCursor;
          final String newQuery;

          if (state is DatabasesSuccess) {
            newDatabasesFromState = state.databases;
            newHasMore = state.hasMore;
            newNextCursor = state.nextCursor;
            newQuery = state.query;
          } else {
            final searchState = state as DatabasesSearchSuccess;
            newDatabasesFromState = searchState.databases;
            newHasMore = searchState.hasMore;
            newNextCursor = searchState.nextCursor;
            newQuery = searchState.query;
          }

          if (newQuery != currentQuery) {
            return;
          }

          setState(() {
            if (!isPaginating) {
              databases.clear();
            }
            databases.addAll(newDatabasesFromState);
            hasMore = newHasMore;
            nextCursor = newNextCursor;
            isLoading = false;
            isPaginating = false;
          });
        }
        if (state is DatabasesFailure) {
          if (state.query != currentQuery) {
            return;
          }

          setState(() {
            isLoading = false;
            isPaginating = false;
          });
        }
      },
      builder: (context, state) {
        if (state is DatabasesFailure && state.query == currentQuery) {
          return SliverToBoxAdapter(
            child: CustomErrorWidget(errorMessage: state.message),
          );
        }

        if (databases.isEmpty && isLoading) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                children: List.generate(
                  (MediaQuery.sizeOf(context).height * 0.009).toInt(),
                  (index) => CustomSkeletonizerDatabase(),
                ),
              ),
            ),
          );
        }

        final total = databases.length + (isLoading ? 5 : 0);

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (databases.isEmpty) {
                return Center(
                  child: CustomErrorWidget(
                    errorMessage: "There are no databases found.",
                  ),
                );
              } else if (index < databases.length) {
                return DatabaseCard(database: databases[index]);
              }
              return const CustomSkeletonizerDatabase();
            }, childCount: total),
          ),
        );
      },
    );
  }
}
