import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';

class NfcScanPage extends StatefulWidget {
  const NfcScanPage({super.key});

  @override
  State<NfcScanPage> createState() => _NfcScanPageState();
}

class _NfcScanPageState extends State<NfcScanPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

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
    super.dispose();
  }

  void _onScanPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Scanning started...")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center( // Center the full column
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
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  "Tap your card to scan",
                  key: ValueKey<bool>(true),
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30.h),
              ElevatedButton.icon(
                onPressed: _onScanPressed,
                icon: const Icon(Icons.touch_app, color: Colors.white),
                label: Text(
                  "Start Scan",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Force white text
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
