import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/utls/custom_check_box.dart';
import 'package:quicknotion/core/utls/get_color.dart';
import 'package:quicknotion/feature/databases/domain/entities/property_entity.dart';

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

  @override
  Widget build(BuildContext context) {
    List<String> selectedMultiSelectValues = _selectedMultiSelectValues;

    return GestureDetector(
      onTap: () async {
        final List<String>? results = await showDialog(
          context: context,
          builder: (BuildContext context) {
            List<String> tempSelected = List.from(selectedMultiSelectValues);
            return Builder(
              builder: (context) {
                return AlertDialog(
                  title: Text("Select Options"),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: widget.property.selectOptions!.map((option) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              CustomCheckBox(
                                value: tempSelected.contains(option.name),
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      tempSelected.add(option.name);
                                    } else {
                                      tempSelected.remove(option.name);
                                    }
                                  });
                                },
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: getColor(option.color),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  option.name,
                                  style: AppTextStyles.titleMedium!.copyWith(
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, tempSelected);
                      },
                      child: Text("Done"),
                    ),
                  ],
                );
              },
            );
          },
        );
        if (results != null) {
          setState(() {
            _selectedMultiSelectValues = results;
          });
          widget.onChanged?.call(results);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Empty",
          hintStyle: AppTextStyles.titleMedium!.copyWith(color: AppColors.grey),
        ),
        child: SingleChildScrollView(
          child: Row(
            children: selectedMultiSelectValues.isEmpty
                ? [
                    Text(
                      "Empty",
                      style: AppTextStyles.titleMedium!.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ]
                : List.generate(selectedMultiSelectValues.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              (widget.property.selectOptions != null &&
                                  index < widget.property.selectOptions!.length)
                              ? getColor(
                                  widget.property.selectOptions![index].color,
                                )
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          selectedMultiSelectValues[index],
                          style: AppTextStyles.titleMedium!.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    );
                  }),
          ),
        ),
      ),
    );
  }
}
