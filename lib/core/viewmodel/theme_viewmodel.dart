import 'package:flutter/material.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';
import 'package:wan_android_flutter/ui/shared/shared_preferences_helper.dart';

enum ThemeModeType { system, light, dark }

class ThemeViewModel extends ChangeNotifier {
  static const colorSeedKey = "color_key";
  static const colorThemeKey = "theme_key";

  ThemeModeType _themeModeType = ThemeModeType.values[SharedPreferencesHelper.getInt(colorThemeKey) ?? 0];
  ColorSeed _colorSeed = ColorSeed.values[SharedPreferencesHelper.getInt(colorSeedKey) ?? 0];

  ThemeModeType get themeModeType => _themeModeType;

  ColorSeed get colorSeed => _colorSeed;

  void setThemeModeType(ThemeModeType modeType) {
    _themeModeType = modeType;
    notifyListeners();
  }

  void setColorSeed(int index) {
    _colorSeed = ColorSeed.values[index];
    SharedPreferencesHelper.setValue(colorSeedKey, index);

    notifyListeners();
  }


}