import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';
import 'package:next_gen_metro/utils/data/current_user_data.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = CurrentUserData.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: darkBrown,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image and Info Section
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.r,
                    spreadRadius: 2.r,
                  )
                ],
              ),
              child: Row(
                children: [
                  // Circular Profile Image
                  CircleAvatar(
                    radius: 40.r,
                    backgroundImage: user?.profilePicture != null
                        ? NetworkImage(user!.profilePicture!)
                        : const AssetImage('assets/secret.png') as ImageProvider,
                    backgroundColor: Colors.grey[200], // Light grey background for better contrast
                  ),
                  SizedBox(width: 15.w),
                  
                  // User Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.userName.toUpperCase() ?? "Guest User",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: darkBrown,
                            fontSize: 18.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          user?.userEmail ?? "No Email",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 25.h),

            // Account Details Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(18.w),
                child: Column(
                  children: [
                    _profileInfoTile(
                      icon: Icons.account_balance_wallet_rounded,
                      title: "Balance",
                      value: "Rs. ${user?.balance ?? 0}",
                    ),
                    Divider(thickness: 1, color: Colors.grey[300]),
                    _profileInfoTile(
                      icon: Icons.phone_rounded,
                      title: "Phone Number",
                      value: user?.phoneNumber ?? "N/A",
                    ),
                    Divider(thickness: 1, color: Colors.grey[300]),
                    _profileInfoTile(
                      icon: Icons.directions_bus_rounded,
                      title: "Last Route Used",
                      value: "N/A",
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Add Logout Functionality Here
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBrown,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Profile Info
  Widget _profileInfoTile({required IconData icon, required String title, required String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Icon(icon, color: darkBrown, size: 26.sp),
          SizedBox(width: 12.w),
          Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: darkBrown),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(fontSize: 16.sp, color: darkBrown),
          ),
        ],
      ),
    );
  }
}
