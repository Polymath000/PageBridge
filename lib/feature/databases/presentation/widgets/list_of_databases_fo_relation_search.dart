import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/feature/databases/domain/entities/page_entity.dart';
import 'package:quicknotion/feature/databases/presentation/views/relation_search_view.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/database_card_for_relation_search.dart';

class ListOfDatabasesFoRelationSearch extends StatelessWidget {
  const ListOfDatabasesFoRelationSearch({
    super.key,
    required this.isSelected,
    required this.page,
    required this.onChanged,
  });

  final bool isSelected;
  final PageEntity page;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: DatabaseCardForRelationSearch(
        page: page,
        isSelected: isSelected,
        onChanged: onChanged,
      ),
    );
  }
}
