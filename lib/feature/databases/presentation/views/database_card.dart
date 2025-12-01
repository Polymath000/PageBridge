import 'package:flutter/material.dart';
import 'package:flutter_animate_on_scroll/flutter_animate_on_scroll.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/utls/app_images.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';

class DatabaseCard extends StatelessWidget {
  const DatabaseCard({super.key, required this.database});
  final DatabaseEntity database;
  @override
  Widget build(BuildContext context) {
    return FadeIn(
      config: BaseAnimationConfig(
        child: GestureDetector(
          onTap: () {},
          child: Card(
            elevation: 1.5,
            margin: const EdgeInsets.only(bottom: 16.0),
            color: AppColors.pickledBluewood,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 16,
              ),
              child: Row(
                children: [
                  (database.icon?.emoji?.isEmpty ?? true)
                      ? SizedBox(
                          height: 16,
                          child: Image(
                            image: AssetImage(Assets.assetsImagesDatabaseicon),
                          ),
                        )
                      : Text(database.icon?.emoji ?? ""),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.75,
                    child: Text(
                      database.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleLarge!.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: AppColors.lightGray),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
