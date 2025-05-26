import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';
import 'package:next_gen_metro/utils/widgets/custom_text_field.dart';
import '../utils/app_routes.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void handleAdminLogin() {
  if (formKey.currentState!.validate()) {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email == 'admin@metro.com' && password == 'admin123') {
      Navigator.pushReplacementNamed(context, Routes.adminDashboard);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid admin credentials")),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 80.h),
              SizedBox(
                height: 150.h,
                child: Center(
                  child: Text(
                    'N',
                    style: TextStyle(
                      fontSize: 64.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: customTextField(
                  controller: emailController,
                  hintText: 'Admin Email',
                  prefixIcon: Icon(Icons.admin_panel_settings, color: lightBrown),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email can\'t be empty';
                    }
                    bool isValidEmail = RegExp(
                      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                    ).hasMatch(value);
                    if (!isValidEmail) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 45.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: customTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: lightBrown),
                  obscureText: obscurePassword,
                  ontapSufixIcon: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 180.w),
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(lightBrown),
                  ),
                  onPressed: () {
                    // TODO: forgot password logic (optional)
                  },
                  child: const Text("Forgot Password?"),
                ),
              ),
              SizedBox(height: 85.h),
              ElevatedButton(
                onPressed: handleAdminLogin,
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                  backgroundColor: MaterialStateProperty.all<Color>(lightBrown),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Text(
                    "Admin Login",
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Admin access only",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
