import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/core/utls/error_widget.dart';
import 'package:quicknotion/feature/databases/data/data_source/database_remote_data_source.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/add_token_cubit/add_token_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/custom_skeletonizer_database.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/database_card.dart';

class HomeViewBody extends StatefulWidget {
  final ScrollController? controller;
  HomeViewBody({super.key, this.controller, required this.searchIsEmpty});
  bool searchIsEmpty;

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final List<DatabaseEntity> databases = [];
  bool isLoading = false;
  bool isSearchWorked = false;
  @override
  void initState() {
    super.initState();
    _getDatabases();
    widget.controller?.addListener(_onScroll);
  }

  void _onScroll() {
    final controller = widget.controller;
    if (controller == null ||
        !controller.hasClients ||
        isLoading ||
        !hasMoreFetchDatabases)
      return;
    final maxScroll = controller.position.maxScrollExtent;
    final current = controller.position.pixels;
    if (current >= maxScroll * 0.8) {
      _getDatabases();
    }
  }

  Future<void> _getDatabases() async {
    if (isLoading) return;
    setState(() => isLoading = true);
    final token = await SecureStorage.readData(key: tokenKey);
    context.read<AddTokenCubit>().addToken(token: token ?? "");
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
            if (isSearchWorked) {
              databases.clear();
              setState(() {
                isSearchWorked = true;
              });
            }

            databases.addAll(state.databases);
            isLoading = false;
          });
        }
        if (state is AddTokenSearchSuccess) {
          setState(() {
            setState(() {
              isSearchWorked = true;
            });
            databases.clear();
            databases.addAll(state.databases);
            isLoading = false;
          });
        }
        if (state is AddTokenFailure) {
          setState(() => isLoading = false);
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
