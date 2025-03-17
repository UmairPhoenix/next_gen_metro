import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';
import '../utils/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 180.h,
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
                child: Image.asset(
                  "assets/NextGen.png",
                  // color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "Welcome to NextGen Metro",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16.w),
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              children: [
                _dashboardTile(
                  context,
                  icon: Icons.credit_card,
                  label: "Top-up",
                  route: Routes.topupPage,
                ),
                _dashboardTile(
                  context,
                  icon: Icons.nfc,
                  label: "Scan NFC",
                  route: Routes.nfcScanPage,
                ),
                _dashboardTile(
                  context,
                  icon: Icons.map,
                  label: "Route Info",
                  route: Routes.routeInfoPage,
                ),
                _dashboardTile(
                  context,
                  icon: Icons.history,
                  label: "History",
                  route: Routes.historyPage,
                ),
                _dashboardTile(
                  context,
                  icon: Icons.account_circle,
                  label: "Profile",
                  route: Routes.profilePage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashboardTile(BuildContext context, {required IconData icon, required String label, required String route}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: darkBrown,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.sp, color: Colors.white),
            SizedBox(height: 10.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
