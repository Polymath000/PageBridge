import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:pagebridge/feature/databases/domain/entities/property_entity.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/multi_select_bottom_sheet.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/multi_select_chip.dart';

class PropertyTypeMultiSelect extends StatefulWidget {
  const PropertyTypeMultiSelect({
    super.key,
    required this.property,
    this.onChanged,
  });

  final PropertyEntity property;
  final ValueChanged<dynamic>? onChanged;

  @override
  State<PropertyTypeMultiSelect> createState() =>
      _PropertyTypeMultiSelectState();
}

class _PropertyTypeMultiSelectState extends State<PropertyTypeMultiSelect> {
  late final ValueNotifier<List<String>> _selectedValuesNotifier;

  @override
  void initState() {
    super.initState();
    _selectedValuesNotifier = ValueNotifier<List<String>>([]);
  }

  @override
  void dispose() {
    _selectedValuesNotifier.dispose();
    super.dispose();
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (BuildContext context) {
        return MultiSelectBottomSheet(
          property: widget.property,
          selectedValuesNotifier: _selectedValuesNotifier,
          onSelectionChanged: widget.onChanged,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: ValueListenableBuilder<List<String>>(
        valueListenable: _selectedValuesNotifier,
        builder: (context, selectedValues, _) {
          return InputDecorator(
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            child: selectedValues.isEmpty
                ? Text(
                    "Empty",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 16.sp,
                    ),
                  )
                : Wrap(
                    spacing: 6.0,
                    runSpacing: 6.0,
                    children: selectedValues.map((selectedValue) {
                      final options = widget.property.selectOptions ?? [];
                      final matchedOption =
                          options
                              .where((opt) => opt.name == selectedValue)
                              .firstOrNull ??
                          (options.isNotEmpty ? options.first : null);

                      return MultiSelectChip(
                        option:
                            matchedOption ??
                            SelectOptionEntity(
                              name: selectedValue,
                              color: 'default',
                            ),
                      );
                    }).toList(),
                  ),
          );
        },
      ),
    );
  }
}
