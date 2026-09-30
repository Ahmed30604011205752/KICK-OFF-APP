import 'package:flutter/foundation.dart';

import '../../bookings/model/booking_qr_payload.dart';

class OwnerScannerViewModel extends ChangeNotifier {
  BookingQrPayload? scannedBooking;
  String? errorMessage;
  bool isScanning = true;
  bool isCheckedIn = false;

  bool acceptScan(String rawValue) {
    if (!isScanning) return false;
    try {
      scannedBooking = BookingQrPayload.decode(rawValue);
      errorMessage = null;
      isScanning = false;
      isCheckedIn = false;
      notifyListeners();
      return true;
    } on FormatException catch (error) {
      scannedBooking = null;
      errorMessage = error.message;
      isScanning = false;
      notifyListeners();
      return false;
    }
  }

  void resumeScanning() {
    scannedBooking = null;
    errorMessage = null;
    isCheckedIn = false;
    isScanning = true;
    notifyListeners();
  }

  void confirmCheckIn() {
    if (scannedBooking == null || isCheckedIn) return;
    isCheckedIn = true;
    notifyListeners();
  }
}
