import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/property_type.dart';

class NotionDateWidget extends StatefulWidget {
  const NotionDateWidget({super.key, required this.propertyType});

  final PropertyType propertyType;

  @override
  State<NotionDateWidget> createState() => _NotionDateWidgetState();
}

class _NotionDateWidgetState extends State<NotionDateWidget> {
  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: GestureDetector(
        onTap: () async {
          DateTime selectedDate = DateTime.now();
          final DateTime? pickedDate = await showDialog(
            context: context,
            builder: (context) => Builder(
              builder: (context) {
                return AlertDialog(
                  title: const Text('Select Date'),
                  content: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: CalendarDatePicker(
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 70),
                      lastDate: DateTime(DateTime.now().year + 70),
                      onDateChanged: (value) {
                        selectedDate = value;
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop(selectedDate);
                      },
                    ),
                  ],
                );
              },
            ),
          );
          if (pickedDate != null) {
            setState(() {
              date = pickedDate;
            });
            widget.propertyType.onChanged?.call(
              DateFormat('yyyy-MM-dd').format(pickedDate),
            );
          }
        },
        child: Text(
          date != null ? DateFormat('yyyy-MM-dd').format(date!) : "Empty",
          style: AppTextStyles.titleMedium!.copyWith(
            color: date != null ? AppColors.black : AppColors.grey,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
