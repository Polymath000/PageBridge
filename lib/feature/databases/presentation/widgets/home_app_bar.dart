import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_icons.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/return_databases_cubit/return_databases_cubit.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key, required this.query});
  final String query;
  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  bool _isReloading = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<DatabasesCubit, DatabasesState>(
      listener: (context, state) {
        if (state is DatabasesLoading) {
          setState(() {
            _isReloading = true;
          });
          return;
        }

        if (state is DatabasesSuccess ||
            state is DatabasesFailure ||
            state is DatabasesSearchSuccess) {
          setState(() {
            _isReloading = false;
          });
        }
      },
      child: SliverAppBar(
        toolbarHeight: 70,
        pinned: true,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        clipBehavior: Clip.antiAlias,
        backgroundColor: AppColors.darkGrey,
        shadowColor: AppColors.darkGrey,
        surfaceTintColor: AppColors.darkGrey,
        expandedHeight: 90,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
          title: Text(
            'Databases',
            style: AppTextStyles.titleLarge?.copyWith(color: AppColors.white),
          ),
          expandedTitleScale: 1.2.sp,
          background: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).brightness == Brightness.light
                      ? AppColors.darkerEdge
                      : AppColors.grey,
                  AppColors.darkGrey,
                  Theme.of(context).brightness == Brightness.light
                      ? AppColors.grey
                      : AppColors.darkerEdge,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        actions: [
          if (_isReloading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: AppColors.white),
            )
          else
            IconButton(
              tooltip: 'Reload',
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                final token = await SecureStorage.readData(key: tokenKey);
                context.read<DatabasesCubit>().returnDatabases(
                  token: token ?? "",
                  query: widget.query,
                );
              },
            ),
          IconButton(
            tooltip: 'Theme',
            icon: Theme.of(context).brightness == Brightness.light
                ? Icon(AppIcons.darkMode)
                : Icon(AppIcons.lightMode),
            onPressed: () =>
                context.read<ThemeModeCubit>().changeThemeMode(context),
          ),
        ],
      ),
    );
  }
}
