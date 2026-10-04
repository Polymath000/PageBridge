import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/config/themes/app_icons.dart';
import 'package:pagebridge/feature/auth/presentation/widgets/custom_animation_background.dart';
import 'package:pagebridge/feature/settings/presentation/views/settings_view.dart';
import 'package:pagebridge/feature/databases/presentation/views/home_view.dart';
import 'package:pagebridge/feature/pages/presentation/views/recent_pages_feed.dart';
import '../cubit/main_layout_cubit.dart';

class MainLayoutTablet extends StatelessWidget {
  const MainLayoutTablet({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            const CustomAnimationBackground(isAnimated: false),
            Row(
              children: [
                NavigationRail(
                  backgroundColor: Theme.of(
                    context,
                  ).scaffoldBackgroundColor.withValues(alpha: 0.8),
                  selectedIndex: currentIndex,
                  onDestinationSelected: (index) {
                    context.read<MainLayoutCubit>().changeTab(index);
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(AppIcons.storageRounded),
                      label: Text('Databases'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(AppIcons.historyRounded),
                      label: Text('Recent'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(AppIcons.displaySettings),
                      label: Text('Settings'),
                    ),
                  ],
                ),
                VerticalDivider(
                  thickness: 1,
                  width: 1,
                  color: Theme.of(context).dividerColor,
                ),
                Expanded(
                  child: IndexedStack(
                    index: currentIndex,
                    children: const [
                      HomeView(),
                      RecentPagesFeed(),
                      SettingsView(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
