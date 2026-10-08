import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_evently/core/utils/app_assets.dart';

import '../../core/utils/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    super.initState();
    _startSplash();
  }
  Future<void> _startSplash() async {
    // Do any async init work here (load prefs, check auth, etc.)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return; // guard against widget being disposed
    navigate();
  }

  void navigate() => Navigator.pushNamed(context, AppRoutes.start);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Hero(
                  tag: 'logo',
                  child: Image.asset(AppAssets.logo, width: 310),
                ),
              ),
            ),
            Image.asset(AppAssets.routeSplash, width: 70.w),
            SizedBox(height: 8.h),
            Text(
              'Supervised by Mohamed Nabil',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 14.sp,
                fontWeight: .w400,
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }


}
