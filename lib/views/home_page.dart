import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';
import 'package:next_gen_metro/views/history_page.dart';
import 'package:next_gen_metro/views/nfc_scan_page.dart';
import 'package:next_gen_metro/views/profile_page.dart';
import 'package:next_gen_metro/views/route_info_page.dart';
import 'package:next_gen_metro/views/topup_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    TopupPage(),
    NfcScanPage(),
    RouteInfoPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  final List<String> _titles = [
    "Top-up",
    "Scan NFC",
    "Route Info",
    "History",
    "Profile",
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top logo section
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

          SizedBox(height: 20.h),

          SizedBox(height: 20.h),

          // Active screen
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        selectedItemColor: darkBrown,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Top-up',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.nfc), label: 'NFC'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Routes'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
