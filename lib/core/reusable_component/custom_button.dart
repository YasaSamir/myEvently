import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 48.h),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h),
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
