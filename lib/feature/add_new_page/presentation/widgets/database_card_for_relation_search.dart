import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/feature/pages/domain/entities/page_entity.dart';

class DatabaseCardForRelationSearch extends StatelessWidget {
  const DatabaseCardForRelationSearch({
    super.key,
    required this.page,
    required this.isSelected,
    required this.onChanged,
  });

  final PageEntity page;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        page.title,
        style: AppTextStyles.titleMedium!.copyWith(
          fontSize: 15.sp,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
      value: isSelected,
      activeColor: Theme.of(context).colorScheme.primary,
      checkColor: Colors.white,
      controlAffinity: ListTileControlAffinity.trailing,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      onChanged: onChanged,
    );
  }
}
