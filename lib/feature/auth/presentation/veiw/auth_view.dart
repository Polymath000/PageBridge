import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pagebridge/core/utls/setup_service_locator_getit.dart';
import 'package:pagebridge/feature/auth/domain/repo/auth_repository.dart';

import '../controllers/auth_cubit/auth_cubit.dart';
import '../widgets/auth_view_body.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthCubit(authRep: getit.get<AuthRepository>()),
        child: const AuthBody(),
      ),
    );
  }
}
