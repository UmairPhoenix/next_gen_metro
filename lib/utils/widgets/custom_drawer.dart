import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';
import 'package:next_gen_metro/utils/data/current_user_data.dart';

import '../app_routes.dart';

Widget drawer(BuildContext context) {
  return Drawer(
    child: Padding(
      padding: const EdgeInsets.all(35.0),
      child: ListView(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTajhS11aUm5pvBqz6IwpVHtnv5uUL9EGUuFw&usqp=CAU'),
              ),
              const SizedBox(width: 20),
              Text(
                CurrentUserData.currentUser!.userName.toUpperCase(),
                style: TextStyle(
                  fontSize: 23.sp,
                  fontWeight: FontWeight.bold,
                  color: lightBrown,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          drawerItem(
            context,
            title: 'Home',
            onTap: () {},
          ),
          drawerItem(
            context,
            title: 'Settings',
            onTap: () {},
          ),
          drawerItem(
            context,
            title: 'Profile',
            onTap: () {
              Navigator.pushNamed(context, Routes.profilePage);
            },
          ),
        ],
      ),
    ),
  );
}

Widget drawerItem(BuildContext context,
    {Function()? onTap, required String title}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: lightBrown,
        ),
      ),
      height: 40,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: lightBrown),
          ),
        ),
      ),
    ),
  );
}
