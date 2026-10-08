import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_evently/core/utils/app_assets.dart';
import 'package:my_evently/core/utils/app_strings.dart';
import 'package:my_evently/features/auth/widgets/custom_text_from.dart';

import '../../../core/reusable_component/custom_button.dart';
import '../../../core/utils/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'logo',
          child: Image.asset(
            AppAssets.logo,
            color: Theme.of(context).colorScheme.onPrimary,
            width: 140.w,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              SizedBox(height: 45.h),
              Text(
                AppStrings.loginToYourAccount,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 24.h),
              CustomTextFrom(
                hintText: AppStrings.enterYourEmail,
                prefixIcon: AppAssets.email,
                obscureText: false,
                controller: emailController,
              ),
              SizedBox(height: 16.h),
              CustomTextFrom(
                controller: passController,
                hintText: AppStrings.enterYourPassword,
                prefixIcon: AppAssets.lock,
                obscureText: isVisible,
                suffixIcon: isVisible
                    ? AppAssets.visibleOff
                    : AppAssets.visibleOn,
                suffixTap: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              ),
              SizedBox(height: 8.h),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    AppStrings.forgetPass,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
              SizedBox(height: 50.h),
              CustomButton(text: AppStrings.login, onPressed: () {}),
              SizedBox(height: 50.h),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "${AppStrings.dontHaveAccount} ",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: AppStrings.signUp,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: Text(
                  "Or",
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontSize: 16.sp),
                ),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.register);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(AppAssets.google, width: 24.w, height: 24.h),
                    SizedBox(width: 16.w),
                    Text(
                      AppStrings.continueWithGoogle,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
