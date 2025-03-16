import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:next_gen_metro/views/MenuNav.dart';

class NfcScanner extends StatelessWidget {
  const NfcScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuNav(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "NFC Scanner",
          style: TextStyle(
              fontSize: 20,
              color: Color(
                0xffa86326,
              )),
        ),
      ),
      body: Column(
        children: [
          Image.asset('assets/NFC.png',  height: 500),
          // SizedBox(
          //   height: 10,
          // ),
          ElevatedButton(
            onPressed: () {
              // Navigator.pop(context, LoginPage());
            },
            child: Text(
              "Get Started",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              backgroundColor: Color(0xffa86326),
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 70),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              "Cancel",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff593622),
              ),
            ),
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            ),
          )
        ],
      ),
    );
  }
}
