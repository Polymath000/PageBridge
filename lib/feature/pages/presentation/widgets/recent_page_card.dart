import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:pagebridge/config/themes/app_icons.dart';
import 'package:pagebridge/feature/pages/domain/entities/page_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class RecentPageCard extends StatelessWidget {
  const RecentPageCard({super.key, required this.page});

  final PageEntity page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.grey.withValues(alpha: 0.2)),
        ),
        child: ListTile(
          leading: page.iconEmoji != null
              ? Text(page.iconEmoji!, style: const TextStyle(fontSize: 24))
              : page.iconUrl != null
              ? Image.network(
                  page.iconUrl!,
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(AppIcons.description),
                )
              : Icon(AppIcons.description),
          title: Text(
            page.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15),
          ),
          trailing: Icon(AppIcons.openInNew, size: 20, color: AppColors.grey),
          onTap: () {
            if (page.url.isNotEmpty) {
              launchUrl(
                Uri.parse(page.url),
                mode: LaunchMode.externalApplication,
              );
            }
          },
        ),
      ),
    );
  }
}
