import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/core/helpers/custom_back_arrow.dart';

class RelationSearchAppBar extends StatelessWidget {
  final String name;

  const RelationSearchAppBar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      pinned: true,
      toolbarHeight: 70,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: const CustomBackArrow(),
      title: Text(
        name,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
          fontSize: 20.sp,
          letterSpacing: -0.5,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.8),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          border: Border(
            bottom: BorderSide(
              color: colorScheme.outlineVariant.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
