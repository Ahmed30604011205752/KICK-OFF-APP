import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../auth/model/user_account.dart';
import '../../auth/view/welcome_page.dart';
import '../../bookings/viewmodel/bookings_view_model.dart';
import '../../owner/view/owner_scanner_page.dart';
import '../viewmodel/profile_view_model.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({
    super.key,
    required this.account,
    required this.themeViewModel,
    required this.bookingsViewModel,
  });
  final UserAccount? account;
  final AppThemeViewModel themeViewModel;
  final BookingsViewModel bookingsViewModel;

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  late final ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.account?.name ?? 'Guest supporter';
    final email = widget.account?.email ?? 'Browsing as a guest';
    return SafeArea(
      child: AnimatedBuilder(
        animation: Listenable.merge([_viewModel, widget.themeViewModel]),
        builder: (context, child) {
          final colors = KickOffPalette.of(context);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
            children: [
              const Text(
                'Your profile',
                style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 20),
              Material(
                color: colors.surface,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 27,
                        backgroundColor: colors.surfaceLight,
                        foregroundColor: colors.accent,
                        child: Text(
                          name.isEmpty ? 'K' : name[0].toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colors.muted,
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
              if (widget.account?.isOwner ?? false) ...[
                const SizedBox(height: 25),
                _SectionLabel(title: 'OWNER TOOLS', color: colors.muted),
                const SizedBox(height: 8),
                Material(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(13),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: Icon(
                      Icons.qr_code_scanner,
                      color: colors.accent,
                      size: 21,
                    ),
                    title: const Text(
                      'Scan a booking QR',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    subtitle: Text(
                      'Check a player’s session code',
                      style: TextStyle(color: colors.muted, fontSize: 11),
                    ),
                    trailing: Icon(Icons.chevron_right, color: colors.muted),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            OwnerScannerPage(owner: widget.account!),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 25),
              _SectionLabel(title: 'APPEARANCE', color: colors.muted),
              const SizedBox(height: 8),
              Material(
                color: colors.surface,
                borderRadius: BorderRadius.circular(13),
                clipBehavior: Clip.antiAlias,
                child: SwitchListTile(
                  value: widget.themeViewModel.isLight,
                  onChanged: widget.themeViewModel.setLightMode,
                  secondary: Icon(
                    widget.themeViewModel.isLight
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    color: colors.accent,
                    size: 20,
                  ),
                  title: const Text(
                    'Light mode',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  subtitle: Text(
                    widget.themeViewModel.isLight
                        ? 'Light appearance is on'
                        : 'Dark appearance is on',
                    style: TextStyle(color: colors.muted, fontSize: 11),
                  ),
                  activeThumbColor: colors.accent,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                ),
              ),
              const SizedBox(height: 25),
              _SectionLabel(title: 'PLAY PREFERENCES', color: colors.muted),
              const SizedBox(height: 8),
              Material(
                color: colors.surface,
                borderRadius: BorderRadius.circular(13),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 12, 11, 12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.sports_soccer,
                            color: colors.accent,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Preferred sport',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          DropdownButton<String>(
                            value: _viewModel.preferredSport,
                            underline: const SizedBox.shrink(),
                            dropdownColor: colors.surface,
                            style: TextStyle(
                              color: colors.foreground,
                              fontSize: 12,
                            ),
                            items: const ['Football', 'Padel', 'Basketball']
                                .map(
                                  (sport) => DropdownMenuItem(
                                    value: sport,
                                    child: Text(sport),
                                  ),
                                )
                                .toList(),
                            onChanged: (sport) {
                              if (sport != null) {
                                _viewModel.choosePreferredSport(sport);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: colors.line),
                    SwitchListTile(
                      value: _viewModel.bookingReminders,
                      onChanged: _viewModel.setBookingReminders,
                      secondary: Icon(
                        Icons.notifications_active_outlined,
                        color: colors.accent,
                        size: 20,
                      ),
                      title: const Text(
                        'Booking reminders',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      subtitle: Text(
                        'A reminder before your session',
                        style: TextStyle(color: colors.muted, fontSize: 11),
                      ),
                      activeThumbColor: colors.accent,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              _SectionLabel(title: 'SUPPORT', color: colors.muted),
              const SizedBox(height: 8),
              Material(
                color: colors.surface,
                borderRadius: BorderRadius.circular(13),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _ProfileAction(
                      icon: Icons.help_outline,
                      label: 'Help centre',
                      color: colors,
                      onTap: () => _showMessage(
                        context,
                        'Help centre',
                        'Bookings are stored for this session only in this demo.',
                      ),
                    ),
                    Divider(height: 1, color: colors.line, indent: 48),
                    _ProfileAction(
                      icon: Icons.shield_outlined,
                      label: 'Privacy and terms',
                      color: colors,
                      onTap: () => _showMessage(
                        context,
                        'Privacy and terms',
                        'This demo does not send account details to a server.',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        WelcomePage(themeViewModel: widget.themeViewModel),
                  ),
                  (route) => false,
                ),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Sign out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.foreground,
                  side: BorderSide(color: colors.line),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showMessage(BuildContext context, String title, String message) {
    final colors = KickOffPalette.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, required this.color});
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: TextStyle(
      color: color,
      fontSize: 10,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.3,
    ),
  );
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final KickOffPalette color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: color.accent, size: 20),
    title: Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
    ),
    trailing: Icon(Icons.chevron_right, color: color.muted, size: 20),
    onTap: onTap,
  );
}
