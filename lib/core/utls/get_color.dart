import 'package:flutter/material.dart';
import 'package:quicknotion/config/themes/app_colors.dart';

Color getColor(String color) {
  switch (color) {
    case 'default':
      return AppColors.textGray;      
    case 'gray':
      return AppColors.grey;
    case 'brown':
      return AppColors.brown;
    case 'orange':
      return AppColors.orange;
    case 'yellow':
      return AppColors.amber;
    case 'green':
      return AppColors.green;
    case 'blue':
      return AppColors.blue;
    case 'purple':
      return AppColors.purple;
    case 'pink':
      return AppColors.pink;
    case 'red':
      return AppColors.red;
    default:
      return AppColors.darkGrey;
  }
}
