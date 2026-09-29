import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/core/utls/setup_service_locator_getit.dart';
import 'package:pagebridge/feature/auth/domain/repo/auth_repository.dart';
import 'package:pagebridge/config/routes/on_generate_routes.dart';
import 'package:pagebridge/config/themes/app_icons.dart';

import 'package:pagebridge/core/helpers/custom_confirm_dialog.dart';
import 'package:pagebridge/core/helpers/day_night_switch.dart';
import 'package:pagebridge/feature/settings/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';
import 'package:pagebridge/feature/settings/presentation/widgets/settings_group.dart';
import 'package:pagebridge/feature/settings/presentation/widgets/settings_item.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            SettingsGroup(
              title: 'Preferences',
              children: [
                SettingsItem(
                  icon: isLight ? AppIcons.lightMode : AppIcons.darkMode,
                  title: 'Theme',
                  subtitle: 'Switch between light and dark mode',
                  trailing: DayNightSwitch(
                    value: !isLight,
                    scale: 0.8,
                    onChanged: (bool value) {
                      context.read<ThemeModeCubit>().changeThemeMode(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SettingsGroup(
              title: 'Account',
              children: [
                SettingsItem(
                  icon: AppIcons.logout,
                  title: 'Log Out',
                  subtitle: 'Disconnect your Notion account',
                  isDestructive: true,
                  onTap: () async {
                    final bool shouldLogout = await showAppConfirmDialog(
                      context: context,
                      title: 'Confirm Logout',
                      message: 'Are you sure you want to log out?',
                    );
                    if (!context.mounted || !shouldLogout) return;
                    await getit.get<AuthRepository>().logout();
                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.auth,
                      (_) => false,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
