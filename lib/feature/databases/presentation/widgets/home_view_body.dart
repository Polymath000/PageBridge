import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/core/utls/error_widget.dart';
import 'package:quicknotion/feature/databases/data/data_source/database_remote_data_source.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/add_token_cubit/add_token_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/database_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  final ScrollController _scrollController = ScrollController();

  final List<DatabaseEntity> databases = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getDatabases();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients || isLoading || !hasMoreFetchDatabases)
      return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;

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
  Widget build(BuildContext context) {
    return BlocConsumer<AddTokenCubit, AddTokenState>(
      listener: (context, state) {
        if (state is AddTokenSuccess) {
          setState(() {
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
          return CustomErrorWidget(errorMessage: state.message);
        }

        if (databases.isEmpty && isLoading) {
          return SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: ListView.builder(
              itemCount: (MediaQuery.sizeOf(context).height * 0.011).toInt(),
              itemBuilder: (_, __) => SizedBox(
                width: double.infinity,
                child: Skeletonizer(
                  enabled: true,
                  child: DatabaseCard(
                    database: DatabaseEntity(
                      id: 'dummy',
                      title: 'Loading...',
                      properties: [],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: databases.length + (isLoading ? 5 : 0),
            itemBuilder: (context, index) {
              if (index < databases.length) {
                return DatabaseCard(database: databases[index]);
              }
              return SizedBox(
                width: double.infinity,
                child: Skeletonizer(
                  enabled: true,
                  child: DatabaseCard(
                    database: DatabaseEntity(
                      id: 'dummy',
                      title: 'Loading...',
                      properties: [],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
