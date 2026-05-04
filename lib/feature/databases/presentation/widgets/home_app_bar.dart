import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/config/routes/on_generate_routes.dart';
import 'package:pagebridge/config/themes/app_icons.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/config/themes/theme_config.dart';
import 'package:pagebridge/core/constants/constants.dart';
import 'package:pagebridge/core/database/cache/secure_storage.dart';
import 'package:pagebridge/core/helpers/custom_confirm_dialog.dart';
import 'package:pagebridge/core/helpers/day_night_switch.dart';
import 'package:pagebridge/core/services/shared_preferences_singleton.dart';
import 'package:pagebridge/feature/databases/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, this.title = 'Databases', this.showActions = true});
  final String title;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final modernSlate = Theme.of(context).extension<ModernSlateColors>()!;
    final ownerAvatarUrl = SharedPreferencesSingleton.getString('ownerAvatarUrl');

    return SliverAppBar(
      toolbarHeight: 70,
      pinned: true,
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
      backgroundColor: modernSlate.card,
      shadowColor: modernSlate.border,
      surfaceTintColor: modernSlate.card,
      expandedHeight:showActions? 110: 80,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (ownerAvatarUrl != null) ...[
              CircleAvatar(
                radius: 12,
                backgroundImage: NetworkImage(ownerAvatarUrl),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                title,
                style: AppTextStyles.titleLarge?.copyWith(
                  color: modernSlate.primaryText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        expandedTitleScale: 1.2.sp,
        background: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).brightness == Brightness.light
                        ? const Color.fromARGB(255, 226, 236, 246)
                        : modernSlate.searchBarFill,
                    modernSlate.card,
                    Theme.of(context).brightness == Brightness.light
                        ? const Color.fromARGB(255, 226, 236, 246)
                        : modernSlate.searchBarFill,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            if (showActions)
              Positioned(
                top: MediaQuery.paddingOf(context).top + 10,
                right: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                        final bool shouldLogout = await showAppConfirmDialog(
                          context: context,
                          title: 'Confirm',
                          message: 'Are you sure you want to log out?',
                        );
                        if (!context.mounted || !shouldLogout) return;
                        await SecureStorage.deleteData(key: tokenKey);
                        if (!context.mounted) return;
                        AppRoutes.authView(context);
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
