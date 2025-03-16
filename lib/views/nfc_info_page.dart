import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_routes.dart';

class NfcInfoPage extends StatefulWidget {
  const NfcInfoPage({super.key});

  @override
  State<NfcInfoPage> createState() => _NfcInfoPageState();
}

class _NfcInfoPageState extends State<NfcInfoPage> {
  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artifact Information'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80.h),
            Container(
              height: 250.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/nfc_tag2.png'),
                ),
              ),
            ),
            SizedBox(height: 50.h),
            const Text('Scan Successful'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Text(
                
                arguments['tagData'].toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Text('Tag id: ${arguments['tagId'].toString()}'),
            SizedBox(height: 30.h),
            FilledButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.contentPage);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text('More Information'),
              ),
            ),
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
      ),
    );
  }
}
