import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:quicknotion/config/themes/app_colors.dart';

class CustomLoadingIndecator extends StatelessWidget {
  const CustomLoadingIndecator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 250,
        child: LoadingIndicator(
          indicatorType: Indicator.ballScaleRippleMultiple,
          colors: const [AppColors.blue],
          strokeWidth: 5,
    
          backgroundColor: AppColors.transparent,
          pathBackgroundColor: Colors.black,
        ),
      ),
    );
  }
}
