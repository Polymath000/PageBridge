import 'package:flutter/material.dart';
import 'package:quicknotion/feature/databases/presentation/widgets/token_form_body.dart';

class TokenViewBody extends StatelessWidget {
  const TokenViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Builder(builder: (context) => TokenFormBody(context: context)),
      ),
    );
  }
}
