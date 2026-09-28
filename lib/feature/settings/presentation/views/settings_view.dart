import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/config/routes/on_generate_routes.dart';
import 'package:pagebridge/config/themes/app_icons.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/core/constants/constants.dart';
import 'package:pagebridge/core/database/cache/secure_storage.dart';
import 'package:pagebridge/core/helpers/custom_confirm_dialog.dart';
import 'package:pagebridge/core/helpers/day_night_switch.dart';
import 'package:pagebridge/feature/databases/presentation/controllers/theme_mode_cubit/theme_mode_cubit.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _SettingsGroup(
              title: 'Preferences',
              children: [
                _SettingsItem(
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
            _SettingsGroup(
              title: 'Account',
              children: [
                _SettingsItem(
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
                    await SecureStorage.deleteData(key: AppConstants.tokenKey);
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

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            title.toUpperCase(),
            style: AppTextStyles.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Divider(
                    height: 1,
                    indent: 56,
                    color: Theme.of(context).dividerColor,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.onSurface;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        title,
        style: AppTextStyles.titleMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTextStyles.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      trailing:
          trailing ??
          (onTap != null
              ? Icon(
                  AppIcons.arrowForwardRounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                )
              : null),
    );
  }
}
