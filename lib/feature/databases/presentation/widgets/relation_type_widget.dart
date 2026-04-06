import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/config/routes/on_generate_routes.dart';
import 'package:pagebridge/config/themes/app_colors.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/feature/databases/domain/entities/page_entity.dart';
import 'package:pagebridge/feature/databases/domain/entities/property_entity.dart';

class RelationTypeWidget extends StatefulWidget {
  const RelationTypeWidget({
    super.key,
    required this.property,
    required this.onChanged,
  });
  final PropertyEntity property;
  final ValueChanged<dynamic>? onChanged;

  @override
  State<RelationTypeWidget> createState() => _RelationTypeWidgetState();
}

class _RelationTypeWidgetState extends State<RelationTypeWidget> {
  List<PageEntity> _selectedPages = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await AppRoutes.relationSearchView(
          context,
          property: widget.property,
          initialSelectedPages: _selectedPages,
          onSelectionConfirmed: (selectedPages) {
            setState(() {
              _selectedPages = selectedPages;
            });
            widget.onChanged?.call(_selectedPages.map((e) => e.id).toList());
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF2A2A2A)
              : Colors.white,
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF3A3A3A)
                : const Color(0xFFDDDDDD),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _selectedPages.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  "Select items",
                  style: AppTextStyles.titleMedium!.copyWith(
                    color: AppColors.grey,
                    fontSize: 14.sp,
                  ),
                ),
              )
            : Wrap(
                spacing: 6.0,
                runSpacing: 4.0,
                children: _selectedPages
                    .map(
                      (page) => Chip(
                        label: Text(
                          page.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: AppColors.primary,
                        onDeleted: () {
                          setState(() {
                            _selectedPages.removeWhere((p) => p.id == page.id);
                            widget.onChanged?.call(
                              _selectedPages.map((e) => e.id).toList(),
                            );
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
