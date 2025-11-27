import 'package:flutter/material.dart';
import 'package:quicknotion/feature/auth/presentation/widgets/token_view_body.dart';

class TokenView extends StatelessWidget {
  const TokenView({super.key});
  static const String routeName = 'token';
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TokenViewBody());
  }
}
