import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nfc_manager/nfc_manager.dart';

import 'package:next_gen_metro/services/api_service.dart';
import 'package:next_gen_metro/utils/app_routes.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';
import 'package:next_gen_metro/utils/data/current_user_data.dart';

class NfcScanPage extends StatefulWidget {
  const NfcScanPage({super.key});

  @override
  State<NfcScanPage> createState() => _NfcScanPageState();
}

class _NfcScanPageState extends State<NfcScanPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isScanning = false;
  bool _handledTag = false; // prevent duplicate onDiscovered callbacks
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _controller.dispose();
    // Best-effort stop; safe even if no session.
    NfcManager.instance.stopSession();
    super.dispose();
  }

  // ---------- UI Helpers ----------

  Future<void> _showSnack(String msg) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<String?> _showServicePicker() async {
    if (!mounted) return null;
    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        Widget tile(IconData icon, String label, String value, Color color) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pop(ctx, value),
          );
        }

        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 4.h),
              Text("Select Service",
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800)),
              SizedBox(height: 6.h),
              tile(Icons.train, "Metro", "Metro", Colors.blueGrey.shade700),
              tile(Icons.directions_bus, "Speedo", "Speedo", Colors.teal.shade700),
              tile(Icons.tram, "Orange", "Orange", Colors.deepOrange.shade700),
              SizedBox(height: 6.h),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showResultDialog({
    required bool success,
    required String title,
    required String message,
  }) async {
    if (!mounted) return;
    await showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      barrierLabel: 'Result',
      barrierDismissible: true,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 240),
      transitionBuilder: (_, anim, __, ___) {
        final scale = Tween<double>(begin: 0.9, end: 1.0).animate(
          CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
        );
        return Transform.scale(
          scale: scale.value,
          child: Opacity(
            opacity: anim.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              title: Row(
                children: [
                  Icon(
                    success ? Icons.check_circle_rounded : Icons.error_rounded,
                    color: success ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showScanningSheet() async {
    if (!mounted) return;
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Icon(Icons.nfc, size: 60.sp, color: darkBrown),
              ),
              SizedBox(height: 12.h),
              Text("Scanning…",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
              SizedBox(height: 6.h),
              const Text(
                "Hold your device near the NFC card.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 14.h),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _cancelScan,
                icon: const Icon(Icons.close),
                label: const Text("Cancel"),
              ),
              SizedBox(height: 6.h),
            ],
          ),
        );
      },
    );
  }

  // ---------- NFC + API Flow ----------

  /// Start scanning flow:
  /// - Check login
  /// - Pick service
  /// - Ensure NFC available
  /// - Start session, show scanning sheet, guard duplicate reads
  Future<void> _startScan() async {
    if (_isScanning) return;

    // Logged-in user required
    final user = CurrentUserData.currentUser;
    if (user == null) {
      if (!mounted) return;
      await _showResultDialog(
        success: false,
        title: "Login Required",
        message: "Please log in to continue.",
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, Routes.loginPage);
      return;
    }

    // Choose service
    final selectedService = await _showServicePicker();
    if (selectedService == null) return;

    // NFC availability
    final available = await NfcManager.instance.isAvailable();
    if (!available) {
      await _showResultDialog(
        success: false,
        title: "NFC Unavailable",
        message: Platform.isIOS
            ? "NFC is not available or is disabled on this iOS device."
            : "NFC is not available or is disabled on this device.",
      );
      return;
    }

    setState(() {
      _isScanning = true;
      _handledTag = false;
    });

    // Show scanning bottom sheet
    await _showScanningSheet();

    // Safety timeout (e.g., 20s)
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 20), () async {
      if (!_handledTag) {
        await _showSnack("Scan timed out. Try again.");
        await _endSession();
      }
    });

    try {
  // Light haptic hint (ignore errors)
  await HapticFeedback.lightImpact();

  // Ensure we only handle one tag per session
  _handledTag = false;

  await NfcManager.instance.startSession(
    // Discover common transit cards (MIFARE/NTAG, etc.)
    pollingOptions: { NfcPollingOption.iso14443 },

    // iOS-only helpers
    alertMessageIos: "Hold your iPhone near the NFC card",
    invalidateAfterFirstReadIos: true,
    onSessionErrorIos: (error) {
      debugPrint("iOS NFC error: $error");
    },

    // Android-only: mute system beep, we provide our own haptics/UI
    noPlatformSoundsAndroid: true,

    // Called when a tag is found
    onDiscovered: (NfcTag tag) async {
      if (_handledTag) return;
      _handledTag = true;

      try {
        final uid = _extractUid(tag) ?? user.id.toString(); // robust UID + fallback
        await HapticFeedback.selectionClick();

        // Call API with timeout so we don't hang the session forever
        final response = await ApiService.scanCard(
          uid: uid,
          service: selectedService,
        ).timeout(const Duration(seconds: 12));

        final msg = (response['message'] ?? 'Scan complete.').toString();
        if (!mounted) return;
        await _showResultDialog(success: true, title: "Success", message: msg);
      } on TimeoutException {
        if (!mounted) return;
        await _showResultDialog(
          success: false,
          title: "Scan Failed",
          message: "The server didn’t respond in time. Please try again.",
        );
      } catch (e) {
        if (!mounted) return;
        await _showResultDialog(
          success: false,
          title: "Scan Failed",
          message: e.toString(),
        );
      } finally {
        // Always end session (safe on iOS, required on Android)
        await _endSession();
      }
    },
  );
} catch (e) {
      // startSession threw
      await _endSession();
      await _showResultDialog(
        success: false,
        title: "NFC Error",
        message: e.toString(),
      );
    }
  }

  Future<void> _cancelScan() async {
    // User pressed cancel in the scanning sheet
    await _endSession();
    await _showSnack("Scan cancelled.");
  }

  Future<void> _endSession() async {
    _timeoutTimer?.cancel();
    // Close sheet/dialog if open
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop(); // close scanning sheet if visible
    }
    try {
      await NfcManager.instance.stopSession();
    } catch (_) {}
    if (mounted) {
      setState(() => _isScanning = false);
    }
  }

  /// Extract UID in a robust cross‑platform way.
  /// Tries common shapes for Android & iOS:
  /// - data['nfca'] / data['NfcA'] / data['mifareclassic'] / data['mifareultralight']
  /// - common fields: 'identifier', 'id'
  /// Falls back to null if nothing found.
  String? _extractUid(NfcTag tag) {
    try {
      final raw = tag.data;
      if (raw is! Map) return null;
      final data = raw.cast<String, dynamic>();

      // Direct known keys:
      final candidateTechs = [
        'nfca',
        'NfcA',
        'mifareclassic',
        'MifareClassic',
        'mifareultralight',
        'MifareUltralight',
        'ntag',
        'Ndef',
        'IsoDep',
        'felica',
        'Felica',
        'Iso7816',
      ];

      // Try commonly used properties at the root first
      final rootId = _hexFromAny(data['identifier']) ?? _hexFromAny(data['id']);
      if (rootId != null && rootId.isNotEmpty) return rootId.toUpperCase();

      // Try tech maps
      for (final key in candidateTechs) {
        final tech = data[key];
        if (tech is Map) {
          final hex = _hexFromAny(tech['identifier']) ?? _hexFromAny(tech['id']);
          if (hex != null && hex.isNotEmpty) return hex.toUpperCase();
        }
      }

      // Some Android devices put id in data['tag']['id']
      final tagMap = data['tag'];
      if (tagMap is Map) {
        final hex = _hexFromAny(tagMap['id']);
        if (hex != null && hex.isNotEmpty) return hex.toUpperCase();
      }

      // Nothing found
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Convert dynamic to hex string if it's a byte list/Uint8List.
  String? _hexFromAny(dynamic v) {
    if (v == null) return null;
    Iterable<int>? bytes;
    if (v is Uint8List) {
      bytes = v;
    } else if (v is List) {
      // dynamic list -> cast if possible
      try {
        bytes = v.cast<int>();
      } catch (_) {
        // In some cases list may be List<num>
        bytes = v.map((e) => (e as num).toInt());
      }
    }
    if (bytes == null) return null;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return hex;
  }

  // ---------- Build ----------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pulsing NFC icon
              Tooltip(
                message: _isScanning ? "Scanning…" : "NFC Ready",
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: darkBrown.withOpacity(0.2),
                          blurRadius: 18,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 56.r,
                      backgroundColor: darkBrown.withOpacity(0.08),
                      child: Icon(
                        Icons.nfc_rounded,
                        size: 72.sp,
                        color: darkBrown,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                _isScanning ? "Scanning… Hold near the card" : "Tap to scan NFC card",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                _isScanning
                    ? "We’ll stop automatically after 20 seconds."
                    : "You’ll be asked to choose a service first.",
                style: TextStyle(color: Colors.black54, fontSize: 12.sp),
              ),
              SizedBox(height: 26.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isScanning ? null : _startScan,
                    icon: const Icon(Icons.nfc, color: Colors.white),
                    label: Text(
                      _isScanning ? "Scanning..." : "Start Scan",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkBrown,
                      padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      elevation: 4,
                    ),
                  ),
                  if (_isScanning) ...[
                    SizedBox(width: 10.w),
                    OutlinedButton.icon(
                      onPressed: _cancelScan,
                      icon: const Icon(Icons.close),
                      label: const Text("Cancel"),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
