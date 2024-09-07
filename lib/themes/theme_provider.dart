import 'package:flutter/material.dart';
import 'package:mytwitter/themes/dark_mode.dart';
import 'package:mytwitter/themes/light_mode.dart';

/*
  Theme providers

  helps us to change the app from dark & light mode

*/

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkmode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;

    notifyListeners();
  }

  void toggletheme() {
    if (_themeData == lightMode) {
      themeData = darkmode;
    } else {
      themeData = lightMode;
    }
  }
}
