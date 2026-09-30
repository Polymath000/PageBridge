import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pagebridge/config/routes/on_generate_routes.dart';
import 'package:pagebridge/core/theme/app_colors.dart';
import 'package:pagebridge/config/themes/app_text_style.dart';
import 'package:pagebridge/feature/pages/domain/entities/page_entity.dart';
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
  late final ValueNotifier<List<PageEntity>> _selectedPagesNotifier;

  @override
  void initState() {
    super.initState();
    _selectedPagesNotifier = ValueNotifier<List<PageEntity>>([]);
  }

  @override
  void dispose() {
    _selectedPagesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          AppRoutes.relationSearch,
          arguments: {
            'property': widget.property,
            'initialSelectedPages': _selectedPagesNotifier.value,
            'onSelectionConfirmed': (List<PageEntity> selectedPages) {
              _selectedPagesNotifier.value = selectedPages;
              widget.onChanged?.call(selectedPages.map((e) => e.id).toList());
            },
          },
        );
      },
      child: Container(
        color: AppColors.transparent,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: ValueListenableBuilder<List<PageEntity>>(
          valueListenable: _selectedPagesNotifier,
          builder: (context, selectedPages, child) {
            return selectedPages.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      "Select pages",
                      style: AppTextStyles.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14.sp,
                      ),
                    ),
                  )
                : Wrap(
                    spacing: 6.0,
                    runSpacing: 4.0,
                    children: selectedPages
                        .map(
                          (page) => Chip(
                            label: Text(
                              page.title,
                              style: AppTextStyles.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            deleteIconColor: Theme.of(context).colorScheme.onPrimary,
                            onDeleted: () {
                              final current = List<PageEntity>.from(_selectedPagesNotifier.value);
                              current.removeWhere((p) => p.id == page.id);
                              _selectedPagesNotifier.value = current;
                              widget.onChanged?.call(current.map((e) => e.id).toList());
                            },
                          ),
                        )
                        .toList(),
                  );
          },
        ),
      ),
    );
  }
}
