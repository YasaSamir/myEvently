import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theming.dart';
import 'core/theme/provider/theme_provider.dart';
import 'core/utils/routes.dart';
import 'features/auth/login/login_page.dart';
import 'features/auth/register/register_page.dart';
import 'features/on_boarding/on_boarding_page/on_boarding.dart';
import 'features/splash/splash_page.dart';
import 'features/start/start_page/start_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        home: const SplashPage(),
        routes: {
          AppRoutes.splash: (context) => const SplashPage(),
          AppRoutes.start: (context) => StartPage(),
          AppRoutes.onboarding: (context) => OnBoarding(),
          AppRoutes.register: (context) => RegisterPage(),
          AppRoutes.login: (context) => const LoginPage(),
        },
        initialRoute: AppRoutes.splash,
        debugShowCheckedModeBanner: false,
        theme: AppTheming.lightTheme,
        darkTheme: AppTheming.darkTheme,
        themeMode: Provider.of<ThemeProvider>(context).themeMode,
      ),
    );
  }
}
