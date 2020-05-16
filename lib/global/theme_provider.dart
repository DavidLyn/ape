import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flustars/flustars.dart';
import 'package:ape/util/theme_utils.dart';

class ThemeProvider with ChangeNotifier {

  // 是否 dark mode 在 sharedPreferences 中的键值
  static const useDarkModeTheme = "useDarkModeTheme";

  // 当前主题颜色索引在 sharedPreferences 中的键值
  static const themeColorIndex = "themeColorIndex";

  /// 用户选择暗模式
  bool _useDarkMode;
  bool get useDarkMode => _useDarkMode;

  /// 当前主题颜色
  MaterialColor _themeColor;
  MaterialColor get themeColor => _themeColor;

  /// 当前字体索引
  int _fontIndex;
  int get fontIndex => _fontIndex;

  ThemeProvider() {
    /// 用户选择的明暗模式
    _useDarkMode = SpUtil.getBool(useDarkModeTheme) ?? false;

    /// 获取主题色
    _themeColor = Colors.primaries[SpUtil.getInt(themeColorIndex) ?? 5];

    /// 获取字体
    _fontIndex = 0;
  }

  void setBrightnessMode({bool useDarkMode}) {
    _useDarkMode = useDarkMode ?? _useDarkMode;
    notifyListeners();

    SpUtil.putBool(useDarkModeTheme, _useDarkMode);

  }

  void setThemeColor({MaterialColor themeColor}) {
    _themeColor = themeColor ?? _themeColor;
    notifyListeners();

    var index = Colors.primaries.indexOf(themeColor);
    SpUtil.putInt(themeColorIndex, index);

  }

  /// 根据主题 明暗 和 颜色 生成对应的主题
  /// [dark]系统的Dark Mode
  themeData({bool platformDarkMode: false}) {
    var isDark = platformDarkMode || _useDarkMode;
    Brightness brightness = isDark ? Brightness.dark : Brightness.light;

    var themeColor = _themeColor;
    var accentColor = isDark ? themeColor[700] : _themeColor;
    var themeData = ThemeData(
      brightness: brightness,
      // 主题颜色属于亮色系还是属于暗色系(eg:dark时,AppBarTitle文字及状态栏文字的颜色为白色,反之为黑色)
      // 这里设置为dark目的是,不管App是明or暗,都将appBar的字体颜色的默认值设为白色.
      // 再AnnotatedRegion<SystemUiOverlayStyle>的方式,调整响应的状态栏颜色
      primaryColorBrightness: Brightness.dark,
      accentColorBrightness: Brightness.dark,
      primarySwatch: themeColor,
      accentColor: accentColor,
      fontFamily: "system");

    themeData = themeData.copyWith(
      brightness: brightness,
      accentColor: accentColor,
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: themeColor,
        brightness: brightness,
      ),

      appBarTheme: themeData.appBarTheme.copyWith(elevation: 0),
      splashColor: themeColor.withAlpha(50),
      hintColor: themeData.hintColor.withAlpha(90),
      errorColor: Colors.red,
      cursorColor: accentColor,
      textTheme: themeData.textTheme.copyWith(
        /// 解决中文hint不居中的问题 https://github.com/flutter/flutter/issues/40248
          subhead: themeData.textTheme.subhead
            .copyWith(textBaseline: TextBaseline.alphabetic)),
      textSelectionColor: accentColor.withAlpha(60),
      textSelectionHandleColor: accentColor.withAlpha(60),
      toggleableActiveColor: accentColor,
      chipTheme: themeData.chipTheme.copyWith(
        pressElevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        labelStyle: themeData.textTheme.caption,
        backgroundColor: themeData.chipTheme.backgroundColor.withOpacity(0.1),
      ),
  //          textTheme: CupertinoTextThemeData(brightness: Brightness.light)
      inputDecorationTheme: _ThemeHelper.inputDecorationTheme(themeData),
      dividerTheme: DividerThemeData(
          color: platformDarkMode ? Colours.dark_line : Colours.line,
          space: 0.6,
          thickness: 0.6
      ),

    );
    return themeData;
  }

}

class _ThemeHelper {
  static InputDecorationTheme inputDecorationTheme(ThemeData theme) {

    var primaryColor = theme.primaryColor;
    var dividerColor = theme.dividerColor;
    var errorColor = theme.errorColor;
    var disabledColor = theme.disabledColor;

    var width = 0.5;

    return InputDecorationTheme(
      hintStyle: TextStyle(fontSize: 14),
      errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: errorColor)),
      focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 0.7, color: errorColor)),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: primaryColor)),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: dividerColor)),
      border: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: dividerColor)),
      disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: width, color: disabledColor)),
    );
  }
}