import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/core/services/shared_preferences_singleton.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    this.title = 'Databases',
    this.showActions = true,
  });
  final String title;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ownerAvatarUrl = SharedPreferencesSingleton.getString(
      'ownerAvatarUrl',
    );

    return SliverAppBar(
      toolbarHeight: 70,
      pinned: true,
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      clipBehavior: Clip.antiAlias,
      backgroundColor: theme.colorScheme.surface,
      shadowColor: theme.colorScheme.outline,
      surfaceTintColor: theme.colorScheme.surface,
      expandedHeight: showActions ? 110 : 80,
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
                  color: theme.colorScheme.onSurface,
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
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.surface,
                    theme.colorScheme.primaryContainer,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}
