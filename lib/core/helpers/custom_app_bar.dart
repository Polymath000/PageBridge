import 'package:pagebridge/core/theme/app_colors.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import "package:pagebridge/feature/main_layout/presentation/cubit/main_layout_cubit.dart";
import 'package:pagebridge/config/themes/app_text_style.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    this.title = 'Databases',
    this.showActions = true,
  });
  final String title;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final ownerAvatarUrl = context.read<MainLayoutCubit>().ownerAvatarUrl;

    return SliverAppBar(
      toolbarHeight: 60,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.transparent,
      shadowColor: AppColors.transparent,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      expandedHeight: 80,
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
            ),
            child: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 20),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (ownerAvatarUrl != null) ...[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.15),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundImage: NetworkImage(ownerAvatarUrl),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Flexible(
                    child: Text(
                      title,
                      style: AppTextStyles.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                        fontSize: 22.sp,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              expandedTitleScale: 1,
            ),
          ),
        ),
      ),
    );
  }
}
