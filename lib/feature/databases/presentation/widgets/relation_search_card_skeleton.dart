import 'package:flutter/material.dart';
import 'package:quicknotion/feature/databases/domain/entities/page_entity.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/list_of_databases_fo_relation_search.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RelationSearchCardSkeleton extends StatelessWidget {
  const RelationSearchCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListOfDatabasesFoRelationSearch(
        isSelected: false,
        page: PageEntity(
          id: 'skeleton-id',
          title: 'Loading relation page title',
          databaseId: 'skeleton-database-id',
        ),
        onChanged: (_) {},
      ),
    );
  }
}
