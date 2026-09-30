import 'package:flutter/material.dart';
import 'package:pagebridge/feature/pages/domain/entities/page_entity.dart';
import 'package:pagebridge/feature/add_new_page/presentation/widgets/database_list_item_for_relation_search.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RelationSearchCardSkeleton extends StatelessWidget {
  const RelationSearchCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: DatabaseListItemForRelationSearch(
        isSelected: false,
        page: const PageEntity(
          id: 'skeleton-id',
          title: 'Loading relation page title',
          databaseId: 'skeleton-database-id',
          url: '',
        ),
        onChanged: (_) {},
      ),
    );
  }
}
