import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_evently/core/utils/app_assets.dart';

class CustomTextFrom extends StatefulWidget {
  CustomTextFrom({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    required this.obscureText,
    this.validator,
    this.isVisible = false,
    this.isPassword = false,
    this.suffixTap,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  final String hintText;
  final String prefixIcon;
  final String? suffixIcon;
  bool? obscureText;
  final String? Function(String?)? validator;
  bool? isVisible;
  final bool isPassword;
  final VoidCallback? suffixTap;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  State<CustomTextFrom> createState() => _CustomTextFromState();
}

class _CustomTextFromState extends State<CustomTextFrom> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,

      obscureText: widget.obscureText!,
      obscuringCharacter: '*',
      validator: widget.validator,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.isVisible = !widget.isVisible!;
                      widget.obscureText= widget.isVisible;
                    });
                  },
                  child: SvgPicture.asset(
                    widget.isVisible! ? AppAssets.hidden : AppAssets.visibleOn,
                    width: 24.w,
                    height: 24.h,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            : null,
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.labelMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            width: 1,
          ),
        ),
        fillColor: Theme.of(context).colorScheme.onPrimaryContainer,
        filled: true,
        enabled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            width: 1,
          ),
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: SvgPicture.asset(
            widget.prefixIcon,
            width: 24.w,
            height: 24.h,
            fit: BoxFit.contain,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      ),
    );
  }
}
