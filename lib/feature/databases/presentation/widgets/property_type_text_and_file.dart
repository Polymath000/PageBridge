import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/helpers/custom_show_snack_bar.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';

class PropertyTypeTextAndFile extends StatefulWidget {
  const PropertyTypeTextAndFile({super.key, required this.property, this.onChanged});
  final PropertyEntity property;
  final ValueChanged<dynamic>? onChanged;
  
  @override
  State<PropertyTypeTextAndFile> createState() => _PropertyTypeTextAndFileState();
}

class _PropertyTypeTextAndFileState extends State<PropertyTypeTextAndFile> {
    File? selectedFile;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
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
            );
  }
}