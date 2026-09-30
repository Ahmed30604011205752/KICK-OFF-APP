import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/pitch_widgets.dart';
import '../../auth/view/welcome_page.dart';
import '../model/onboarding_slide.dart';
import '../viewmodel/onboarding_view_model.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.themeViewModel});

  final AppThemeViewModel themeViewModel;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final OnboardingViewModel _viewModel = OnboardingViewModel();

  @override
  void dispose() {
    _pageController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _finish() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => WelcomePage(themeViewModel: widget.themeViewModel),
      ),
    );
  }

  void _continue() {
    if (_viewModel.isLastPage) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 16, 8),
              child: Row(
                children: [
                  const KickOffMark(size: 34),
                  const SizedBox(width: 9),
                  const Text(
                    'KICK OFF',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _finish,
                    child: Text('Skip', style: TextStyle(color: colors.muted)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: _viewModel,
                builder: (context, child) => PageView.builder(
                  controller: _pageController,
                  itemCount: _viewModel.slides.length,
                  onPageChanged: _viewModel.setCurrentPage,
                  itemBuilder: (context, index) =>
                      _OnboardingSlideView(slide: _viewModel.slides[index]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 22),
              child: AnimatedBuilder(
                animation: _viewModel,
                builder: (context, child) => Row(
                  children: [
                    Row(
                      children: List.generate(
                        _viewModel.slides.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.only(right: 6),
                          width: index == _viewModel.currentPage ? 22 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: index == _viewModel.currentPage
                                ? colors.accent
                                : colors.muted.withValues(alpha: .35),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 150,
                      child: KickOffButton(
                        label: _viewModel.isLastPage ? 'Get started' : 'Next',
                        icon: _viewModel.isLastPage
                            ? Icons.arrow_forward
                            : Icons.chevron_right,
                        onPressed: _continue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlideView extends StatelessWidget {
  const _OnboardingSlideView({required this.slide});

  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    slide.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colors.surfaceLight, colors.background],
                        ),
                      ),
                      child: Icon(
                        Icons.sports_soccer,
                        size: 68,
                        color: colors.accent,
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          (isDark ? colors.background : Colors.white)
                              .withValues(alpha: .55),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 23),
          Text(
            slide.eyebrow,
            style: TextStyle(
              color: colors.accent,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            slide.title,
            style: const TextStyle(
              fontSize: 28,
              height: 1.12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            slide.description,
            style: TextStyle(color: colors.muted, fontSize: 14, height: 1.45),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
