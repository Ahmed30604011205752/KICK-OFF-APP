import 'package:flutter/foundation.dart';

import '../model/onboarding_slide.dart';

class OnboardingViewModel extends ChangeNotifier {
  int _currentPage = 0;

  List<OnboardingSlide> get slides => OnboardingSlide.slides;
  int get currentPage => _currentPage;
  bool get isLastPage => _currentPage == slides.length - 1;

  void setCurrentPage(int page) {
    if (page < 0 || page >= slides.length || page == _currentPage) return;
    _currentPage = page;
    notifyListeners();
  }
}
