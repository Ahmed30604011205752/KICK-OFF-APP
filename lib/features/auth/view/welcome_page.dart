import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/pitch_widgets.dart';
import '../../pitches/view/app_shell.dart';
import 'auth_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.themeViewModel});

  final AppThemeViewModel themeViewModel;

  void _openApp(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => AppShell(themeViewModel: themeViewModel),
      ),
    );
  }

  void _openAuth(BuildContext context, {bool create = false}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            AuthPage(createAccount: create, themeViewModel: themeViewModel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = KickOffPalette.of(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?auto=format&fit=crop&w=1400&q=90',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF15392D), palette.background],
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
                colors: [
                  palette.background.withValues(alpha: .25),
                  palette.background.withValues(alpha: .65),
                  palette.background.withValues(alpha: .97),
                ],
                stops: [0, .45, 1],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 24, 25, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      KickOffMark(size: 40),
                      SizedBox(width: 11),
                      Text(
                        'KICK OFF',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.2,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: palette.accent.withValues(alpha: .13),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'YOUR PITCH. YOUR TIME.',
                      style: TextStyle(
                        color: palette.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    'Your game,\nyour time.',
                    style: TextStyle(
                      color: palette.foreground,
                      fontSize: 43,
                      height: 1.02,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.7,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Find a nearby pitch, choose a time,\nand get your game going.',
                    style: TextStyle(
                      color: palette.foreground.withValues(alpha: .8),
                      height: 1.5,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 31),
                  KickOffButton(
                    label: 'Get started',
                    icon: Icons.arrow_forward,
                    onPressed: () => _openAuth(context, create: true),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => _openAuth(context),
                      child: Text(
                        'I already have an account',
                        style: TextStyle(
                          color: palette.foreground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: TextButton.icon(
                      onPressed: () => _openApp(context),
                      icon: const Icon(Icons.explore_outlined, size: 17),
                      label: const Text('Explore as a guest'),
                      style: TextButton.styleFrom(
                        foregroundColor: palette.muted,
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
