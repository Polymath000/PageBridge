import 'package:flutter/material.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/database_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomSkeletonizerDatabase extends StatelessWidget {
  const CustomSkeletonizerDatabase({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Skeletonizer(
        enabled: true,
        child: DatabaseCard(
          database: DatabaseEntity(
            id: 'dummy',
            title: 'Loading...',
            properties: [],
          ),
        ),
      ),
    );
  }
}
