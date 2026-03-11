import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quicknotion/config/themes/app_colors.dart';

class CustomLoadingIndecator extends StatelessWidget {
  const CustomLoadingIndecator({super.key, this.height = 190});
  final int height;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height.h),
      child: Center(
        child: SizedBox(
          height: 190.h,
          child: SpinKitSpinningLines(color: AppColors.green, size: 160.h),
        ),
      ),
    );
  }
}
