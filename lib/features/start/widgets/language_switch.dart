import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({
    super.key,
    required this.text,
    required this.onTap,
    required this.languageCode,
    required this.selectedLanguage,
  });

  final void Function()? onTap;


  final String text;
  final String languageCode;
  final String selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.all(4.r),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: .5,
            ),
            borderRadius: BorderRadius.circular(8.r),
            color: selectedLanguage == languageCode
                ? Theme.of(context).colorScheme.onPrimary
                : Colors.transparent,
          ),
          child: Center(
            child: Text(
              text,
              style: !(selectedLanguage == languageCode)
                  ? Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontSize: 14.sp)
                  : Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
    );
  }
}
