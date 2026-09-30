import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/pitch_widgets.dart';
import '../model/pitch_booking.dart';
import '../viewmodel/bookings_view_model.dart';
import 'booking_confirmation_page.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({
    super.key,
    required this.bookingsViewModel,
    required this.onExplore,
  });
  final BookingsViewModel bookingsViewModel;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return SafeArea(
      child: AnimatedBuilder(
        animation: bookingsViewModel,
        builder: (context, child) {
          final bookings = bookingsViewModel.bookings;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My bookings',
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${bookings.length} ${bookings.length == 1 ? 'session' : 'sessions'} booked',
                      style: TextStyle(color: colors.muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: bookings.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const EmptyState(
                            icon: Icons.event_note_outlined,
                            title: 'No sessions yet',
                            message:
                                'Choose a nearby pitch and book a time that works for your team.',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: KickOffButton(
                              label: 'Find a pitch',
                              icon: Icons.search,
                              onPressed: onExplore,
                            ),
                          ),
                        ],
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 3, 20, 22),
                        itemCount: bookings.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 11),
                        itemBuilder: (context, index) =>
                            _BookingCard(booking: bookings[index]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking});
  final PitchBooking booking;

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => BookingConfirmationPage(
              booking: booking,
              onDone: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: colors.accent.withValues(alpha: .13),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'CONFIRMED · DEMO',
                      style: TextStyle(
                        color: colors.accent,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right, color: colors.muted, size: 20),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  SportIcon(sport: booking.pitch.sport, size: 43),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.pitch.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${booking.pitch.sport} · ${booking.pitch.format}',
                          style: TextStyle(color: colors.muted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 15,
                    color: colors.accent,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${booking.dateLabel} · ${booking.timeRange}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    'EGP ${booking.totalPrice}',
                    style: TextStyle(
                      color: colors.accent,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
