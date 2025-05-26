import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';

import '../utils/app_routes.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: 280.h,
          decoration: BoxDecoration(
            color: darkBrown,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Center(
              child: SizedBox(
                height: 100.h,
                child: Text(
                  'N',
                  style: TextStyle(
                    fontSize: 64.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        SizedBox(
          height: 320.h,
          width: double.infinity,
          child: Image.asset(
            'assets/secret.png',
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            color: darkBrown,
            child: Column(
              children: [
                SizedBox(
                  height: 35.h,
                ),
                Text(
                  "Next Gen Expierience in Transport",
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.startPage);
                  },
                  child: Text(
                    "Get started",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: darkBrown,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }
}
