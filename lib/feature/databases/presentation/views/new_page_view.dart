import 'package:flutter/material.dart';
import 'package:quicknotion/feature/databases/domain/entities/database_entity.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/new_page_view_body.dart';

class NewPageView extends StatelessWidget {
  const NewPageView({super.key, required this.database});
  final DatabaseEntity database;
  static const String routeName = 'new_page_view';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0, left: 20, right: 20),
            child: NewPageViewBody(database: database),
          ),
        ),
      ),
    );
  }
}
