import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';
import 'package:quicknotion/core/constants/borders.dart';
import 'package:quicknotion/feature/auth/presentation/widgets/background_auth.dart';

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
            onPressed: () {},
            child: Text('Login In'),
          ),
        ),
      ],
    );
  }
}
