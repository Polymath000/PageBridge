import 'package:flutter/material.dart';
import 'package:pagebridge/feature/pages/domain/entities/page_entity.dart';
import 'package:pagebridge/feature/pages/presentation/widgets/recent_page_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomSkeletonizerRecentPage extends StatelessWidget {
  const CustomSkeletonizerRecentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Skeletonizer(
        enabled: true,
        child: RecentPageCard(
          page: PageEntity(
            id: 'dummy',
            title: 'Loading Recent Page Title...',
            url: '',
            iconEmoji: '📄',
            databaseId: '',
          ),
        ),
      ),
    );
  }
}
