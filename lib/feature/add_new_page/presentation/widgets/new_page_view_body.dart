import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/feature/databases/domain/entities/database_entity.dart';
import 'package:pagebridge/feature/add_new_page/presentation/controllers/new_page_cubit/new_page_cubit.dart';
import 'package:pagebridge/feature/databases/presentation/widgets/property_widget.dart';

class NewPageViewBody extends StatelessWidget {
  const NewPageViewBody({super.key, required this.database});
  final DatabaseEntity database;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          const SizedBox(height: 8),
          ...database.properties.reversed.map(
            (e) => PropertyWidget(
              property: e,
              onChanged: (value) {
                context.read<NewPageCubit>().addProperty(
                  key: e.name,
                  value: value,
                  type: e.type,
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextFormField(
              maxLines: null,
              minLines: 8,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              decoration: const InputDecoration(
                hintText: "Start typing your content here...",
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                context.read<NewPageCubit>().setContent(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
