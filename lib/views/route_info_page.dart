import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RouteInfoPage extends StatefulWidget {
  const RouteInfoPage({super.key});

  @override
  State<RouteInfoPage> createState() => _RouteInfoPageState();
}

class _RouteInfoPageState extends State<RouteInfoPage> {
  String selectedService = 'Metro';

  final Map<String, List<Map<String, dynamic>>> mockRoutes = {
    'Metro': [
      {
        'name': 'Route 1: Gajju Mata to Shahdara',
        'stops': [
          'Gajju Mata',
          'Model Town',
          'Qaddafi Stadium',
          'Shama',
          'MAO College',
          'Bhatti Chowk',
          'Timber Market',
          'Shahdara'
        ]
      },
      {
        'name': 'Route 2: Gajju Mata to Kalma Chowk',
        'stops': [
          'Gajju Mata',
          'Kahna',
          'Ichra',
          'Kalma Chowk',
        ]
      },
    ],
    'Speedo': [
      {
        'name': 'Route A: Railway Station to Samanabad',
        'stops': [
          'Railway Station',
          'Garhi Shahu',
          'Mozang',
          'Samanabad Mor',
        ]
      }
    ],
    'Orange': [
      {
        'name': 'Orange Train Line',
        'stops': [
          'Ali Town',
          'Thokar Niaz Baig',
          'Awan Town',
          'Gulshan-e-Ravi',
          'Samanabad',
          'Lakshmi Chowk',
          'McLeod Road',
          'Dera Gujran',
        ]
      }
    ]
  };

  @override
  Widget build(BuildContext context) {
    final routes = mockRoutes[selectedService]!;

    return Scaffold(
      appBar: AppBar(title: const Text("Route Information")),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Service", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            DropdownButtonFormField<String>(
              value: selectedService,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: ['Metro', 'Speedo', 'Orange'].map((service) {
                return DropdownMenuItem(value: service, child: Text(service));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedService = value);
                }
              },
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                itemCount: routes.length,
                itemBuilder: (context, index) {
                  final route = routes[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12.h),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(route['name'], style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                          SizedBox(height: 8.h),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 4.h,
                            children: (route['stops'] as List<String>).map((stop) {
                              return Chip(label: Text(stop));
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
