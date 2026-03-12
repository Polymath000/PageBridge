import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:quicknotion/core/utls/setup_service_locator_getit.dart';

import '../../domain/usecases/sign_in_with_notion_usecase.dart';
import '../controllers/auth_cubit/auth_cubit.dart';
import '../widgets/auth_view_body.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});
  static const String routeName = "login_view";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthCubit(
          signInWithNotion: getit.get<SignInWithNotionUseCase>(),
        ),
        child: const AuthBody(),
      ),
    );
  }
}
