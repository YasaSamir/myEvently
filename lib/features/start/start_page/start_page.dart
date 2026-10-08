import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_evently/core/config/shared_pref.dart';
import 'package:my_evently/core/reusable_component/custom_button.dart';
import 'package:my_evently/core/utils/app_assets.dart';
import 'package:my_evently/core/utils/app_strings.dart';
import 'package:my_evently/core/utils/routes.dart';
import 'package:my_evently/features/start/widgets/language_switch.dart';
import 'package:my_evently/features/start/widgets/theme_switch.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/provider/theme_provider.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool changeLanguage = false;
  String selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: 'logo',
          child: Image.asset(AppAssets.logo, width: 140.w),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              AppAssets.beingCreative,
              color: Theme.of(context).colorScheme.onPrimary,
              width: 340.w,
              height: 340.h,
            ),
            SizedBox(height: 24.h),
            Text(
              AppStrings.personalizeYourExperience,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8.h),
            Text(
              AppStrings.chooseYourPreferredThemeAndLanguage,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppStrings.language,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                LanguageSwitch(
                  text: AppStrings.enLanguage,
                  onTap: () {
                    setState(() {
                      selectedLanguage = 'en';
                    });
                  },
                  languageCode: 'en',
                  selectedLanguage: selectedLanguage,
                ),
                LanguageSwitch(
                  text: AppStrings.arLanguage,
                  onTap: () {
                    setState(() {
                      selectedLanguage = 'ar';
                    });
                  },
                  languageCode: 'ar',
                  selectedLanguage: selectedLanguage,
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppStrings.theme,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    ThemeSwitch(
                      onTap: () {
                        themeProvider.changeTheme(ThemeMode.light);
                      },
                      firstIcon: themeProvider.themeMode == ThemeMode.light
                          ? AppAssets.sunSelected
                          : AppAssets.sun,
                      isSwitched: !(themeProvider.themeMode == ThemeMode.light),
                    ),
                    ThemeSwitch(
                      isSwitched: !(themeProvider.themeMode == ThemeMode.dark),
                      onTap: () {
                        themeProvider.changeTheme(ThemeMode.dark);
                      },
                      firstIcon: themeProvider.themeMode == ThemeMode.dark
                          ? AppAssets.moonSelected
                          : AppAssets.moon,
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20.h),
            CustomButton(
              text: AppStrings.letsStart,
              onPressed: () async {
                final hasSeenOnboarding = await SharedPref.getOnBoardingSeen();

                if (!context.mounted) return;

                Navigator.pushNamed(
                  context,
                  hasSeenOnboarding == true
                      ? AppRoutes.register
                      : AppRoutes.onboarding,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
