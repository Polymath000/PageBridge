import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/config/themes/app_text_style.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/property_type.dart';

class NotionDateWidget extends StatelessWidget {
  const NotionDateWidget({super.key, required this.widget});

  final PropertyType widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: GestureDetector(
        onTap: () async {
          final List<String>? results = await showDialog(
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
                      onDateChanged: widget.onChanged ?? (value) {},
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
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
        child: Text(
          "Empty",
          style: AppTextStyles.titleMedium!.copyWith(color: AppColors.grey),
        ),
      ),
    );
  }
}
