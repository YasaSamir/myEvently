import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/config/shared_pref.dart';
import '../../../core/reusable_component/custom_button.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/utils/routes.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentIndex = 0;

  PageController controller = PageController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: leading(context),
        title: Hero(
          tag: 'logo',
          child: Image.asset(AppAssets.logo, width: 140.w),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: PageView.builder(
        controller: controller,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: CustomScrollView(
              dragStartBehavior: DragStartBehavior.start,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Image.asset(
                        "assets/images/onboarding${index + 1}.png",
                        color: Theme.of(context).colorScheme.onPrimary,
                        width: 340.w,
                        height: 340.h,
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildIndicator(1, context),
                          SizedBox(width: 8.w),
                          buildIndicator(2, context),
                          SizedBox(width: 8.w),
                          buildIndicator(3, context),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        index == 0
                            ? AppStrings.onBoarding1Text1
                            : index == 1
                            ? AppStrings.onBoarding2Text1
                            : AppStrings.onBoarding3Text1,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        index == 0
                            ? AppStrings.onBoarding1Text2
                            : index == 1
                            ? AppStrings.onBoarding2Text2
                            : AppStrings.onBoarding3Text2,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 20.h),
                      CustomButton(text: index == 2 ? AppStrings.getStart : AppStrings.next,
                          onPressed: () {
                            setState(() {
                              currentIndex = index;
                            });
                            if (currentIndex == 2) {
                              SharedPref.setOnBoardingSeen(true);
                              Navigator.pushNamed(context, AppRoutes.register);
                            }
                        controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);

                      }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildIndicator(int index, BuildContext context) {
    return Container(
      width: 10.w,
      height: 10.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: index == currentIndex
            ? Theme.of(context).colorScheme.primary
            : Colors.grey,
      ),
    );
  }

  Widget leading(BuildContext context) {
    return currentIndex == 0
        ? SizedBox()
        : currentIndex == 1
        ? Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.rectangle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(AppAssets.back, width: 24.w, height: 24.h),
            ),
          )
        : IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(AppAssets.back, width: 24.w, height: 24.h),
          );
  }
}
