import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/global_variables.dart';

import '../utils/app_routes.dart';

class MuseumWelcomePage extends StatefulWidget {
  const MuseumWelcomePage({super.key});

  @override
  State<MuseumWelcomePage> createState() => _MuseumWelcomePageState();
}

class _MuseumWelcomePageState extends State<MuseumWelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
            child: const Text(
              welcomText,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10.h),
          Image.asset('assets/museum_image.png'),
          FilledButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.homePage);
            },
            child: const Text('More Information'),
          ),
        ],
      ),
    );
  }
}
