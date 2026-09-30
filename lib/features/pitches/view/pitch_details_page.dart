import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/pitch_widgets.dart';
import '../../bookings/view/booking_page.dart';
import '../../bookings/viewmodel/bookings_view_model.dart';
import '../model/sports_pitch.dart';

class PitchDetailsPage extends StatelessWidget {
  const PitchDetailsPage({
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

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: colors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: PitchArtwork(
                pitch: pitch,
                height: 250,
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          SportIcon(sport: pitch.sport, size: 46),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pitch.sport.toUpperCase(),
                                  style: TextStyle(
                                    color: colors.accent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.4,
                                  ),
                                ),
                                Text(
                                  pitch.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        pitch.format,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Icon(Icons.star_rounded, color: colors.accent, size: 19),
                    const SizedBox(width: 3),
                    Text(
                      '${pitch.rating} (${pitch.reviewCount})',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  pitch.description,
                  style: TextStyle(
                    color: colors.muted,
                    height: 1.45,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 18),
                _PitchInfoRow(
                  icon: Icons.location_on_outlined,
                  title: '${pitch.location}, ${pitch.city}',
                  subtitle: 'Location',
                ),
                _PitchInfoRow(
                  icon: Icons.sports_soccer,
                  title: pitch.surface,
                  subtitle: 'Playing surface',
                ),
                _PitchInfoRow(
                  icon: Icons.payments_outlined,
                  title: 'EGP ${pitch.hourlyRate} / hour',
                  subtitle: 'Hourly rental rate',
                ),
                const SizedBox(height: 14),
                const SectionHeading(title: 'Pitch amenities'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: pitch.features
                      .map(
                        (feature) => Chip(
                          avatar: Icon(
                            Icons.check,
                            size: 15,
                            color: colors.accent,
                          ),
                          label: Text(feature),
                          backgroundColor: colors.surface,
                          side: BorderSide(color: colors.line),
                          labelStyle: const TextStyle(fontSize: 11),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                KickOffButton(
                  label: 'Choose date & time · EGP ${pitch.hourlyRate}/hr',
                  icon: Icons.calendar_month_outlined,
                  onPressed: () {
                    bookingsViewModel.prepareBooking(pitch);
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => BookingPage(
                          pitch: pitch,
                          bookerName: bookerName,
                          bookingsViewModel: bookingsViewModel,
                          onViewBookings: onViewBookings,
                        ),
                      ),
                    );
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _PitchInfoRow extends StatelessWidget {
  const _PitchInfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: colors.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(color: colors.muted, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
