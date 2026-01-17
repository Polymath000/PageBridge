import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/config/themes/app_icons.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/core/utls/setup_service_locator_getit.dart';
import 'package:quicknotion/feature/databases/data/repos/database_repo_impl.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/add_token_cubit/add_token_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/home_app_bar.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const String routeName = 'home';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();
  bool searchIsEmpty = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            AddTokenCubit(databaseRepo: getit.get<DatabaseRepoImpl>()),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                HomeAppBar(),
                SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? AppColors.black.withOpacity(0.1)
                                : AppColors.white.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              AppIcons.search,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.light
                                  ? AppColors.grey
                                  : AppColors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Builder(
                            builder: (context) {
                              return Expanded(
                                child: TextField(
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Search databases',
                                    hintStyle: AppTextStyles.titleMedium
                                        ?.copyWith(color: AppColors.grey),
                                  ),
                                  onChanged: (value) async {
                                    final token= await SecureStorage.readData(
                                      key: tokenKey,
                                    );
                                    context.read<AddTokenCubit>().addToken(
                                      token: token ?? "",
                                      query: value,
                                    );
                                    setState(() {
                                      if (value.isEmpty) {
                                        searchIsEmpty = false;
                                      } else {
                                        searchIsEmpty = true;
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 4)),

                HomeViewBody(
                  controller: _scrollController,
                  searchIsEmpty: searchIsEmpty,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
