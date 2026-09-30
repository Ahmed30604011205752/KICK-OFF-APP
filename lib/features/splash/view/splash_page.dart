import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/pitch_widgets.dart';
import '../../onboarding/view/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.themeViewModel});

  final AppThemeViewModel themeViewModel;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _navigationTimer = Timer(
      const Duration(milliseconds: 1400),
      _openOnboarding,
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  void _openOnboarding() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => OnboardingPage(themeViewModel: widget.themeViewModel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1522778119026-d647f0596c20?auto=format&fit=crop&w=1400&q=90',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.surfaceLight, colors.background],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        Colors.black.withValues(alpha: .32),
                        colors.background.withValues(alpha: .96),
                      ]
                    : [
                        colors.background.withValues(alpha: .2),
                        colors.background.withValues(alpha: .92),
                      ],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const KickOffMark(size: 74),
                  const SizedBox(height: 16),
                  const Text(
                    'KICK OFF',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'YOUR PITCH. YOUR TIME.',
                    style: TextStyle(
                      color: colors.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: 42),
                  SizedBox(
                    width: 92,
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1300),
                      tween: Tween(begin: 0, end: 1),
                      builder: (context, value, child) =>
                          LinearProgressIndicator(
                            value: value,
                            minHeight: 2,
                            backgroundColor: colors.muted.withValues(
                              alpha: .25,
                            ),
                            color: colors.accent,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
