import '../../pitches/model/sports_pitch.dart';

class PitchBooking {
  const PitchBooking({
    required this.id,
    required this.pitch,
    required this.bookerName,
    required this.date,
    required this.startHour,
    required this.durationHours,
    required this.totalPrice,
    required this.reference,
  });

  final String id;
  final SportsPitch pitch;
  final String bookerName;
  final DateTime date;
  final int startHour;
  final int durationHours;
  final int totalPrice;
  final String reference;

  int get endHour => startHour + durationHours;

  String get timeRange => '${_formatHour(startHour)} – ${_formatHour(endHour)}';

  String get dateLabel {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  }

  static String _formatHour(int hour) {
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:00 $period';
  }
}
