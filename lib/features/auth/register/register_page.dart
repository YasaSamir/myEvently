import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/reusable_component/custom_button.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/routes.dart';
import '../widgets/custom_text_from.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController emailController;

  late final TextEditingController nameController;

  late final TextEditingController passController;

  late final TextEditingController confirmPassController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    nameController = TextEditingController();
    passController = TextEditingController();
    confirmPassController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passController.dispose();
    confirmPassController.dispose();

    super.dispose();
  }

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
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      SizedBox(height: 45.h),
                      Text(
                        AppStrings.createYourAccount,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(height: 24.h),
                      CustomTextFrom(
                        hintText: AppStrings.enterYourName,
                        prefixIcon: AppAssets.profile,
                        obscureText: false,
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name cannot be empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      CustomTextFrom(
                        keyboardType: TextInputType.emailAddress,
                        hintText: AppStrings.enterYourEmail,
                        prefixIcon: AppAssets.email,
                        obscureText: false,
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$",
                          ).hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      CustomTextFrom(
                        keyboardType: TextInputType.visiblePassword,
                        hintText: AppStrings.enterYourPassword,
                        prefixIcon: AppAssets.lock,
                        obscureText: false,
                        controller: passController,
                        isPassword: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          } else if (!RegExp(
                            r"^(?=.*[A-Za-z])(?=.*\d).{8,}$",
                          ).hasMatch(value)) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      CustomTextFrom(
                        keyboardType: TextInputType.visiblePassword,
                        hintText: AppStrings.confirmPassword,
                        prefixIcon: AppAssets.lock,
                        obscureText: false,
                        isPassword: true,
                        controller: confirmPassController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != passController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 50.h),
                      CustomButton(
                        text: AppStrings.signUp,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            print('Account created successfully');
                          }
                        },
                      ),
                      SizedBox(height: 50.h),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "${AppStrings.alreadyHaveAccount} ",
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(fontWeight: FontWeight.w400),
                            children: [
                              TextSpan(
                                text: AppStrings.login,
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
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
                            side: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                              width: 1.w,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppAssets.google,
                              width: 24.w,
                              height: 24.h,
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              AppStrings.continueWithGoogle,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
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
            ],
          ),
        ),
      ),
    );
  }
}
