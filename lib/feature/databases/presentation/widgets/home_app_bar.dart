import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_icons.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 100,
      pinned: false,
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      clipBehavior: Clip.antiAlias,

      backgroundColor: AppColors.darkGrey,
      expandedHeight: 110,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: Text(
          'Databases',
          style: AppTextStyles.titleLarge?.copyWith(
            color: AppColors.white,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
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
        IconButton(
          tooltip: 'Toggle theme',
          icon: Theme.of(context).brightness == Brightness.light
              ? Icon(AppIcons.darkMode)
              : Icon(AppIcons.lightMode),
          onPressed: () =>
              context.read<ThemeModeCubit>().changeThemeMode(context),
        ),
      ],
    );
  }
}
