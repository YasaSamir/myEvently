import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({
    super.key,
    required this.onTap,
    required this.firstIcon,
    required this.isSwitched,
  });

  final void Function()? onTap;
  final bool isSwitched;
  final String? firstIcon;

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
          color: !isSwitched
              ? Theme.of(context).colorScheme.onPrimary
              : Colors.transparent.withValues(alpha: 0.02),
        ),
        child:Center(
          child: SvgPicture.asset(
            firstIcon!,
            colorFilter: ColorFilter.mode(
              isSwitched
                  ? Theme.of(context).colorScheme.primary
                  : Colors.white,
              BlendMode.srcIn,
            ),
          ),
        )

      ),
    );
  }
}
