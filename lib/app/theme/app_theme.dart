import 'package:flutter/material.dart';

class KickOffPalette extends ThemeExtension<KickOffPalette> {
  const KickOffPalette({
    required this.background,
    required this.surface,
    required this.surfaceLight,
    required this.accent,
    required this.muted,
    required this.line,
    required this.foreground,
  });

  final Color background;
  final Color surface;
  final Color surfaceLight;
  final Color accent;
  final Color muted;
  final Color line;
  final Color foreground;

  static const dark = KickOffPalette(
    background: Color(0xFF07120F),
    surface: Color(0xFF101D19),
    surfaceLight: Color(0xFF172822),
    accent: Color(0xFF2FE6A2),
    muted: Color(0xFF8B9A93),
    line: Color(0xFF263831),
    foreground: Color(0xFFF5FAF7),
  );

  static const light = KickOffPalette(
    background: Color(0xFFF3F7F4),
    surface: Color(0xFFFFFFFF),
    surfaceLight: Color(0xFFE5EEE8),
    accent: Color(0xFF087A55),
    muted: Color(0xFF60736A),
    line: Color(0xFFD5E1DA),
    foreground: Color(0xFF15251D),
  );

  static KickOffPalette of(BuildContext context) =>
      Theme.of(context).extension<KickOffPalette>()!;

  @override
  KickOffPalette copyWith({
    Color? background,
    Color? surface,
    Color? surfaceLight,
    Color? accent,
    Color? muted,
    Color? line,
    Color? foreground,
  }) => KickOffPalette(
    background: background ?? this.background,
    surface: surface ?? this.surface,
    surfaceLight: surfaceLight ?? this.surfaceLight,
    accent: accent ?? this.accent,
    muted: muted ?? this.muted,
    line: line ?? this.line,
    foreground: foreground ?? this.foreground,
  );

  @override
  KickOffPalette lerp(ThemeExtension<KickOffPalette>? other, double t) {
    if (other is! KickOffPalette) return this;
    return KickOffPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      line: Color.lerp(line, other.line, t)!,
      foreground: Color.lerp(foreground, other.foreground, t)!,
    );
  }
}

class KickOffTheme {
  static ThemeData get dark =>
      _createTheme(KickOffPalette.dark, Brightness.dark);
  static ThemeData get light =>
      _createTheme(KickOffPalette.light, Brightness.light);

  static ThemeData _createTheme(KickOffPalette palette, Brightness brightness) {
    final colorScheme = brightness == Brightness.dark
        ? ColorScheme.dark(
            primary: palette.accent,
            onPrimary: palette.background,
            secondary: palette.accent,
            surface: palette.surface,
            onSurface: palette.foreground,
            outline: palette.line,
            outlineVariant: palette.line,
          )
        : ColorScheme.light(
            primary: palette.accent,
            onPrimary: Colors.white,
            secondary: palette.accent,
            surface: palette.surface,
            onSurface: palette.foreground,
            outline: palette.line,
            outlineVariant: palette.line,
          );

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: palette.background,
      extensions: [palette],
      useMaterial3: true,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: palette.foreground,
        centerTitle: false,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: palette.surface,
        indicatorColor: palette.accent.withValues(alpha: .15),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(color: palette.foreground),
        ),
      ),
    );
  }
}

class AppThemeViewModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;
  bool get isLight => _themeMode == ThemeMode.light;

  void setLightMode(bool enabled) {
    final nextMode = enabled ? ThemeMode.light : ThemeMode.dark;
    if (_themeMode == nextMode) return;
    _themeMode = nextMode;
    notifyListeners();
  }
}
