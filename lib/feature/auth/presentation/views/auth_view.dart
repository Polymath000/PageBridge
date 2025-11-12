import 'package:flutter/material.dart';
import 'package:quicknotion/feature/auth/presentation/widgets/auth_view_body.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});
  static const String routeName = "login_view";
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AuthBody());
  }
}
