import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quicknotion/config/routes/on_generate_routes.dart';

import '../controllers/auth_cubit/auth_cubit.dart';
import 'background_auth.dart';

class AuthBody extends StatelessWidget {
  const AuthBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AuthSuccess) {
          AppRoutes.homeView(context);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Stack(
          children: [
            const BackgroundAuth(),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: isLoading
                    ? null
                    : () => context.read<AuthCubit>().signIn(),
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Login In'),
              ),
            ),
          ],
        );
      },
    );
  }
}
