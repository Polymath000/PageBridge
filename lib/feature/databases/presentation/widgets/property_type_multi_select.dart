import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/core/utls/get_color.dart';
import 'package:pagebridge/feature/databases/domain/entities/property_entity.dart';

class PropertyTypeMultiSelect extends StatefulWidget {
  const PropertyTypeMultiSelect({
    super.key,
    required this.property,
    required this.onChanged,
  });
  final PropertyEntity property;
  final ValueChanged<dynamic>? onChanged;
  @override
  State<PropertyTypeMultiSelect> createState() =>
      _PropertyTypeMultiSelectState();
}

class _PropertyTypeMultiSelectState extends State<PropertyTypeMultiSelect> {
  List<String> _selectedMultiSelectValues = [];

  @override
  void initState() {
    super.initState();
    _selectedMultiSelectValues = [];
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent, // We wrap content in a rounded container
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.7,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle for dragging
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 12),
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select Options",
                        style: AppTextStyles.titleMedium!.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      itemCount: widget.property.selectOptions?.length ?? 0,
                      itemBuilder: (context, index) {
                        final option = widget.property.selectOptions![index];
                        final isSelected = _selectedMultiSelectValues.contains(
                          option.name,
                        );

                        return InkWell(
                          onTap: () {
                            setModalState(() {
                              if (isSelected) {
                                _selectedMultiSelectValues.remove(option.name);
                              } else {
                                _selectedMultiSelectValues.add(option.name);
                              }
                            });
                            setState(
                              () {},
                            ); // Update the main widget UI immediately
                            widget.onChanged?.call(_selectedMultiSelectValues);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 8.0,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getColor(option.color),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    option.name,
                                    style: AppTextStyles.titleMedium!.copyWith(
                                      color: AppColors.black,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                if (isSelected)
                                  Icon(
                                    Icons.check,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    size: 20.sp,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: InputDecorator(
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          hintText: "Empty",
          hintStyle: AppTextStyles.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        child: _selectedMultiSelectValues.isEmpty
            ? Text(
                "Empty",
                style: AppTextStyles.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 16.sp,
                ),
              )
            : Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: _selectedMultiSelectValues.map((selectedValue) {
                  // Find the original option to get the correct color
                  SelectOptionEntity? matchedOption;
                  final options = widget.property.selectOptions ?? [];
                  for (var opt in options) {
                    if (opt.name == selectedValue) {
                      matchedOption = opt;
                      break;
                    }
                  }
                  if (matchedOption == null && options.isNotEmpty) {
                    matchedOption = options.first;
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: matchedOption != null
                          ? getColor(matchedOption.color)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      selectedValue,
                      style: AppTextStyles.titleMedium!.copyWith(
                        color: AppColors.black,
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }
}
