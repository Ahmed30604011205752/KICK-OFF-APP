import 'package:flutter/foundation.dart';

import '../../pitches/model/sports_pitch.dart';
import '../model/pitch_booking.dart';

class BookingsViewModel extends ChangeNotifier {
  final List<PitchBooking> _bookings = [];
  SportsPitch? _selectedPitch;
  DateTime _selectedDate = _dateOnly(DateTime.now());
  int _durationHours = 1;
  int? _selectedStartHour;

  List<PitchBooking> get bookings => List.unmodifiable(_bookings);
  SportsPitch? get selectedPitch => _selectedPitch;
  DateTime get selectedDate => _selectedDate;
  int get durationHours => _durationHours;
  int? get selectedStartHour => _selectedStartHour;
  bool get canBook => _selectedPitch != null && _selectedStartHour != null;
  int get totalPrice => (_selectedPitch?.hourlyRate ?? 0) * _durationHours;

  List<DateTime> get bookableDates => List.generate(
    14,
    (index) => _dateOnly(DateTime.now()).add(Duration(days: index)),
  );

  List<int> get availableStartHours {
    final pitch = _selectedPitch;
    if (pitch == null) return const [];
    return List.generate(15, (index) => index + 8)
        .where((startHour) => startHour + _durationHours <= 23)
        .where(
          (startHour) =>
              !_hasConflict(pitch, _selectedDate, startHour, _durationHours),
        )
        .toList();
  }

  void prepareBooking(SportsPitch pitch) {
    _selectedPitch = pitch;
    _selectedDate = _dateOnly(DateTime.now());
    _durationHours = 1;
    _selectedStartHour = null;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = _dateOnly(date);
    _selectedStartHour = null;
    notifyListeners();
  }

  void selectDuration(int hours) {
    if (hours < 1 || hours > 3) return;
    _durationHours = hours;
    if (!availableStartHours.contains(_selectedStartHour)) {
      _selectedStartHour = null;
    }
    notifyListeners();
  }

  void selectStartHour(int hour) {
    if (!availableStartHours.contains(hour)) return;
    _selectedStartHour = hour;
    notifyListeners();
  }

  PitchBooking createBooking({required String bookerName}) {
    final pitch = _selectedPitch;
    final startHour = _selectedStartHour;
    if (pitch == null || startHour == null || !canBook) {
      throw StateError('Select an available booking time before confirming.');
    }
    final now = DateTime.now();
    final reference = 'KO${now.microsecondsSinceEpoch.toString().substring(8)}';
    final booking = PitchBooking(
      id: '${pitch.id}-${now.microsecondsSinceEpoch}',
      pitch: pitch,
      bookerName: bookerName,
      date: _selectedDate,
      startHour: startHour,
      durationHours: _durationHours,
      totalPrice: totalPrice,
      reference: reference,
    );
    _bookings.insert(0, booking);
    _selectedStartHour = null;
    notifyListeners();
    return booking;
  }

  bool _hasConflict(
    SportsPitch pitch,
    DateTime date,
    int startHour,
    int duration,
  ) {
    final endHour = startHour + duration;
    return _bookings.any((booking) {
      if (booking.pitch.id != pitch.id || !_sameDate(booking.date, date)) {
        return false;
      }
      return startHour < booking.endHour && endHour > booking.startHour;
    });
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool _sameDate(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}
