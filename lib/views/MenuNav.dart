import 'package:flutter/material.dart';

class MenuNav extends StatelessWidget {
  const MenuNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Uxama'),
            accountEmail: Text('im.uxama@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  "assets/logo.png",
                  width: 90,
                  height: 90,
                  // fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(
                color: Color(
              0xffa86326,
            )
                //   image: DecorationImage(
                //     image: NetworkImage(
                //      'https://th.bing.com/th/id/OIG.q279sCi3U4cSnza0YYiZ?pid=ImgGn' ),
                // fit: BoxFit.cover,
                //   )
                ),
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: Color(0xffa86326)),
            title: Text('Favourite',  style: TextStyle(fontSize: 18, color: Color(0xffa86326))),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.people, color: Color(0xffa86326)),
            title: Text('Friends', style: TextStyle(fontSize: 18, color: Color(0xffa86326)) ),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.share, color: Color(0xffa86326)),
            title: Text('Share', style: TextStyle(fontSize: 18, color: Color(0xffa86326))),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.notification_add, color: Color(0xffa86326)),
            title: Text('Request', style: TextStyle(fontSize: 18, color: Color(0xffa86326))),
            onTap: () => null,
            trailing: ClipOval(
              child: Container(
                color: Colors.red,
                width: 20,
                height: 20,
                child: Center(
                    child: Text(
                  "8",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Color(0xffa86326)),
            title: Text('Setting', style: TextStyle(fontSize: 18, color: Color(0xffa86326))),
            onTap: () => null,
          ),
        ],
      ),
    );
  }
}
