import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_routes.dart';
import '../utils/app_theme_data.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  List<String> tilesIcon = [
    'assets/text_icon.png',
    'assets/image_icon.png',
    'assets/video_icon.png',
  ];

  List<String> tilesText = [
    'Text',
    'Image',
    'Video',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffA68F7B),
      appBar: AppBar(
        title: const Text(
          'Artifact Content',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          infoTiles(
            index: 0,
            onTap: () {
              Navigator.pushNamed(context, Routes.textStartPage);
            },
          ),
          infoTiles(
              index: 1,
              onTap: () {
                Navigator.pushNamed(context, Routes.imageStartPage);
              }),
        ],
      ),
    );
  }

  Widget infoTiles({required int index, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
              color: lightBrown,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Image.asset(tilesIcon[index]),
              SizedBox(width: 100.w),
              Text(
                tilesText[index],
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
