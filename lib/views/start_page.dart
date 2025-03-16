import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';
import 'package:next_gen_metro/views/sign_up_page.dart';

import '../utils/app_routes.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 330.h,
          child: Image.asset('assets/unlock.png'),
        ),
        SizedBox(
          height: 60.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 54.w),
          child: Text(
            "Unlock the Wonders of art with a tap.Your personal museum companion awaits",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: darkBrown,
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.loginPage);
          },
          style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                backgroundColor: MaterialStateProperty.all<Color>(lightBrown),
              ),
          child: Text(
            "Have an Account",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpPage()),
            );
          },
          style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
          child: Text(
            "Create Account",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: lightBrown,
            ),
          ),
        ),
      ],
    ));
  }
}
