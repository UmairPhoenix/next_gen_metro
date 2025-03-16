import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';

class TextStartPage extends StatefulWidget {
  const TextStartPage({super.key});

  @override
  State<TextStartPage> createState() => _TextStartPageState();
}

class _TextStartPageState extends State<TextStartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Content'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h, width: double.infinity),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              'Get ready to dive into the realm of written words as you embarked on the journey of exploring the text content that lies ahead.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkBrown,
              ),
            ),
          ),
          Expanded(
            child: Image.asset(
              'assets/text.png',
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
