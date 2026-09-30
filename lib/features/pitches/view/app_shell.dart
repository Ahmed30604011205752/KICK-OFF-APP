import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../auth/model/user_account.dart';
import '../../bookings/view/bookings_page.dart';
import '../../bookings/viewmodel/bookings_view_model.dart';
import '../../profile/view/account_settings_page.dart';
import '../model/sports_pitch.dart';
import '../viewmodel/pitches_view_model.dart';
import 'pitch_details_page.dart';
import 'pitches_pages.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.themeViewModel, this.account});
  final AppThemeViewModel themeViewModel;
  final UserAccount? account;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final PitchesViewModel _pitchesViewModel = PitchesViewModel();
  final BookingsViewModel _bookingsViewModel = BookingsViewModel();
  int _selectedTab = 0;

  @override
  void dispose() {
    _pitchesViewModel.dispose();
    _bookingsViewModel.dispose();
    super.dispose();
  }

  void _openPitch(SportsPitch pitch) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PitchDetailsPage(
          pitch: pitch,
          bookerName: widget.account?.name ?? 'Guest player',
          bookingsViewModel: _bookingsViewModel,
          onViewBookings: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            setState(() => _selectedTab = 2);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _selectedTab,
        children: [
          HomePitchesPage(
            pitchesViewModel: _pitchesViewModel,
            onOpenPitch: _openPitch,
            onExplore: () => setState(() => _selectedTab = 1),
          ),
          ExplorePitchesPage(
            pitchesViewModel: _pitchesViewModel,
            onOpenPitch: _openPitch,
          ),
          BookingsPage(
            bookingsViewModel: _bookingsViewModel,
            onExplore: () => setState(() => _selectedTab = 1),
          ),
          AccountSettingsPage(
            account: widget.account,
            themeViewModel: widget.themeViewModel,
            bookingsViewModel: _bookingsViewModel,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (index) => setState(() => _selectedTab = index),
        backgroundColor: colors.surface,
        indicatorColor: colors.accent.withValues(alpha: .15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(icon: Icon(Icons.search), label: 'Explore'),
          NavigationDestination(
            icon: Icon(Icons.event_note_outlined),
            selectedIcon: Icon(Icons.event_note),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
