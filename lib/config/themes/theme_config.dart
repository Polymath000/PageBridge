import 'package:flutter/cupertino.dart'
// show CupertinoColors, CupertinoThemeData
;
import 'package:flutter/material.dart'
    show
        AppBarTheme,
        Brightness,
        Color,
        ColorScheme,
        Colors,
        DynamicSchemeVariant,
        TargetPlatform,
        ThemeData,
        ThemeExtension,
        immutable;

// import '../../helpers/get_setting.dart' show getSetting;
import 'app_colors.dart' show AppColors;
import 'app_theme_data.dart' show AppThemeData;

@immutable
final class ModernSlateColors extends ThemeExtension<ModernSlateColors> {
  const ModernSlateColors({
    required this.background,
    required this.card,
    required this.searchBarFill,
    required this.primaryText,
    required this.secondaryText,
    required this.border,
  });

  final Color background;
  final Color card;
  final Color searchBarFill;
  final Color primaryText;
  final Color secondaryText;
  final Color border;

  @override
  ModernSlateColors copyWith({
    Color? background,
    Color? card,
    Color? searchBarFill,
    Color? primaryText,
    Color? secondaryText,
    Color? border,
  }) {
    return ModernSlateColors(
      background: background ?? this.background,
      card: card ?? this.card,
      searchBarFill: searchBarFill ?? this.searchBarFill,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      border: border ?? this.border,
    );
  }

  @override
  ModernSlateColors lerp(ModernSlateColors other, double t) {
    return ModernSlateColors(
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      searchBarFill: Color.lerp(searchBarFill, other.searchBarFill, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}

@immutable
final class ThemeConfig {
  const ThemeConfig();

  ThemeData? get light => _themeData();

  ThemeData? get dark => _themeData(Brightness.dark);

  ThemeData? _themeData([final Brightness brightness = Brightness.light]) {
    const getSetting = SettingsEntity();

    final isAppleDevice =
        getSetting.platform == TargetPlatform.iOS ||
        getSetting.platform == TargetPlatform.macOS;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: getSetting.seedColor,
      brightness: brightness,
      dynamicSchemeVariant: getSetting.dynamicSchemeVariant,
      surface: (getSetting.isAmoledSelected)
          ? brightness == Brightness.dark
                ? Colors.black
                : Colors.white
          : null,
    );

    final appBarTheme = isAppleDevice
        ? const AppBarTheme(
            shadowColor: CupertinoColors.darkBackgroundGray,
            surfaceTintColor: AppColors.transparent,
            scrolledUnderElevation: .1,
            toolbarHeight: 44,
            actionsPadding: EdgeInsets.only(left: 8),
          )
        : const AppBarTheme(actionsPadding: EdgeInsets.only(right: 8));

    final textTheme = isAppleDevice
        ? AppThemeData.text.copyWith(
            headlineMedium: const CupertinoTextThemeData()
                .navLargeTitleTextStyle
                .copyWith(
                  letterSpacing: -1.5,
                  fontFamily: 'Cairo',
                  fontFamilyFallback: const <String>['Cairo', 'Roboto'],
                ),
            titleLarge: const CupertinoTextThemeData().navTitleTextStyle
                .copyWith(
                  fontFamily: 'Cairo',
                  fontFamilyFallback: const <String>['Cairo', 'Roboto'],
                ),
          )
        : AppThemeData.text;

    final modernSlateColors = brightness == Brightness.light
        ? const ModernSlateColors(
            background: Color(0xFFF8F9FA),
            card: Color(0xFFFFFFFF),
            searchBarFill: Color(0xFFEDF2F7),
            primaryText: Color(0xFF1A202C),
            secondaryText: Color(0xFFA0AEC0),
            border: Color(0xFFE2E8F0),
          )
        : const ModernSlateColors(
            background: Color(0xFF0F172A),
            card: Color(0xFF1E293B),
            searchBarFill: Color(0xFF334155),
            primaryText: Color(0xFFF8FAFC),
            secondaryText: Color(0xFF94A3B8),
            border: Color(0xFF334155),
          );

    return ThemeData(
      inputDecorationTheme: AppThemeData.inputDecoration,
      platform: getSetting.platform,
      useMaterial3: getSetting.useMaterial3,
      useSystemColors: true,
      colorScheme: colorScheme,
      brightness: brightness,
      extensions: <ThemeExtension<dynamic>>[modernSlateColors],
      // colorSchemeSeed: getSetting.seedColor,
      fontFamily: 'Cairo',
      fontFamilyFallback: const <String>['Cairo', 'Roboto'],
      textTheme: textTheme,
      appBarTheme: appBarTheme,
      cardTheme: AppThemeData.card,
      checkboxTheme: AppThemeData.checkbox,
      chipTheme: AppThemeData.chip,
      dialogTheme: AppThemeData.dialog,
      dropdownMenuTheme: AppThemeData.dropdownMenu,
      filledButtonTheme: AppThemeData.filledButton,
      floatingActionButtonTheme: AppThemeData.floatingActionButton,
      iconButtonTheme: AppThemeData.iconButton,
      navigationBarTheme: AppThemeData.navigationBar,
      outlinedButtonTheme: AppThemeData.outlinedButton,
      progressIndicatorTheme: AppThemeData.progressIndicator,
      searchBarTheme: AppThemeData.searchBar,
      snackBarTheme: AppThemeData.snackBar,
      textButtonTheme: AppThemeData.textButton,
    );
  }
}

class SettingsEntity {
  const SettingsEntity({
    this.seedColor = Colors.blue,
    this.useMaterial3,
    this.platform,
    this.dynamicSchemeVariant = DynamicSchemeVariant.content,
    this.isAmoledSelected = false,
  });
  final Color seedColor;
  final bool? useMaterial3;
  final TargetPlatform? platform;
  final DynamicSchemeVariant dynamicSchemeVariant;
  final bool isAmoledSelected;
}
