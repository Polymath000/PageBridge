import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/core/helpers/custom_show_snack_bar.dart';

class PropertyTypeFile extends StatefulWidget {
  const PropertyTypeFile({super.key, this.onChanged});
  final ValueChanged<dynamic>? onChanged;

  @override
  State<PropertyTypeFile> createState() => _PropertyTypeFileState();
}

class _PropertyTypeFileState extends State<PropertyTypeFile> {
  List<PlatformFile>? selectedFile = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.any,
          withData: true,
        );
        if (result != null) {
          for (var va in result.files) {
            int sizeInBytes = va.size;
            double sizeInMb = sizeInBytes / (1024 * 1024);
            if (sizeInMb > 5) {
              customShowSnackBar(
                message: "File size must be less than 5MB",
                context: context,
                backgroundColor: AppColors.red,
              );
              return;
            }
          }

          setState(() {
            selectedFile = result.files;
          });
          widget.onChanged?.call(selectedFile);
        } else {
          customShowSnackBar(
            message: "No file was selected",
            context: context,
            backgroundColor: AppColors.red,
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: selectedFile != null && selectedFile!.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(selectedFile!.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ColoredBox(
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppColors.grey
                          : AppColors.white,
                      child: Text(
                        " ${selectedFile![index].name} ",
                        style: AppTextStyles.titleMedium!.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  );
                }),
              )
            : Text(
                'Empty',
                style: AppTextStyles.titleMedium!.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? AppColors.grey
                      : AppColors.white,
                  fontSize: 16.sp,
                ),
              ),
      ),
    );
  }
}
