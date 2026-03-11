import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:quicknotion/config/themes/app_icons.dart';
import 'package:quicknotion/feature/databases/domain/entities/property_entity.dart';
import 'package:quicknotion/feature/databases/presentation/controllers/return_pages_cubit/return_pages_cubit.dart';

class RelationTypeWidgetBody extends StatefulWidget {
  const RelationTypeWidgetBody({
    super.key,
    required this.property,
    required this.onChanged,
  });
  final PropertyEntity property;
  final List<DropdownItem<String>> items = const [];
  final Function(String) onChanged;

  @override
  State<RelationTypeWidgetBody> createState() => _RelationTypeWidgetBodyState();
}

class _RelationTypeWidgetBodyState extends State<RelationTypeWidgetBody> {
  final _formKey = GlobalKey<FormState>();

  final controller = MultiSelectController<String>();
  String currentSearchQuery = "";

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color fieldBg = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final Color borderColor = isDark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFDDDDDD);
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color hintColor = isDark
        ? const Color(0xFFA0A0A0)
        : const Color(0xFF777777);
    final Color dropdownBg = isDark
        ? const Color(0xFF2F2F2F)
        : const Color(0xFFF5F5F5);
    final Color selectedBg = isDark
        ? const Color(0xFF3D3D3D)
        : const Color(0xFFE0E0E0);
    const Color accentColor = Color(0xFF4CAF50);

    return BlocConsumer<ReturnPagesCubit, ReturnPagesState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),

              MultiDropdown<String>(
                items: widget.items,
                controller: controller,
                searchEnabled: true,
                onSearchChange: (value) {
                  setState(() {
                    currentSearchQuery = value;
                    widget.onChanged(value);
                  });
                },
                chipDecoration: ChipDecoration(
                  backgroundColor: accentColor,
                  labelStyle: const TextStyle(color: Colors.white),
                  wrap: true,
                  runSpacing: 4,
                  spacing: 6,
                ),

                fieldDecoration: FieldDecoration(
                  backgroundColor: fieldBg,
                  labelText: widget.property.name,
                  labelStyle: TextStyle(color: textColor),
                  hintText: "Select items",
                  hintStyle: TextStyle(color: hintColor, fontSize: 14.sp),
                  showClearIcon: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: accentColor),
                  ),
                ),

                dropdownItemDecoration: DropdownItemDecoration(
                  backgroundColor: dropdownBg,
                  selectedBackgroundColor: selectedBg,
                  textColor: textColor,
                  selectedIcon: Icon(AppIcons.checkbox, color: accentColor),
                  disabledIcon: Icon(Icons.lock, color: hintColor),
                ),
              ),

              const SizedBox(height: 5),
            ],
          ),
        );
      },
    );
  }
}
