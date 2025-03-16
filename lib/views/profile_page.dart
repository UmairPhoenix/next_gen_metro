import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';
import 'package:next_gen_metro/utils/data/current_user_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 30.w),
              const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTajhS11aUm5pvBqz6IwpVHtnv5uUL9EGUuFw&usqp=CAU',
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CurrentUserData.currentUser!.userName.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: darkBrown,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    CurrentUserData.currentUser!.userEmail,
                    style: TextStyle(
                      color: darkBrown,
                      fontSize: 12,
                    ),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
