import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import '../features/splash/view/splash_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppThemeViewModel _themeViewModel = AppThemeViewModel();

  @override
  void dispose() {
    _themeViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeViewModel,
      builder: (context, child) => MaterialApp(
        title: 'Kick Off',
        debugShowCheckedModeBanner: false,
        theme: KickOffTheme.light,
        darkTheme: KickOffTheme.dark,
        themeMode: _themeViewModel.themeMode,
        home: SplashPage(themeViewModel: _themeViewModel),
      ),
    );
  }
}
