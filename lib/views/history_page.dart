import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  final List<Map<String, dynamic>> mockTrips = const [
    {
      'service': 'Metro',
      'entry': 'Gajju Mata',
      'exit': 'Kalma Chowk',
      'fare': 30,
      'date': 'May 25, 2025',
      'time': '8:15 AM',
    },
    {
      'service': 'Orange',
      'entry': 'Ali Town',
      'exit': 'Dera Gujran',
      'fare': 40,
      'date': 'May 24, 2025',
      'time': '5:45 PM',
    },
    {
      'service': 'Speedo',
      'entry': 'Railway Station',
      'exit': 'Samanabad Mor',
      'fare': 25,
      'date': 'May 23, 2025',
      'time': '3:30 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trip History")),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView.separated(
          itemCount: mockTrips.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final trip = mockTrips[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${trip['service']} Trip",
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6.h),
                    Text("From: ${trip['entry']}"),
                    Text("To: ${trip['exit']}"),
                    SizedBox(height: 6.h),
                    Text("Fare: Rs. ${trip['fare']}"),
                    Text("Date: ${trip['date']}"),
                    Text("Time: ${trip['time']}"),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
