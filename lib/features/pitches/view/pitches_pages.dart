import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/pitch_widgets.dart';
import '../model/sports_pitch.dart';
import '../viewmodel/pitches_view_model.dart';

class HomePitchesPage extends StatelessWidget {
  const HomePitchesPage({
    super.key,
    required this.pitchesViewModel,
    required this.onOpenPitch,
    required this.onExplore,
  });
  final PitchesViewModel pitchesViewModel;
  final ValueChanged<SportsPitch> onOpenPitch;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const KickOffMark(size: 38),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'KICK OFF',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Your next game starts here',
                        style: TextStyle(color: colors.muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none_rounded),
                  tooltip: 'Booking reminders',
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              'Find your\nplaying field.',
              style: TextStyle(
                fontSize: 31,
                fontWeight: FontWeight.w900,
                height: 1.07,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Pick a place. Choose a time. Play.',
              style: TextStyle(color: colors.muted, fontSize: 13),
            ),
            const SizedBox(height: 22),
            _FeaturedPitchCard(
              pitch: pitchesViewModel.featuredPitch,
              onTap: () => onOpenPitch(pitchesViewModel.featuredPitch),
            ),
            const SizedBox(height: 24),
            SectionHeading(
              title: 'Popular nearby',
              action: 'See all',
              onAction: onExplore,
            ),
            const SizedBox(height: 9),
            ...pitchesViewModel.pitches
                .skip(1)
                .take(3)
                .map(
                  (pitch) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: PitchListTile(
                      pitch: pitch,
                      onTap: () => onOpenPitch(pitch),
                      isFavorite: pitchesViewModel.isFavorite(pitch),
                      onFavorite: () => pitchesViewModel.toggleFavorite(pitch),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedPitchCard extends StatelessWidget {
  const _FeaturedPitchCard({required this.pitch, required this.onTap});
  final SportsPitch pitch;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 235,
          child: PitchArtwork(
            pitch: pitch,
            height: 235,
            child: Padding(
              padding: const EdgeInsets.all(17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colors.accent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${pitch.sport.toUpperCase()} · ${pitch.format.toUpperCase()}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 9,
                        letterSpacing: .7,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    pitch.name,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: colors.accent,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${pitch.location}, ${pitch.city}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Text(
                        'EGP ${pitch.hourlyRate}/hr',
                        style: TextStyle(
                          color: colors.accent,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 15, color: colors.accent),
                      const SizedBox(width: 4),
                      Text(
                        '${pitch.rating} · ${pitch.reviewCount} reviews',
                        style: const TextStyle(fontSize: 11),
                      ),
                      const Spacer(),
                      Icon(Icons.arrow_forward, size: 17, color: colors.accent),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExplorePitchesPage extends StatefulWidget {
  const ExplorePitchesPage({
    super.key,
    required this.pitchesViewModel,
    required this.onOpenPitch,
  });
  final PitchesViewModel pitchesViewModel;
  final ValueChanged<SportsPitch> onOpenPitch;

  @override
  State<ExplorePitchesPage> createState() => _ExplorePitchesPageState();
}

class _ExplorePitchesPageState extends State<ExplorePitchesPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Find a pitch',
                  style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 5),
                Text(
                  'Choose a sport, place and time to play.',
                  style: TextStyle(color: colors.muted, fontSize: 13),
                ),
                const SizedBox(height: 17),
                TextField(
                  controller: _searchController,
                  onChanged: widget.pitchesViewModel.search,
                  decoration: InputDecoration(
                    hintText: 'Pitch, sport or area',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _searchController.clear();
                        widget.pitchesViewModel.search('');
                      },
                      icon: const Icon(Icons.close),
                      tooltip: 'Clear search',
                    ),
                    filled: true,
                    fillColor: colors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
                const SizedBox(height: 13),
                AnimatedBuilder(
                  animation: widget.pitchesViewModel,
                  builder: (context, child) => SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.pitchesViewModel.sports.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final sport = widget.pitchesViewModel.sports[index];
                        final selected =
                            sport == widget.pitchesViewModel.selectedSport;
                        return ChoiceChip(
                          label: Text(sport),
                          selected: selected,
                          onSelected: (_) =>
                              widget.pitchesViewModel.selectSport(sport),
                          labelStyle: TextStyle(
                            fontSize: 11,
                            color: selected
                                ? Theme.of(context).colorScheme.onPrimary
                                : colors.foreground,
                          ),
                          selectedColor: colors.accent,
                          backgroundColor: colors.surface,
                          side: BorderSide.none,
                          showCheckmark: false,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: widget.pitchesViewModel,
              builder: (context, child) {
                final pitches = widget.pitchesViewModel.visiblePitches;
                if (pitches.isEmpty) {
                  return const EmptyState(
                    icon: Icons.search_off,
                    title: 'No pitches found',
                    message: 'Try a different sport, pitch name or area.',
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                  itemCount: pitches.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final pitch = pitches[index];
                    return PitchListTile(
                      pitch: pitch,
                      onTap: () => widget.onOpenPitch(pitch),
                      isFavorite: widget.pitchesViewModel.isFavorite(pitch),
                      onFavorite: () =>
                          widget.pitchesViewModel.toggleFavorite(pitch),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
