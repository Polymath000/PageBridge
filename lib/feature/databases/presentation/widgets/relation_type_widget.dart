import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/feature/databases/domain/entities/property_entity.dart';

class RelationTypeWidget extends StatefulWidget {
  const RelationTypeWidget({super.key, required this.property});
  final PropertyEntity property;

  @override
  State<RelationTypeWidget> createState() => _RelationTypeWidgetState();
}

class _RelationTypeWidgetState extends State<RelationTypeWidget> {
  final controller = MultiSelectController<String>();
  var items = [
    DropdownItem(label: "test 1", value: "test1"),
    DropdownItem(label: "test 1", value: "test2"),
    DropdownItem(label: "test 1", value: "test3"),
    DropdownItem(label: "test 1", value: "test4"),
    DropdownItem(label: "test 1", value: "test5"),
    DropdownItem(label: "test 1", value: "test6"),
  ];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 5),
            MultiDropdown<String>(
              items: items,
              controller: controller,
              enabled: true,
              searchEnabled: true,
              chipDecoration: const ChipDecoration(
                backgroundColor: AppColors.amber,
                wrap: true,
                runSpacing: 2,
                spacing: 100,
              ),
              fieldDecoration: FieldDecoration(
                hintText: widget.property.name,
                hintStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.darkGrey
                      : AppColors.white,
                  fontSize: 14.sp,
                ),
                showClearIcon: false,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.grey),
                ),
              ),
              dropdownItemDecoration: DropdownItemDecoration(
                selectedIcon: const Icon(
                  Icons.check_box,
                  color: AppColors.green,
                ),
                disabledIcon: Icon(Icons.lock, color: AppColors.darkGrey),
              ),
              // onSelectionChange: (selectedItems) {
              //   debugPrint("OnSelectionChange: $selectedItems");
              // },
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
