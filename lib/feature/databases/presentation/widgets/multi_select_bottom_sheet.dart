import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:pagebridge/feature/databases/domain/entities/property_entity.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/multi_select_chip.dart';

class MultiSelectBottomSheet extends StatelessWidget {
  final PropertyEntity property;
  final ValueNotifier<List<String>> selectedValuesNotifier;
  final ValueChanged<dynamic>? onSelectionChanged;

  const MultiSelectBottomSheet({
    super.key,
    required this.property,
    required this.selectedValuesNotifier,
    this.onSelectionChanged,
  });

  void _toggleSelection(String optionName) {
    final current = List<String>.from(selectedValuesNotifier.value);
    if (current.contains(optionName)) {
      current.remove(optionName);
    } else {
      current.add(optionName);
    }
    selectedValuesNotifier.value = current;
    onSelectionChanged?.call(current);
  }

  @override
  Widget build(BuildContext context) {
    final options = property.selectOptions ?? [];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.7,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          _buildHeader(),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];

                return ValueListenableBuilder<List<String>>(
                  valueListenable: selectedValuesNotifier,
                  builder: (context, selectedValues, _) {
                    final isSelected = selectedValues.contains(option.name);

                    return InkWell(
                      onTap: () => _toggleSelection(option.name),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 8.0,
                        ),
                        child: Row(
                          children: [
                            MultiSelectChip(option: option),
                            const Spacer(),
                            if (isSelected)
                              Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20.sp,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12, bottom: 12),
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: AppColors.grey400,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Select Options",
          style: AppTextStyles.titleMedium?.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
