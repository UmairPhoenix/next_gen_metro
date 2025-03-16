import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/view_model/nfc_view_model.dart';
import 'package:provider/provider.dart';

class NfcScanPage extends StatefulWidget {
  const NfcScanPage({super.key});

  @override
  State<NfcScanPage> createState() => _NfcScanPageState();
}

class _NfcScanPageState extends State<NfcScanPage> {
  @override
  Widget build(BuildContext context) {
    NfcViewModel nfcViewModel = Provider.of<NfcViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Scanner'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 250.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/nfc_tag.png'),
              ),
            ),
          ),
          SizedBox(height: 100.h),
          !nfcViewModel.isSearchingTag
              ? FilledButton(
                  onPressed: () {
                    nfcViewModel.startNfcSession(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text('Start Scanning'),
                  ),
                )
              : const CircularProgressIndicator(),
          SizedBox(height: 20.h),
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}
