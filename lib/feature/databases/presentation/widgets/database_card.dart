import 'package:flutter/material.dart';
import 'package:flutter_animate_on_scroll/flutter_animate_on_scroll.dart';
import 'package:quicknotion/config/routes/on_generate_routes.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/utls/app_icons.dart';
import 'package:quicknotion/core/utls/app_images.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DatabaseCard extends StatelessWidget {
  const DatabaseCard({super.key, required this.database});
  final DatabaseEntity database;
  @override
  Widget build(BuildContext context) {
    return FadeIn(
      config: BaseAnimationConfig(
        child: GestureDetector(
          onTap: () {
            AppRoutes.newPageView(context, database: database);
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 16.0, right: 0),
            color: AppColors.pickledBluewood,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (database.icon?.emoji?.isEmpty ?? true)
                      ? SizedBox(
                          height: 16.h,
                          child: Image(
                            image: AssetImage(Assets.assetsImagesDatabaseicon),
                          ),
                        )
                      : Text(database.icon?.emoji ?? ""),
                  // const SizedBox(width: 8),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    child: Text(
                      database.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleLarge!.copyWith(
                        color: AppColors.white,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                  Icon(AppIcons.arrowForward, color: AppColors.lightGray),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
