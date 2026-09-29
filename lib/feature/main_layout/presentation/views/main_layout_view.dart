import 'package:flutter/material.dart';
import 'package:pagebridge/config/themes/app_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/feature/auth/presentation/widgets/custom_animation_background.dart';
import "package:pagebridge/feature/settings/presentation/views/settings_view.dart";
import 'package:pagebridge/feature/databases/presentation/views/home_view.dart';
import 'package:pagebridge/feature/pages/presentation/views/recent_pages_feed.dart';
import 'package:pagebridge/feature/main_layout/presentation/widgets/bootom_nav_item.dart';
import '../cubit/main_layout_cubit.dart';

class MainLayoutView extends StatelessWidget {
  const MainLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainLayoutCubit, int>(
      builder: (context, currentIndex) {
        return PopScope(
          canPop: currentIndex == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            context.read<MainLayoutCubit>().changeTab(0);
          },
          child: SafeArea(
          child: Scaffold(
            extendBody: true,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                const CustomAnimationBackground(),

                Positioned.fill(
                  child: IndexedStack(
                    index: currentIndex,
                    children: [
                      const HomeView(),
                      const RecentPagesFeed(),
                      const SettingsView(),
                    ],
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
        ),
        );
      },
    );
  }

}
