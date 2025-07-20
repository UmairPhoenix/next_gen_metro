import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';
import 'package:next_gen_metro/services/api_service.dart';
import 'package:next_gen_metro/utils/app_routes.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    NfcManager.instance.stopSession();
    super.dispose();
  }

  Future<void> _startScan() async {
    if (_isScanning) return;

    setState(() => _isScanning = true);

    final selectedService = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Select Service"),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, "Metro"),
            child: const Text("Metro"),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, "Speedo"),
            child: const Text("Speedo"),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, "Orange"),
            child: const Text("Orange"),
          ),
        ],
      ),
    );

    if (selectedService == null) {
      setState(() => _isScanning = false);
      return;
    }

    final user = CurrentUserData.currentUser;
    if (user == null) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, Routes.loginPage);
      return;
    }

    try {
      final isAvailable = await NfcManager.instance.isAvailable();
      if (!isAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("NFC is not available on this device.")),
        );
        setState(() => _isScanning = false);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please tap an NFC card...")),
      );

      await NfcManager.instance.startSession(
        pollingOptions: {NfcPollingOption.iso14443},
        noPlatformSoundsAndroid: true,
        alertMessageIos: "Hold your device near the NFC card",
        invalidateAfterFirstReadIos: true,
        onSessionErrorIos: (error) {
          debugPrint("iOS NFC error: $error");
        },
        onDiscovered: (NfcTag tag) async {
  try {
    debugPrint("Tag Discovered: $tag");

    String uid;

    if (tag.data is Map<String, dynamic>) {
      final data = tag.data as Map<String, dynamic>;
      final tech = data['nfca'] ?? data['NfcA'];
      if (tech != null && tech is Map<String, dynamic> && tech['identifier'] is List) {
        final identifierBytes = tech['identifier'] as List;
        uid = identifierBytes
            .cast<int>()
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join('')
            .toUpperCase();
      } else {
        debugPrint("Identifier not found in tag. Using fallback ID.");
        uid = user.id.toString();
      }
    } else {
      debugPrint("Unknown tag type: ${tag.data.runtimeType}. Using fallback ID.");
      uid = user.id.toString();
    }

    final response = await ApiService.scanCard(
      uid: uid,
      service: selectedService,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Scan complete.')),
      );
    }
  } catch (e) {
    debugPrint("Unexpected Scan Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Scan failed. Using fallback ID.")),
    );
  } finally {
    await NfcManager.instance.stopSession();
    if (mounted) setState(() => _isScanning = false);
  }
}

      );
    } catch (e) {
      await NfcManager.instance.stopSession();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      setState(() => _isScanning = false);
    }
  }

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
              Tooltip(
                message: "NFC Ready",
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Icon(
                    Icons.nfc,
                    size: 100.sp,
                    color: darkBrown,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                _isScanning
                    ? "Scanning... Tap your NFC tag"
                    : "Tap to scan NFC card",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30.h),
              ElevatedButton.icon(
                onPressed: _startScan,
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
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
