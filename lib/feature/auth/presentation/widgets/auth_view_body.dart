import 'package:flutter/material.dart';
import 'package:quicknotion/config/routes/on_generate_routes.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/core/constants/borders.dart';
import 'package:quicknotion/feature/auth/presentation/widgets/background_auth.dart';
import 'package:quicknotion/feature/auth/data/auth_service.dart';

class AuthBody extends StatelessWidget {
  const AuthBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundAuth(),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColors.darkGrey),
              foregroundColor: MaterialStateProperty.all(AppColors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: AppBorders.xxs),
              ),
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
              elevation: MaterialStateProperty.all(5.0),
              overlayColor: MaterialStateProperty.resolveWith((
                Set<MaterialState> states,
              ) {
                if (states.contains(MaterialState.pressed)) {
                  return AppColors.darkerEdge;
                }
                return null;
              }),
            ),
            onPressed: () async {
              final authService = AuthService();
              final code = await authService.authenticateWithNotion();
              if (code != null) {
                print('Received code: $code');
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Success! Code: $code')));

                // Exchange code for token
                final accessToken = await authService.exchangeCodeForToken(
                  code,
                );
                if (accessToken != null) {
                  print('Received access token: $accessToken');
                  // Fetch databases
                  await authService.fetchAccessibleDatabases(accessToken);
                  AppRoutes.homeView(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to get access token')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Authentication failed')),
                );
              }
            },
            child: Text('Login In'),
          ),
        ),
      ],
    );
  }
}
