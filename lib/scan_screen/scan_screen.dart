import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  late final MobileScannerController controller = MobileScannerController();
  StreamSubscription<BarcodeCapture>? _subscription;
  bool _hasScanned = false;
  bool _isFlashOn = false;
  bool _isFrontCamera = false;

  void _handleBarcode(BarcodeCapture capture) {
    if (_hasScanned) return; // Prevent multiple scans

    final List<Barcode> barcodes = capture.barcodes;

    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null) {
        setState(() => _hasScanned = true);

        // Show the scanned result
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scanned: $code'),
            duration: const Duration(seconds: 3),
          ),
        );

        // Optional: Navigate back or to another screen with the result
        // Navigator.pop(context, code);
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused
        _subscription?.cancel();
        _subscription = null;
        controller.stop();
        break;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed
        _subscription = controller.barcodes.listen(_handleBarcode);
        controller.start();
        break;
    }
  }

  Future<void> _toggleFlash() async {
    await controller.toggleTorch();
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
  }

  Future<void> _switchCamera() async {
    await controller.switchCamera();
    setState(() {
      _isFrontCamera = !_isFrontCamera;
    });
  }

  @override
  void initState() {
    super.initState();
    // Register as an observer for lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events
    _subscription = controller.barcodes.listen(_handleBarcode);

    // Start the scanner
    controller.start();
  }

  @override
  void dispose() {
    // Stop listening to lifecycle changes
    WidgetsBinding.instance.removeObserver(this);

    // Stop listening to the barcode events
    _subscription?.cancel();
    _subscription = null;

    // Dispose the controller
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        actions: [
          // Flash toggle button
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: _toggleFlash,
          ),
          // Camera switch button
          IconButton(
            icon: Icon(_isFrontCamera ? Icons.camera_front : Icons.camera_rear),
            onPressed: _switchCamera,
          ),
        ],
      ),
      body: Stack(
        children: [
          // The scanner
          MobileScanner(
            controller: controller,
            errorBuilder: (context, error, child) {
              String errorMessage;
              if (error.errorCode == MobileScannerErrorCode.permissionDenied) {
                errorMessage = 'Camera permission denied';
              } else {
                errorMessage = 'Scanner error: ${error.errorCode}';
              }

              return Center(
                child: Text(
                  'Error: $errorMessage',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            },
          ),
          // The overlay as a separate widget in the Stack
          CustomPaint(
            painter: ScannerOverlayPainter(
              borderColor: Colors.white,
              borderWidth: 3.0,
              borderRadius: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.7,
            ),
            child: const SizedBox.expand(),
          ),
          // Scan again button
          if (_hasScanned)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _hasScanned = false); // Reset scan state
                  },
                  child: const Text('Scan Again'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Custom painter for the scanner overlay
class ScannerOverlayPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double cutOutSize;

  ScannerOverlayPainter({
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.cutOutSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cutOutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: cutOutSize,
      height: cutOutSize,
    );

    // Draw semi-transparent background
    canvas.drawPath(
      Path()
        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
        ..addRRect(
          RRect.fromRectAndRadius(
            cutOutRect,
            Radius.circular(borderRadius),
          ),
        )
        ..fillType = PathFillType.evenOdd,
      Paint()
        ..color = Colors.black
            .withAlpha(127) // Using withAlpha instead of withOpacity
        ..style = PaintingStyle.fill,
    );

    // Draw border around cut-out
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        cutOutRect,
        Radius.circular(borderRadius),
      ),
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
