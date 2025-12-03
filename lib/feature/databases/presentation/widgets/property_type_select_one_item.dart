import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/utls/get_color.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/property_type.dart';

class PropertyTypeSelectOneItem extends StatelessWidget {
  const PropertyTypeSelectOneItem({
    super.key,
    required this.widget,
  });

  final PropertyType widget;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
        isExpanded: true,
        enableFeedback: true,
        padding: EdgeInsets.zero,
        iconSize: 0,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Empty",
          hintStyle: AppTextStyles.titleMedium!.copyWith(
            color: AppColors.grey,
          ),
        ),
        value:
            widget.property.type == "status" &&
                widget.property.selectOptions != null &&
                widget.property.selectOptions!.isNotEmpty
            ? widget.property.selectOptions!.first.name
            : null,
        onChanged: widget.onChanged,
        items: (widget.property.selectOptions ?? [])
            .map(
              (e) => DropdownMenuItem(
                value: e.name,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: getColor(e.color),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(e.name),
                ),
              ),
            )
            .toList(),
      );
  }
}
