import 'package:flutter/foundation.dart';

class ProfileViewModel extends ChangeNotifier {
  bool _bookingReminders = true;
  String _preferredSport = 'Football';

  bool get bookingReminders => _bookingReminders;
  String get preferredSport => _preferredSport;

  void setBookingReminders(bool value) {
    _bookingReminders = value;
    notifyListeners();
  }

  void choosePreferredSport(String value) {
    _preferredSport = value;
    notifyListeners();
  }
}
