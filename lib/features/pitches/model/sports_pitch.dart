class SportsPitch {
  const SportsPitch({
    required this.id,
    required this.name,
    required this.sport,
    required this.format,
    required this.location,
    required this.city,
    required this.surface,
    required this.hourlyRate,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.description,
    required this.features,
  });

  final String id;
  final String name;
  final String sport;
  final String format;
  final String location;
  final String city;
  final String surface;
  final int hourlyRate;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String description;
  final List<String> features;
}
