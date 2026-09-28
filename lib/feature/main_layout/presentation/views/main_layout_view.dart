import 'package:flutter/material.dart';
import 'package:pagebridge/config/themes/app_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/feature/auth/presentation/widgets/custom_animation_background.dart';
import "package:pagebridge/feature/settings/presentation/views/settings_view.dart";
import 'package:pagebridge/feature/databases/presentation/views/home_view.dart';
import 'package:pagebridge/feature/databases/presentation/views/recent_pages_feed.dart';
import 'package:pagebridge/feature/main_layout/presentation/widgets/bootom_nav_item.dart';
import '../cubit/main_layout_cubit.dart';

class MainLayoutView extends StatelessWidget {
  const MainLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainLayoutCubit, int>(
      builder: (context, currentIndex) {
        return SafeArea(
          child: Scaffold(
            extendBody: true,
            body: Stack(
              children: [
                const CustomAnimationBackground(),

                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.05),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _buildPage(currentIndex),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 8,
                      ),
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
                                  Theme.of(
                                    context,
                                  ).bottomAppBarTheme.shadowColor ??
                                  Colors.black26,
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
          ),
        );
      },
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomeView(key: ValueKey(0));
      case 1:
        return RecentPagesFeed(
          key: const ValueKey(1),
          scrollController: ScrollController(),
        );
      case 2:
        return const SettingsView(key: ValueKey(2));
      default:
        return const HomeView(key: ValueKey(0));
    }
  }
}
