import 'package:flutter/foundation.dart';

import '../model/sports_pitch.dart';

class PitchesViewModel extends ChangeNotifier {
  final List<SportsPitch> pitches = const [
    SportsPitch(
      id: 'p1',
      name: 'Kick Off Arena',
      sport: 'Football',
      format: '5-a-side',
      location: 'New Cairo',
      city: 'Cairo',
      surface: 'Pro artificial turf',
      hourlyRate: 650,
      rating: 4.9,
      reviewCount: 128,
      imageUrl:
          'https://images.unsplash.com/photo-1522778119026-d647f0596c20?auto=format&fit=crop&w=1200&q=85',
      description:
          'A full-size 5-a-side pitch with bright floodlights, quality turf and everything ready for your next game.',
      features: ['Floodlights', 'Changing rooms', 'Showers', 'Parking'],
    ),
    SportsPitch(
      id: 'p2',
      name: 'Greenline Sports Club',
      sport: 'Football',
      format: '7-a-side',
      location: 'Maadi',
      city: 'Cairo',
      surface: 'Natural grass',
      hourlyRate: 900,
      rating: 4.8,
      reviewCount: 96,
      imageUrl:
          'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?auto=format&fit=crop&w=1200&q=85',
      description:
          'A spacious seven-a-side ground with natural grass and a comfortable clubhouse for teams.',
      features: ['Changing rooms', 'Showers', 'Free parking'],
    ),
    SportsPitch(
      id: 'p3',
      name: 'Rally Padel Courts',
      sport: 'Padel',
      format: 'Doubles court',
      location: 'Zamalek',
      city: 'Cairo',
      surface: 'Panoramic glass',
      hourlyRate: 500,
      rating: 4.7,
      reviewCount: 74,
      imageUrl:
          'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6?auto=format&fit=crop&w=1200&q=85',
      description:
          'Panoramic courts, equipment rental and an easy place to meet for a quick match.',
      features: ['Racket rental', 'Floodlights', 'Cafe'],
    ),
    SportsPitch(
      id: 'p4',
      name: 'Eastside Five',
      sport: 'Football',
      format: '5-a-side',
      location: 'Nasr City',
      city: 'Cairo',
      surface: 'Artificial turf',
      hourlyRate: 550,
      rating: 4.6,
      reviewCount: 61,
      imageUrl:
          'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d?auto=format&fit=crop&w=1200&q=85',
      description:
          'A friendly neighborhood pitch with late opening hours and simple online booking.',
      features: ['Floodlights', 'Changing rooms', 'Water station'],
    ),
    SportsPitch(
      id: 'p5',
      name: 'Downtown Hoops',
      sport: 'Basketball',
      format: 'Full court',
      location: 'Heliopolis',
      city: 'Cairo',
      surface: 'Indoor hardwood',
      hourlyRate: 480,
      rating: 4.8,
      reviewCount: 43,
      imageUrl:
          'https://images.unsplash.com/photo-1504450758481-7338eba7524a?auto=format&fit=crop&w=1200&q=85',
      description:
          'An indoor hardwood court with marked lines, scoreboards and space for your team.',
      features: ['Indoor court', 'Scoreboard', 'Changing rooms'],
    ),
  ];

  final Set<String> _favoriteIds = {};
  String _selectedSport = 'All';
  String _searchQuery = '';

  List<String> get sports => const ['All', 'Football', 'Padel', 'Basketball'];

  String get selectedSport => _selectedSport;

  SportsPitch get featuredPitch => pitches.first;

  List<SportsPitch> get visiblePitches {
    final query = _searchQuery.trim().toLowerCase();
    return pitches.where((pitch) {
      final matchesSport =
          _selectedSport == 'All' || pitch.sport == _selectedSport;
      final matchesSearch =
          query.isEmpty ||
          pitch.name.toLowerCase().contains(query) ||
          pitch.sport.toLowerCase().contains(query) ||
          pitch.location.toLowerCase().contains(query) ||
          pitch.city.toLowerCase().contains(query);
      return matchesSport && matchesSearch;
    }).toList();
  }

  bool isFavorite(SportsPitch pitch) => _favoriteIds.contains(pitch.id);

  void selectSport(String sport) {
    _selectedSport = sport;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFavorite(SportsPitch pitch) {
    if (!_favoriteIds.add(pitch.id)) _favoriteIds.remove(pitch.id);
    notifyListeners();
  }
}
