import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    _ManageRoutesPage(),
    _ManageUsersPage(),
  ];

  final List<String> _titles = [
    "Manage Routes",
    "Manage Users",
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 180.h,
            decoration: BoxDecoration(
              color: darkBrown,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Center(
              child: Text(
                'N',
                style: TextStyle(
                  fontSize: 64.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        selectedItemColor: darkBrown,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_location_alt),
            label: 'Routes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_remove),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}

class _ManageRoutesPage extends StatefulWidget {
  const _ManageRoutesPage();

  @override
  State<_ManageRoutesPage> createState() => _ManageRoutesPageState();
}

class _ManageRoutesPageState extends State<_ManageRoutesPage> {
  final TextEditingController routeController = TextEditingController();
  final List<String> routes = ["Metro Station A", "Orange Line B", "Speedo C"];

  @override
  void dispose() {
    routeController.dispose();
    super.dispose();
  }

  void addRoute() {
    final text = routeController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        routes.add(text);
        routeController.clear();
      });
    }
  }

  void deleteRoute(int index) {
    setState(() {
      routes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add New Route", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: routeController,
                  decoration: const InputDecoration(hintText: "Enter route name"),
                ),
              ),
              SizedBox(width: 10.w),
              ElevatedButton(
                onPressed: addRoute,
                style: ElevatedButton.styleFrom(backgroundColor: darkBrown),
                child: const Text("Add", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text("Existing Routes", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
          Expanded(
            child: ListView.builder(
              itemCount: routes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(routes[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteRoute(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ManageUsersPage extends StatefulWidget {
  const _ManageUsersPage();

  @override
  State<_ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<_ManageUsersPage> {
  final List<Map<String, String>> users = [
    {"name": "Ali", "email": "ali@example.com"},
    {"name": "Sara", "email": "sara@example.com"},
    {"name": "Ahmed", "email": "ahmed@example.com"},
  ];

  void deleteUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Registered Users", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index]['name']!),
                  subtitle: Text(users[index]['email']!),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteUser(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
