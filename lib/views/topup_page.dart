import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopupPage extends StatefulWidget {
  const TopupPage({super.key});

  @override
  State<TopupPage> createState() => _TopupPageState();
}

class _TopupPageState extends State<TopupPage> {
  String? _selectedMethod = 'JazzCash';
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Current Balance: Rs. 250", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.h),

            TextField(
  controller: _amountController,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    labelText: "Amount",
    border: OutlineInputBorder(),
    prefixIcon: Padding(
      padding: EdgeInsets.all(12),
      child: Text(
        "PKR",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  ),
)
,

            SizedBox(height: 20.h),

            Text("Select Payment Method", style: TextStyle(fontSize: 16.sp)),
            SizedBox(height: 10.h),

            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    value: 'JazzCash',
                    groupValue: _selectedMethod,
                    title: const Text('JazzCash'),
                    onChanged: (value) {
                      setState(() => _selectedMethod = value);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    value: 'EasyPaisa',
                    groupValue: _selectedMethod,
                    title: const Text('EasyPaisa (Coming Soon)'),
                    onChanged: null, // Disabled
                  ),
                ),
              ],
            ),

            SizedBox(height: 30.h),

            SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      final amount = _amountController.text;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Top-up request: Rs. $amount via $_selectedMethod')),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.brown,
      side: const BorderSide(color: Colors.brown, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      padding: const EdgeInsets.symmetric(vertical: 16), // Optional: taller button
    ),
    child: const Text(
      "Top Up Now",
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
),

          ],
        ),
      ),
    );
  }
}
