import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';

class NfcScanPage extends StatelessWidget {
  const NfcScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NFC Scan"),
        backgroundColor: darkBrown,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.nfc,
                  size: 100.sp,
                  color: darkBrown,
                ),
                SizedBox(height: 20.h),
                Text(
                  "Tap your card to scan",
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30.h),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement NFC scanning logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBrown,
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: Text(
                    "Start Scan",
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}