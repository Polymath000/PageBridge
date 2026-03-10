import 'package:flutter/material.dart';
import 'package:quicknotion/config/routes/on_generate_routes.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/config/themes/app_icons.dart';
import 'package:quicknotion/core/helpers/custom_show_snack_bar.dart';
import 'package:quicknotion/core/utls/app_images.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DatabaseCard extends StatelessWidget {
  const DatabaseCard({super.key, required this.database});
  final DatabaseEntity database;
  @override
  Widget build(BuildContext context) {
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
            final result = await AppRoutes.newPageView(
              context,
              database: database,
            );
            if (result == true && context.mounted) {
              customShowSnackBar(
                message: "The new page has been added successfully",
                context: context,
                backgroundColor: AppColors.green,
              );
            }
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
                            image: AssetImage(
                              Assets.assetsImagesDatabaseicon,
                            ),
                          ),
                        )
                      : Text(database.icon?.emoji ?? ""),
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
