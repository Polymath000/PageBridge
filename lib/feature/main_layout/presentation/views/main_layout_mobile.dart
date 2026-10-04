import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:pagebridge/config/themes/app_icons.dart';
import 'package:pagebridge/feature/auth/presentation/widgets/custom_animation_background.dart';
import 'package:pagebridge/feature/settings/presentation/views/settings_view.dart';
import 'package:pagebridge/feature/databases/presentation/views/home_view.dart';
import 'package:pagebridge/feature/pages/presentation/views/recent_pages_feed.dart';
import 'package:pagebridge/feature/main_layout/presentation/widgets/bootom_nav_item.dart';
import '../cubit/main_layout_cubit.dart';

class MainLayoutMobile extends StatelessWidget {
  const MainLayoutMobile({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const CustomAnimationBackground(isAnimated: false),
          Positioned.fill(
            child: IndexedStack(
              index: currentIndex,
              children: const [HomeView(), RecentPagesFeed(), SettingsView()],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: Theme.of(context).bottomAppBarTheme.color,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Theme.of(context).bottomAppBarTheme.shadowColor ??
                            AppColors.black.withValues(alpha: 0.26),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BootomNavItem(
                        icon: AppIcons.storageRounded,
                        label: 'Databases',
                        isSelected: currentIndex == 0,
                        onTap: () =>
                            context.read<MainLayoutCubit>().changeTab(0),
                      ),
                      BootomNavItem(
                        icon: AppIcons.historyRounded,
                        label: 'Recent',
                        isSelected: currentIndex == 1,
                        onTap: () =>
                            context.read<MainLayoutCubit>().changeTab(1),
                      ),
                      BootomNavItem(
                        icon: AppIcons.displaySettings,
                        label: 'Settings',
                        isSelected: currentIndex == 2,
                        onTap: () =>
                            context.read<MainLayoutCubit>().changeTab(2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
