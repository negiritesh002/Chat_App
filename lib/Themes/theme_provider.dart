import 'package:chat_app/Themes/theme.dart';
import 'package:flutter/material.dart';

import 'darkmode.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData = lightmode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == Darkmode;

  set themeData(ThemeData themeData){
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme(){
    if (_themeData == lightmode){
      themeData = Darkmode;
    }
    else {
      themeData = lightmode;
    }
  }
}