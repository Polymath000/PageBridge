import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pagebridge/config/routes/on_generate_routes.dart';
import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/config/themes/app_icons.dart';

import 'package:pagebridge/core/helpers/custom_show_snack_bar.dart';
import 'package:pagebridge/config/themes/app_images.dart';
import 'package:pagebridge/feature/databases/domain/entities/database_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DatabaseCard extends StatelessWidget {
  const DatabaseCard({super.key, required this.database});
  final DatabaseEntity database;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasCover = database.cover?.url != null;
    return SizedBox(
      width: double.infinity,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 250),
        curve: Curves.decelerate,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, -16 * (1 - value)),
              child: child,
            ),
          );
        },
        child: GestureDetector(
          onTap: () async {
            final result = await Navigator.pushNamed(
              context,
              AppRoutes.newPage,
              arguments: database,
            );
            if (result is String && context.mounted) {
              customShowSnackBar(
                message: "The new page has been added successfully",
                context: context,
                backgroundColor: AppColors.green,
                action: SnackBarAction(
                  label: 'Open in Notion',
                  textColor: Colors.white,
                  onPressed: () {
                    launchUrl(
                      Uri.parse(result),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (hasCover)
                        SizedBox(
                          height: 72,
                          child: Image.network(
                            database.cover!.url!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const SizedBox.shrink(),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 18,
                        ),
                        child: Row(
                          children: [
                            (database.icon?.emoji?.isEmpty ?? true)
                                ? SizedBox(
                                    height: 22.h,
                                    width: 22.h,
                                    child: Image(
                                      image: AssetImage(
                                        Assets.assetsImagesDatabaseicon,
                                      ),
                                    ),
                                  )
                                : Text(
                                    database.icon?.emoji ?? "",
                                    style: TextStyle(fontSize: 20.sp),
                                  ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                database.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.titleLarge!.copyWith(
                                  color: colorScheme.onSurface,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              AppIcons.arrowForward,
                              color: colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
