import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagebridge/core/helpers/responsive_layout.dart';
import 'package:pagebridge/feature/main_layout/presentation/views/main_layout_mobile.dart';
import 'package:pagebridge/feature/main_layout/presentation/views/main_layout_tablet.dart';
import '../cubit/main_layout_cubit.dart';

class MainLayoutView extends StatelessWidget {
  const MainLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainLayoutCubit, int>(
      builder: (context, currentIndex) {
        return PopScope(
          canPop: currentIndex == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            context.read<MainLayoutCubit>().changeTab(0);
          },
          child: ResponsiveLayout(
            compact: (context) => MainLayoutMobile(currentIndex: currentIndex),
            medium: (context) => MainLayoutTablet(currentIndex: currentIndex),
          ),
        );
      },
    );
  }
}
