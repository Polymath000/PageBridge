import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/core/utls/error_widget.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/add_token_cubit/add_token_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/custom_skeletonizer_database.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/database_card.dart';

class HomeViewBody extends StatefulWidget {
  final ScrollController? controller;
  final String? currentQuery;
  HomeViewBody({super.key, this.controller, this.currentQuery});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final List<DatabaseEntity> databases = [];
  bool isLoading = false;
  String? nextCursor;
  bool hasMore = false;
  bool isPaginating = false;

  @override
  void initState() {
    super.initState();
    _getDatabases();
    widget.controller?.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant HomeViewBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentQuery != widget.currentQuery) {
      _getDatabases();
    }
  }

  void _onScroll() {
    final controller = widget.controller;
    if (controller == null || !controller.hasClients || isLoading || !hasMore) {
      return;
    }
    final maxScroll = controller.position.maxScrollExtent;
    final current = controller.position.pixels;
    if (current >= maxScroll * 0.8) {
      _getDatabases(isPaginating: true);
    }
  }

  Future<void> _getDatabases({bool isPaginating = false}) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
      this.isPaginating = isPaginating;
    });
    final token = await SecureStorage.readData(key: tokenKey);
    context.read<AddTokenCubit>().addToken(
      token: token ?? "",
      query: widget.currentQuery ?? "",
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
    return BlocConsumer<AddTokenCubit, AddTokenState>(
      listener: (context, state) {
        if (state is AddTokenLoading) {
          setState(() {
            isLoading = true;
          });
          return;
        }

        if (state is AddTokenSuccess) {
          setState(() {
            if (!isPaginating) {
              databases.clear();
            }
            databases.addAll(state.databases);
            hasMore = state.hasMore;
            nextCursor = state.nextCursor;
            isLoading = false;
            isPaginating = false;
          });
        }
        if (state is AddTokenSearchSuccess) {
          setState(() {
            if (!isPaginating) {
              databases.clear();
            }
            databases.addAll(state.databases);
            hasMore = state.hasMore;
            nextCursor = state.nextCursor;
            isLoading = false;
            isPaginating = false;
          });
        }
        if (state is AddTokenFailure) {
          setState(() {
            isLoading = false;
            isPaginating = false;
          });
        }
      },
      builder: (context, state) {
        if (state is AddTokenFailure) {
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
              if (index < databases.length) {
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
