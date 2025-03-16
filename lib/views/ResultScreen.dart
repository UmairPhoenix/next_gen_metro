import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ResultScreen extends StatelessWidget {
  final String code;
  final Function() closeScreen;

  const ResultScreen(
      {super.key, required this.closeScreen, required this.code});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
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
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // QrImage(),
            Text(
              "NFC Scanned Result",
              style: TextStyle(
                  fontSize: 20,
                  color: Color(
                    0xffa86326,
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              code,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: Color(
                    0xffa86326,
                  )),
            ),
            SizedBox(
              height: 10,
            ),

            ElevatedButton(
              // style: ElevatedButton.styleFrom(
              //   backgroundColor: Colors.white)
              // ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text:  code));
              },
              child: const Text(
                "Copy",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(
                    0xffa86326,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
