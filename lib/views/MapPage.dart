import 'package:flutter/material.dart';

import 'MenuNav.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuNav(),
      appBar: AppBar(title: Text('data'),),
      body: Column(
        children: [
          Container(
            child: UserAccountsDrawerHeader(
              accountName: Text('Uxama'),
              accountEmail: Text('im.uxama@gmail.com'),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    "assets/logo.png",
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xffa86326),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              style: TextStyle(
                color: Color(0xffa86326)   , // Set the text color
                fontSize: 16.0,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(width: 0.8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: Color(0xffa86326)), // Set the focused border color
                ),
                hintText: "Search Museum near-by you",
                hintStyle: TextStyle(color: Color(0xffa86326)),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xffa86326),
                  size: 30,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: Color(0xffa86326)),
                  onPressed: () {},
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
