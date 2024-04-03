import 'package:flutter/material.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';
import 'package:wan_android_flutter/ui/shared/shared_preferences_helper.dart';

class AppSettingsViewModel extends ChangeNotifier {
  static const colorSeedKey = "color_key";
  static const colorThemeKey = "theme_key";
  static const languageKey = "language_key";

  ThemeMode _themeMode = ThemeMode.values[SharedPreferencesHelper.getInt(colorThemeKey) ?? 0];
  ColorSeed _colorSeed = ColorSeed.values[SharedPreferencesHelper.getInt(colorSeedKey) ?? 0];
  LanguageType _languageType= LanguageType.values[SharedPreferencesHelper.getInt(languageKey) ?? 0];

  ThemeMode get themeMode => _themeMode;
  ColorSeed get colorSeed => _colorSeed;
  LanguageType get languageType => _languageType;

  void setThemeMode(int index) {
    _themeMode = ThemeMode.values[index];
    SharedPreferencesHelper.setValue(colorThemeKey, index);

    notifyListeners();
  }

  void setColorSeed(int index) {
    _colorSeed = ColorSeed.values[index];
    SharedPreferencesHelper.setValue(colorSeedKey, index);

    notifyListeners();
  }

  void setLanguageType(int index) {
    _languageType = LanguageType.values[index];
    SharedPreferencesHelper.setValue(languageKey, index);

    notifyListeners();
  }

}