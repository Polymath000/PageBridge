import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quicknotion/config/routes/on_generate_routes.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_icons.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/config/themes/theme_config.dart';
import 'package:quicknotion/core/constants/constants.dart';
import 'package:quicknotion/core/database/cache/secure_storage.dart';
import 'package:quicknotion/core/helpers/day_night_switch.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
        ThemeSwitcher.withTheme(
          clipper: const ThemeSwitcherCircleClipper(),
          builder: (context, switcher, theme) {
            final isLight = theme.brightness == Brightness.light;
            return Row(
              children: [
                DayNightSwitch(
                  value: !isLight,
                  scale: 0.7,
                  onChanged: (bool value) {
                    final nextTheme = value
                        ? const ThemeConfig().dark
                        : const ThemeConfig().light;
                    switcher.changeTheme(
                      theme: nextTheme ?? theme,
                      isReversed: value,
                    );
                    context.read<ThemeModeCubit>().changeThemeMode(context);
                  },
                ),
              ],
            );
          },
        ),
        IconButton(
          tooltip: 'Logout',
          icon: Icon(AppIcons.logout),
          onPressed: () async {
            await SecureStorage.deleteData(key: tokenKey);
            if (!context.mounted) return;
            AppRoutes.authView(context);
          },
        ),
      ],
    );
  }
}
