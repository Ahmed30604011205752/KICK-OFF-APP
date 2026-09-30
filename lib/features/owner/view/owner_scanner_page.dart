import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/pitch_widgets.dart';
import '../../auth/model/user_account.dart';
import '../viewmodel/owner_scanner_view_model.dart';

class OwnerScannerPage extends StatefulWidget {
  const OwnerScannerPage({super.key, required this.owner});

  final UserAccount owner;

  @override
  State<OwnerScannerPage> createState() => _OwnerScannerPageState();
}

class _OwnerScannerPageState extends State<OwnerScannerPage>
    with WidgetsBindingObserver {
  final OwnerScannerViewModel _viewModel = OwnerScannerViewModel();
  late final MobileScannerController _scannerController;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      autoStart: false,
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.noDuplicates,
      formats: const [BarcodeFormat.qrCode],
    );
    WidgetsBinding.instance.addObserver(this);
    unawaited(_scannerController.start());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_scannerController.value.hasCameraPermission) return;
    switch (state) {
      case AppLifecycleState.resumed:
        if (_viewModel.isScanning) unawaited(_scannerController.start());
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        unawaited(_scannerController.stop());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _viewModel.dispose();
    unawaited(_scannerController.dispose());
    super.dispose();
  }

  void _handleCapture(BarcodeCapture capture) {
    if (!_viewModel.isScanning) return;
    final rawValue = capture.barcodes
        .map((barcode) => barcode.rawValue)
        .firstWhere((value) => value != null, orElse: () => null);
    if (rawValue == null) return;
    _viewModel.acceptScan(rawValue);
    unawaited(_scannerController.stop());
  }

  Future<void> _scanAgain() async {
    _viewModel.resumeScanning();
    await _scannerController.start();
  }

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner scanner'),
        actions: [
          IconButton(
            tooltip: 'Toggle flashlight',
            onPressed: _scannerController.toggleTorch,
            icon: ValueListenableBuilder(
              valueListenable: _scannerController,
              builder: (context, state, child) => Icon(
                state.torchState == TorchState.on
                    ? Icons.flash_on
                    : Icons.flash_off,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: AnimatedBuilder(
            animation: _viewModel,
            builder: (context, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, ${widget.owner.name}',
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Scan a player’s booking QR to view their session.',
                  style: TextStyle(color: colors.muted, fontSize: 13),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: _viewModel.isScanning
                      ? _buildCamera(colors)
                      : _viewModel.scannedBooking != null
                      ? _buildBookingResult(colors)
                      : _buildScanError(colors),
                ),
                const SizedBox(height: 12),
                Text(
                  'DEMO SCANNER · NOT CONNECTED TO A BOOKING SERVER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.muted,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .7,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCamera(KickOffPalette colors) => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Stack(
      fit: StackFit.expand,
      children: [
        MobileScanner(
          controller: _scannerController,
          onDetect: _handleCapture,
          errorBuilder: (context, error) => ColoredBox(
            color: colors.surface,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.no_photography_outlined,
                    color: colors.accent,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Camera is unavailable',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Allow camera access in system settings to scan bookings.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: Center(
            child: Container(
              width: 242,
              height: 242,
              decoration: BoxDecoration(
                border: Border.all(color: colors.accent, width: 3),
                borderRadius: BorderRadius.circular(20),
                color: colors.background.withValues(alpha: .08),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.background.withValues(alpha: .88),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Place the full QR inside the frame',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildBookingResult(KickOffPalette colors) {
    final booking = _viewModel.scannedBooking!;
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: colors.line),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SportIcon(sport: booking.sport, size: 52),
              const SizedBox(height: 12),
              Text(
                booking.pitchName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${booking.sport} · ${booking.bookerName}',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.muted, fontSize: 12),
              ),
              const SizedBox(height: 17),
              _ResultRow(label: 'REFERENCE', value: booking.reference),
              _ResultRow(label: 'DATE', value: _formatDate(booking.date)),
              _ResultRow(label: 'TIME', value: booking.timeRange),
              _ResultRow(
                label: 'DURATION',
                value:
                    '${booking.durationHours} ${booking.durationHours == 1 ? 'hour' : 'hours'}',
              ),
              _ResultRow(label: 'TOTAL', value: 'EGP ${booking.totalPrice}'),
              const SizedBox(height: 8),
              Text(
                _viewModel.isCheckedIn
                    ? 'Check-in recorded locally · demo only'
                    : 'QR format recognized · booking not verified online',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.muted, fontSize: 11),
              ),
              const SizedBox(height: 17),
              if (!_viewModel.isCheckedIn)
                KickOffButton(
                  label: 'Mark as checked in · demo',
                  icon: Icons.how_to_reg_outlined,
                  onPressed: _viewModel.confirmCheckIn,
                ),
              const SizedBox(height: 9),
              TextButton.icon(
                onPressed: _scanAgain,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan another booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanError(KickOffPalette colors) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.qr_code_2, color: colors.muted, size: 42),
        const SizedBox(height: 12),
        Text(
          _viewModel.errorMessage ?? 'Could not read this QR code.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'Use a QR code generated by a Kick Off booking.',
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.muted, fontSize: 12),
        ),
        const SizedBox(height: 15),
        TextButton.icon(
          onPressed: _scanAgain,
          icon: const Icon(Icons.refresh),
          label: const Text('Try again'),
        ),
      ],
    ),
  );

  static String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = KickOffPalette.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: colors.muted,
                fontSize: 9,
                fontWeight: FontWeight.w900,
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
