import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_theme_data.dart';

class ImageStartPage extends StatefulWidget {
  const ImageStartPage({super.key});

  @override
  State<ImageStartPage> createState() => _ImageStartPageState();
}

class _ImageStartPageState extends State<ImageStartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Content'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h, width: double.infinity),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              'Be prepared to visually experience captivating content as you are about to witness a collection of compelling images.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkBrown,
              ),
            ),
          ),
          Expanded(
            child: Image.asset(
              'assets/image_ils.png',
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {},
            child: const Text('More Information'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}