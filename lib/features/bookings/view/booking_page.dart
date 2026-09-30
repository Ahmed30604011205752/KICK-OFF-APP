import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/pitch_widgets.dart';
import '../../pitches/model/sports_pitch.dart';
import '../model/pitch_booking.dart';
import '../viewmodel/bookings_view_model.dart';
import 'booking_confirmation_page.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({
    super.key,
    required this.pitch,
    required this.bookerName,
    required this.bookingsViewModel,
    required this.onViewBookings,
  });
  final SportsPitch pitch;
  final String bookerName;
  final BookingsViewModel bookingsViewModel;
  final VoidCallback onViewBookings;

  void _confirm(BuildContext context) {
    final PitchBooking booking = bookingsViewModel.createBooking(
      bookerName: bookerName,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) =>
            BookingConfirmationPage(booking: booking, onDone: onViewBookings),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule your session')),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: bookingsViewModel,
          builder: (context, child) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Text(
                pitch.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${pitch.location}, ${pitch.city} · EGP ${pitch.hourlyRate}/hour',
                style: TextStyle(color: colors.muted, fontSize: 12),
              ),
              const SizedBox(height: 25),
              const Text(
                'Choose a day',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 11),
              SizedBox(
                height: 70,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: bookingsViewModel.bookableDates.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final date = bookingsViewModel.bookableDates[index];
                    final selected = _sameDay(
                      date,
                      bookingsViewModel.selectedDate,
                    );
                    final label = index == 0
                        ? 'Today'
                        : index == 1
                        ? 'Tomorrow'
                        : _weekday(date.weekday);
                    return ChoiceChip(
                      label: SizedBox(
                        width: 54,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              label,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${date.day}/${date.month}',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      selected: selected,
                      onSelected: (_) => bookingsViewModel.selectDate(date),
                      showCheckmark: false,
                      selectedColor: colors.accent,
                      backgroundColor: colors.surface,
                      side: BorderSide(
                        color: selected ? colors.accent : colors.line,
                      ),
                      labelStyle: TextStyle(
                        color: selected
                            ? Theme.of(context).colorScheme.onPrimary
                            : colors.foreground,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 7),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'How long?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 1, label: Text('1 hour')),
                  ButtonSegment(value: 2, label: Text('2 hours')),
                  ButtonSegment(value: 3, label: Text('3 hours')),
                ],
                selected: {bookingsViewModel.durationHours},
                onSelectionChanged: (selection) =>
                    bookingsViewModel.selectDuration(selection.first),
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  textStyle: const WidgetStatePropertyAll(
                    TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Available start times',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    '${bookingsViewModel.availableStartHours.length} slots',
                    style: TextStyle(color: colors.muted, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 11),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: bookingsViewModel.availableStartHours.map((hour) {
                  final selected = hour == bookingsViewModel.selectedStartHour;
                  return ChoiceChip(
                    label: Text(_formatHour(hour)),
                    selected: selected,
                    onSelected: (_) => bookingsViewModel.selectStartHour(hour),
                    showCheckmark: false,
                    selectedColor: colors.accent,
                    backgroundColor: colors.surface,
                    side: BorderSide(
                      color: selected ? colors.accent : colors.line,
                    ),
                    labelStyle: TextStyle(
                      color: selected
                          ? Theme.of(context).colorScheme.onPrimary
                          : colors.foreground,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: colors.line)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${bookingsViewModel.durationHours} ${bookingsViewModel.durationHours == 1 ? 'hour' : 'hours'} × EGP ${pitch.hourlyRate}',
                            style: TextStyle(color: colors.muted),
                          ),
                        ),
                        Text(
                          'EGP ${bookingsViewModel.totalPrice}',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Total',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          'EGP ${bookingsViewModel.totalPrice}',
                          style: TextStyle(
                            color: colors.accent,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              KickOffButton(
                label: 'Confirm booking',
                icon: Icons.event_available_outlined,
                onPressed: bookingsViewModel.canBook
                    ? () => _confirm(context)
                    : null,
              ),
              const SizedBox(height: 9),
              Text(
                'Demo booking · No payment is processed',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.muted, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static String _weekday(int day) =>
      const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day - 1];

  static String _formatHour(int hour) {
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:00 $period';
  }
}
