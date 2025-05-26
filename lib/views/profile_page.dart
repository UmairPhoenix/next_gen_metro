import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';
import 'package:next_gen_metro/utils/data/current_user_data.dart';
import 'package:next_gen_metro/models/user_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = CurrentUserData.currentUser ?? UserModel(
      userName: 'Mock User',
      userEmail: 'mockuser@example.com',
      userId: 'mock123',
      phoneNumber: '03001234567',
      balance: 500.0,
      isAdmin: false,
    );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image + Info
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTajhS11aUm5pvBqz6IwpVHtnv5uUL9EGUuFw&usqp=CAU',
                  ),
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.userName.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: darkBrown,
                      ),
                    ),
                    Text(
                      user.userEmail,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 30.h),

            Text("Phone Number", style: _labelStyle()),
            SizedBox(height: 5.h),
            Text(user.phoneNumber, style: _valueStyle()),

            SizedBox(height: 20.h),

            Text("Role", style: _labelStyle()),
            SizedBox(height: 5.h),
            Text(user.isAdmin ? 'Admin' : 'User', style: _valueStyle()),

            SizedBox(height: 20.h),

            Text("Balance", style: _labelStyle()),
            SizedBox(height: 5.h),
            Text("Rs. ${user.balance.toStringAsFixed(0)}", style: _valueStyle()),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Sign out logic
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text("Sign Out", style: TextStyle(
                        color: Colors.white,
                      ),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBrown,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _labelStyle() {
    return TextStyle(fontSize: 14.sp, color: Colors.grey[600]);
  }

  TextStyle _valueStyle() {
    return TextStyle(fontSize: 16.sp, color: Colors.black87);
  }
}
