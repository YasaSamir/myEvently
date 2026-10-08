

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {


  static Future<bool?> setOnBoardingSeen(bool seen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('onboarding_seen', seen ? true : false);
  }

  static Future<bool?> getOnBoardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_seen');
  }

}