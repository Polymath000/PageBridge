import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/helpers/custom_show_snack_bar.dart';
import 'package:quicknotion/core/utls/custom_check_box.dart';
import 'package:quicknotion/core/utls/get_color.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';

class PropertyType extends StatefulWidget {
  const PropertyType({super.key, required this.property, this.onChanged});
  final PropertyEntity property;
  final ValueChanged<dynamic>? onChanged;

  @override
  State<PropertyType> createState() => _PropertyTypeState();
}

class _PropertyTypeState extends State<PropertyType> {
  File? selectedFile;

  @override
  Widget build(BuildContext context) {
    List<String> selectedMultiSelectValues = widget.property.selectOptions!
        .map((e) => e.name)
        .toList();

    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.5,
      child:
          widget.property.type == 'text' ||
              widget.property.type == 'number' ||
              widget.property.type == 'url' ||
              widget.property.type == 'rich_text' ||
              widget.property.type == 'phone_number' ||
              widget.property.type == 'email' ||
              widget.property.type == 'created_time' ||
              widget.property.type == 'title' ||
              widget.property.type == "files"
          ? GestureDetector(
              onTap: () async {
                if (widget.property.type == 'files') {
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(allowMultiple: false, type: FileType.any);
                  if (result != null) {
                    File file = File(result.files.single.path!);
                    int sizeInBytes = file.lengthSync();
                    double sizeInMb = sizeInBytes / (1024 * 1024);
                    if (sizeInMb > 5) {
                      customShowSnackBar(
                        message: "File size must be less than 5MB",
                        context: context,
                        backgroundColor: AppColors.red,
                      );
                      return;
                    }
                    setState(() {
                      selectedFile = file;
                    });
                    widget.onChanged?.call(file);
                  } else {
                    customShowSnackBar(
                      message: "No file was selected",
                      context: context,
                      backgroundColor: AppColors.red,
                    );
                  }
                }
              },
              child: TextField(
                enabled: widget.property.type != 'files',
                onChanged: widget.onChanged,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Empty",
                  hintStyle: AppTextStyles.titleMedium!.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                maxLines: 1,
                style: AppTextStyles.titleMedium!.copyWith(
                  color: AppColors.black,
                ),
              ),
            )
          : widget.property.type == 'select' || widget.property.type == "status"
          ? DropdownButtonFormField(
              isExpanded: true,
              enableFeedback: true,
              padding: EdgeInsets.zero,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Empty",
                hintStyle: AppTextStyles.titleMedium!.copyWith(
                  color: AppColors.grey,
                ),
              ),
              value: widget.property.type == "status"
                  ? widget.property.selectOptions!.first.name
                  : null,
              onChanged: widget.onChanged,
              items: widget.property.selectOptions!
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
            )
          : widget.property.type == 'multi_select'
          ? GestureDetector(
              onTap: () async {
                final List<String>? results = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    List<String> tempSelected = List.from(
                      selectedMultiSelectValues,
                    );
                    return Builder(
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Select Options"),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: widget.property.selectOptions!.map((
                                option,
                              ) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Row(
                                    children: [
                                      CustomCheckBox(
                                        value: tempSelected.contains(
                                          option.name,
                                        ),
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
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          option.name,
                                          style: AppTextStyles.titleMedium!
                                              .copyWith(color: AppColors.black),
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
                    selectedMultiSelectValues = results;
                  });
                  widget.onChanged?.call(results);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Empty",
                  hintStyle: AppTextStyles.titleMedium!.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                child: Row(
                  children: List.generate(selectedMultiSelectValues.length, (
                    index,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: getColor(
                            widget.property.selectOptions![index].color,
                          ),
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
            )
          : widget.property.type == "checkbox"
          ? CustomCheckBox(onChanged: widget.onChanged)
          : Container(),
    );
  }
}
