class OnboardingSlide {
  const OnboardingSlide({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  final String eyebrow;
  final String title;
  final String description;
  final String imageUrl;

  static const slides = [
    OnboardingSlide(
      eyebrow: 'FIND YOUR PLACE',
      title: 'A pitch for every player.',
      description:
          'Discover football, padel and basketball spaces close to home.',
      imageUrl:
          'https://images.unsplash.com/photo-1522778119026-d647f0596c20?auto=format&fit=crop&w=1200&q=85',
    ),
    OnboardingSlide(
      eyebrow: 'BOOK ON YOUR TERMS',
      title: 'Your time, your call.',
      description:
          'Choose the day, start time and session length. See the hourly price upfront.',
      imageUrl:
          'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?auto=format&fit=crop&w=1200&q=85',
    ),
    OnboardingSlide(
      eyebrow: 'READY WHEN YOU ARE',
      title: 'Show up and play.',
      description:
          'Keep every session together and return to the places your team loves.',
      imageUrl:
          'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?auto=format&fit=crop&w=1200&q=85',
    ),
  ];
}
