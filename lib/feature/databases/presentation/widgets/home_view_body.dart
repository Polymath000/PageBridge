import 'package:flutter/material.dart';
import 'package:quicknotion/feature/databases/presentation/views/database_card.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DatabaseCard(),
      ],
    );
  }
}
