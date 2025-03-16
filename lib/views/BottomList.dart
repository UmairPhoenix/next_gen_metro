// import 'package:flutter/material.dart';
// import 'package:museum_mate/LoginPage.dart';
// import 'package:museum_mate/MapPage.dart';
// import 'package:museum_mate/MenuNav.dart';
// import 'package:museum_mate/NfcTag.dart';
// import 'package:museum_mate/UnlockPage.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _Home_logState();
// }

// class _Home_logState extends State<HomePage> {
//   int currentIndex = 0;

//   List pages = [
//     HomePage(),
//     MapPage(),
//     NfcScanner(),
//     LoginPage(),
//   ];

//   // final screen = [
//   //   Center(
//   //       child: Text(
//   //         "Map",
//   //         style: TextStyle(fontSize: 60),
//   //       ),
//   //     ),
//   //     Center(
//   //       child: Text(
//   //         "Scanner",
//   //         style: TextStyle(fontSize: 60),
//   //       ),
//   //     ),
//   //     Center(
//   //       child: Text(
//   //         "Setting",
//   //         style: TextStyle(fontSize: 60),
//   //       ),
//   //     ),
//   // ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: pages[0],

//       bottomNavigationBar: BottomNavigationBar(
//         // type: BottomNavigationBarType.shifting,
//         iconSize: 30,
//         // showSelectedLabels: false,
//         currentIndex: currentIndex,
//         onTap: (int index) {
//           setState(() {
//             currentIndex = index;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(

//             icon: Icon(Icons.map, color: Color(0xffa86326)),
            
//             label: "Map",
//             backgroundColor: Color(0xffa86326),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.scanner, color: Color(0xffa86326)),
//             label: "Scanner",
//             backgroundColor: Color(0xffa86326),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings, color: Color(0xffa86326)),
//             label: "Setiing",
//             backgroundColor: Color(0xffa86326),
//           ),
//         ],
//       ),
//     );
//   }
// }


//   Widget _buildPage(int index) {
//     switch (index) {
//       case 0:
//         return MapPage();
//       case 1:
//         return NfcScanner();
//       case 2:
//         return LoginPage();
//       default:
//         return Container();
//     }
//   }


