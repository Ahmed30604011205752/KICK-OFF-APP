import 'dart:convert';

import 'pitch_booking.dart';

class BookingQrPayload {
  const BookingQrPayload({
    required this.bookingId,
    required this.reference,
    required this.bookerName,
    required this.pitchId,
    required this.pitchName,
    required this.sport,
    required this.date,
    required this.startHour,
    required this.durationHours,
    required this.totalPrice,
  });

  static const format = 'kick_off_booking_v1';

  final String bookingId;
  final String reference;
  final String bookerName;
  final String pitchId;
  final String pitchName;
  final String sport;
  final DateTime date;
  final int startHour;
  final int durationHours;
  final int totalPrice;

  int get endHour => startHour + durationHours;

  String get timeRange => '${_formatHour(startHour)} – ${_formatHour(endHour)}';

  factory BookingQrPayload.fromBooking(PitchBooking booking) =>
      BookingQrPayload(
        bookingId: booking.id,
        reference: booking.reference,
        bookerName: booking.bookerName,
        pitchId: booking.pitch.id,
        pitchName: booking.pitch.name,
        sport: booking.pitch.sport,
        date: booking.date,
        startHour: booking.startHour,
        durationHours: booking.durationHours,
        totalPrice: booking.totalPrice,
      );

  String encode() => jsonEncode({
    'type': format,
    'id': bookingId,
    'ref': reference,
    'booker': bookerName,
    'pitch_id': pitchId,
    'pitch': pitchName,
    'sport': sport,
    'date': date.toIso8601String(),
    'start': startHour,
    'hours': durationHours,
    'total': totalPrice,
  });

  factory BookingQrPayload.decode(String value) {
    final Object? decoded;
    try {
      decoded = jsonDecode(value);
    } on FormatException {
      throw const FormatException('This is not a Kick Off booking QR code.');
    }
    if (decoded is! Map<String, dynamic> || decoded['type'] != format) {
      throw const FormatException('This is not a Kick Off booking QR code.');
    }

    final bookingId = decoded['id'];
    final reference = decoded['ref'];
    final bookerName = decoded['booker'];
    final pitchId = decoded['pitch_id'];
    final pitchName = decoded['pitch'];
    final sport = decoded['sport'];
    final rawDate = decoded['date'];
    final startHour = decoded['start'];
    final durationHours = decoded['hours'];
    final totalPrice = decoded['total'];

    if (bookingId is! String ||
        reference is! String ||
        bookerName is! String ||
        pitchId is! String ||
        pitchName is! String ||
        sport is! String ||
        rawDate is! String ||
        startHour is! int ||
        durationHours is! int ||
        totalPrice is! int ||
        bookingId.isEmpty ||
        reference.isEmpty ||
        bookerName.isEmpty ||
        pitchId.isEmpty ||
        pitchName.isEmpty ||
        sport.isEmpty ||
        startHour < 0 ||
        startHour > 23 ||
        durationHours < 1 ||
        durationHours > 3 ||
        startHour + durationHours > 24 ||
        totalPrice < 0) {
      throw const FormatException('This Kick Off booking QR code is invalid.');
    }

    final DateTime date;
    try {
      date = DateTime.parse(rawDate);
    } on FormatException {
      throw const FormatException('This Kick Off booking QR code is invalid.');
    }

    return BookingQrPayload(
      bookingId: bookingId,
      reference: reference,
      bookerName: bookerName,
      pitchId: pitchId,
      pitchName: pitchName,
      sport: sport,
      date: date,
      startHour: startHour,
      durationHours: durationHours,
      totalPrice: totalPrice,
    );
  }

  static String _formatHour(int hour) {
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:00 $period';
  }
}
