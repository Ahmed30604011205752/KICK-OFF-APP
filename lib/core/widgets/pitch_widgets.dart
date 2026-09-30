import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import '../../features/pitches/model/sports_pitch.dart';

class KickOffMark extends StatelessWidget {
  const KickOffMark({super.key, this.size = 42});
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: .13),
        border: Border.all(color: colors.accent.withValues(alpha: .4)),
        borderRadius: BorderRadius.circular(size * .28),
      ),
      child: Icon(Icons.sports_soccer, color: colors.accent, size: size * .54),
    );
  }
}

class KickOffButton extends StatelessWidget {
  const KickOffButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 54,
    width: double.infinity,
    child: FilledButton.icon(
      onPressed: onPressed,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      style: FilledButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}

class PitchArtwork extends StatelessWidget {
  const PitchArtwork({
    super.key,
    required this.pitch,
    this.height = 190,
    this.child,
  });
  final SportsPitch pitch;
  final double height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            pitch.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.surfaceLight, colors.background],
                ),
              ),
              child: Icon(
                _sportIcon(pitch.sport),
                color: colors.accent,
                size: 64,
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        Colors.black.withValues(alpha: .12),
                        Colors.black.withValues(alpha: .82),
                      ]
                    : [
                        Colors.white.withValues(alpha: .05),
                        colors.background.withValues(alpha: .96),
                      ],
              ),
            ),
          ),
          ?child,
        ],
      ),
    );
  }
}

class SportIcon extends StatelessWidget {
  const SportIcon({super.key, required this.sport, this.size = 48});
  final String sport;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(_sportIcon(sport), color: colors.accent, size: size * .5),
    );
  }
}

IconData _sportIcon(String sport) => switch (sport) {
  'Padel' => Icons.sports_tennis,
  'Basketball' => Icons.sports_basketball,
  _ => Icons.sports_soccer,
};

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
    ],
  );
}

class PitchListTile extends StatelessWidget {
  const PitchListTile({
    super.key,
    required this.pitch,
    required this.onTap,
    required this.isFavorite,
    required this.onFavorite,
  });
  final SportsPitch pitch;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              SportIcon(sport: pitch.sport),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pitch.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: onFavorite,
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Save pitch',
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 18,
                            color: isFavorite ? colors.accent : colors.muted,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${pitch.sport} · ${pitch.format}',
                      style: TextStyle(color: colors.muted, fontSize: 11),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: colors.muted,
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '${pitch.location}, ${pitch.city}',
                            style: TextStyle(color: colors.muted, fontSize: 11),
                          ),
                        ),
                        Icon(
                          Icons.star_rounded,
                          color: colors.accent,
                          size: 15,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          pitch.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'EGP ${pitch.hourlyRate} / hour',
                      style: TextStyle(
                        color: colors.accent,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 45, color: colors.accent),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.muted),
            ),
          ],
        ),
      ),
    );
  }
}
