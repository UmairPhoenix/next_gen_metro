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
          SizedBox(height: 60.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 54.w),
            child: Text(
              "Tap in to travel smarter. Your digital metro companion is ready.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: darkBrown),
            ),
          ),
          SizedBox(height: 20.h),

          // Login button
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

          SizedBox(height: 10.h),

          // Sign up button
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

          SizedBox(height: 10.h),

          // Admin login button
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.adminLoginPage);
            },
            child: Text(
              "Admin Login",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: darkBrown,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
