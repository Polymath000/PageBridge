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
    final propertyCount = database.properties.length;
    final subtitle =
        '$propertyCount ${propertyCount == 1 ? 'property' : 'properties'}';

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, -10 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Material(
              color: colorScheme.surface.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                splashColor: colorScheme.primary.withValues(alpha: 0.08),
                highlightColor: colorScheme.primary.withValues(alpha: 0.04),
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 8.0,
                  ),
                  child: Row(
                    children: [
                      // Emoji / Icon container
                      Container(
                        width: 48.h,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(
                            alpha: 0.35,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: (database.icon?.emoji?.isEmpty ?? true)
                            ? SizedBox(
                                height: 24.h,
                                width: 24.h,
                                child: Image(
                                  image: AssetImage(
                                    Assets.assetsImagesDatabaseicon,
                                  ),
                                ),
                              )
                            : Text(
                                database.icon?.emoji ?? "",
                                style: TextStyle(fontSize: 24.sp),
                              ),
                      ),
                      const SizedBox(width: 14),

                      // Title + Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              database.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.titleLarge!.copyWith(
                                color: colorScheme.onSurface,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.55,
                                ),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Chevron
                      Icon(
                        AppIcons.arrowForward,
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.35,
                        ),
                        size: 18,
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
