import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';

import '../utils/app_routes.dart';

class NextGenMetroInfoPage extends StatefulWidget {
  const NextGenMetroInfoPage({super.key});

  @override
  State<NextGenMetroInfoPage> createState() => _NextGenMetroInfoPageState();
}

class _NextGenMetroInfoPageState extends State<NextGenMetroInfoPage> {
  List<String> tilesIcon = [
    'assets/time_icon.png',
    'assets/calender_icon.png',
    'assets/ticket_icon.png',
    'assets/train_icon.png',
    'assets/stations_icon.png'
  ];

  List<String> tilesText = [
    '06:00 AM to 11:00 PM',
    'Monday - Sunday',
    'Standard Fare: \$2.50',
    'Metro Service',
    '20+ Stations'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NextGen Metro Info',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  infoTiles(index: index),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Divider(color: darkBrown),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text('Back'),
                ),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.nfcScanPage);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text('Next'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget infoTiles({required int index}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Image.asset(tilesIcon[index]),
          SizedBox(width: 50.w),
          Text(
            tilesText[index],
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
    );
  }
}
