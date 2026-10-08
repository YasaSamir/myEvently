import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier{

  ThemeMode themeMode = ThemeMode.light;

   void changeTheme(ThemeMode mode){
     if(themeMode == mode) return;
    themeMode = mode;
    notifyListeners();
  }

}