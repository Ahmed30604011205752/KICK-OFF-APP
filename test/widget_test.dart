// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:kick_off_app/app/my_app.dart';
import 'package:kick_off_app/features/auth/model/user_account.dart';
import 'package:kick_off_app/features/auth/viewmodel/auth_view_model.dart';
import 'package:kick_off_app/features/bookings/model/booking_qr_payload.dart';
import 'package:kick_off_app/features/bookings/viewmodel/bookings_view_model.dart';
import 'package:kick_off_app/features/owner/viewmodel/owner_scanner_view_model.dart';
import 'package:kick_off_app/features/pitches/viewmodel/pitches_view_model.dart';

void main() {
  testWidgets('guest can schedule a pitch and change the app theme', (
    tester,
  ) async {
    Finder verticalScrollables() => find.byWidgetPredicate(
      (widget) =>
          widget is Scrollable && widget.axisDirection == AxisDirection.down,
    );

    await tester.pumpWidget(const MyApp());
    expect(find.text('KICK OFF'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('A pitch for every player.'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Your time, your call.'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Show up and play.'), findsOneWidget);
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(find.text('Your game,\nyour time.'), findsOneWidget);
    await tester.tap(find.text('Explore as a guest'));
    await tester.pumpAndSettle();

    expect(find.text('Find your\nplaying field.'), findsOneWidget);
    await tester.tap(find.text('Explore').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Padel'));
    await tester.pumpAndSettle();
    expect(find.text('Rally Padel Courts'), findsOneWidget);
    expect(find.text('Kick Off Arena'), findsNothing);

    await tester.tap(find.text('Football'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kick Off Arena'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.textContaining('Choose date & time'),
      250,
      scrollable: verticalScrollables().first,
    );
    await tester.tap(find.textContaining('Choose date & time'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('2 hours'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('7:00 PM'),
      250,
      scrollable: verticalScrollables().first,
    );
    await tester.tap(find.text('7:00 PM'));
    await tester.pumpAndSettle();
    expect(find.text('EGP 1300'), findsAtLeastNWidgets(1));

    await tester.scrollUntilVisible(
      find.text('Confirm booking'),
      250,
      scrollable: verticalScrollables().first,
    );
    await tester.tap(find.text('Confirm booking'));
    await tester.pumpAndSettle();
    expect(find.text('Booking confirmed'), findsOneWidget);
    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.text('Guest player'), findsAtLeastNWidgets(1));

    await tester.scrollUntilVisible(
      find.text('View my bookings'),
      250,
      scrollable: verticalScrollables().first,
    );
    await tester.ensureVisible(find.text('View my bookings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View my bookings'));
    await tester.pumpAndSettle();
    expect(find.text('My bookings'), findsOneWidget);
    expect(find.text('Kick Off Arena'), findsOneWidget);
    expect(find.textContaining('7:00 PM – 9:00 PM'), findsOneWidget);

    await tester.tap(find.text('Profile').last);
    await tester.pumpAndSettle();
    expect(find.text('Light mode'), findsOneWidget);
    await tester.tap(find.byType(SwitchListTile).first);
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Light appearance is on'))).brightness,
      Brightness.light,
    );
    await tester.tap(find.byType(SwitchListTile).first);
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Dark appearance is on'))).brightness,
      Brightness.dark,
    );
  });

  test('a longer booking blocks overlapping time slots', () {
    final pitches = PitchesViewModel();
    final bookings = BookingsViewModel();
    final pitch = pitches.featuredPitch;

    bookings.prepareBooking(pitch);
    bookings.selectDuration(2);
    bookings.selectStartHour(18);
    bookings.createBooking(bookerName: 'Guest player');

    expect(bookings.availableStartHours, isNot(contains(19)));
    expect(bookings.availableStartHours, contains(20));

    pitches.dispose();
    bookings.dispose();
  });

  test('owner scanner accepts Kick Off QR payloads only', () {
    final pitches = PitchesViewModel();
    final bookings = BookingsViewModel();
    final pitch = pitches.featuredPitch;
    bookings.prepareBooking(pitch);
    bookings.selectStartHour(18);
    final booking = bookings.createBooking(bookerName: 'Amina Hassan');
    final payload = BookingQrPayload.fromBooking(booking);
    final scanner = OwnerScannerViewModel();

    expect(scanner.acceptScan(payload.encode()), isTrue);
    expect(scanner.scannedBooking?.bookerName, 'Amina Hassan');
    expect(scanner.scannedBooking?.pitchName, pitch.name);
    scanner.confirmCheckIn();
    expect(scanner.isCheckedIn, isTrue);

    scanner.resumeScanning();
    expect(scanner.acceptScan('not-a-booking'), isFalse);
    expect(scanner.errorMessage, isNotNull);

    scanner.dispose();
    bookings.dispose();
    pitches.dispose();
  });

  test('owner registration creates an owner account role', () {
    final viewModel = AuthViewModel()..toggleMode();
    viewModel.selectRole(AccountRole.owner);

    final account = viewModel.submit(
      name: 'Pitch Owner',
      email: 'owner@example.com',
      password: 'securepass',
    );

    expect(account?.isOwner, isTrue);
    viewModel.dispose();
  });

  test('owner sign-in retains the selected owner role', () {
    final viewModel = AuthViewModel();
    viewModel.selectRole(AccountRole.owner);

    final account = viewModel.submit(
      name: '',
      email: 'owner@example.com',
      password: 'securepass',
    );

    expect(account?.isOwner, isTrue);
    viewModel.dispose();
  });
}
