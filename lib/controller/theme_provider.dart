import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ThemeProvider extends ChangeNotifier {
  var currentTheme = false;

  ThemeMode? get thememode {
    if (currentTheme == false) {
      return ThemeMode.light;
    } else if (currentTheme == true) {
      return ThemeMode.dark;
    }
    return null;
  }

  void setTheme() {
    currentTheme = !currentTheme;
    prefs.setBool('theme', currentTheme);
    notifyListeners();
  }
  void getTheme() {
    currentTheme = prefs.getBool('theme') ?? false;
    notifyListeners();
  }

  void refresh(){
    notifyListeners();
  }
}
