import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/pitch_widgets.dart';
import '../model/booking_qr_payload.dart';
import '../model/pitch_booking.dart';

class BookingConfirmationPage extends StatelessWidget {
  const BookingConfirmationPage({
    super.key,
    required this.booking,
    required this.onDone,
  });
  final PitchBooking booking;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        title: const Text('Booking confirmed'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 26),
          children: [
            Container(
              width: 58,
              height: 58,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.accent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 33,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'You’re all set.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 5),
            Text(
              'Show your booking QR to the pitch owner when you arrive.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.muted, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: colors.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SportIcon(sport: booking.pitch.sport, size: 46),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.pitch.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${booking.pitch.sport} · ${booking.pitch.format}',
                              style: TextStyle(
                                color: colors.muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: colors.line, height: 1),
                  ),
                  _BookingDetail(
                    icon: Icons.calendar_month_outlined,
                    label: 'DATE',
                    value: booking.dateLabel,
                  ),
                  _BookingDetail(
                    icon: Icons.schedule_outlined,
                    label: 'TIME',
                    value: booking.timeRange,
                  ),
                  _BookingDetail(
                    icon: Icons.timelapse_outlined,
                    label: 'DURATION',
                    value:
                        '${booking.durationHours} ${booking.durationHours == 1 ? 'hour' : 'hours'}',
                  ),
                  _BookingDetail(
                    icon: Icons.location_on_outlined,
                    label: 'LOCATION',
                    value: '${booking.pitch.location}, ${booking.pitch.city}',
                  ),
                  _BookingDetail(
                    icon: Icons.person_outline,
                    label: 'BOOKER',
                    value: booking.bookerName,
                  ),
                  _BookingDetail(
                    icon: Icons.person_outline,
                    label: 'BOOKER',
                    value: booking.bookerName,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Divider(color: colors.line, height: 1),
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Total · demo only',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                      Text(
                        'EGP ${booking.totalPrice}',
                        style: TextStyle(
                          color: colors.accent,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: QrImageView(
                        data: BookingQrPayload.fromBooking(booking).encode(),
                        size: 190,
                        backgroundColor: Colors.white,
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: colors.background,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: colors.background,
                        ),
                        errorCorrectionLevel: QrErrorCorrectLevel.M,
                        semanticsLabel:
                            'Booking QR code for ${booking.bookerName}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'BOOKING REFERENCE',
                          style: TextStyle(
                            color: colors.muted,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          booking.reference,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            KickOffButton(
              label: 'View my bookings',
              icon: Icons.event_note_outlined,
              onPressed: onDone,
            ),
            const SizedBox(height: 8),
            Text(
              'No payment has been processed.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.muted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingDetail extends StatelessWidget {
  const _BookingDetail({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Icon(icon, color: colors.accent, size: 17),
          const SizedBox(width: 9),
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: TextStyle(
                color: colors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: .5,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
