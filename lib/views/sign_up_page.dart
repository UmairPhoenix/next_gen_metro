import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_theme_data.dart';
import '../utils/widgets/custom_text_field.dart';
import '../services/api_service.dart'; // <-- Make sure this points to your ApiService file

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //------------------------------------------------------------------------
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  final formKey = GlobalKey<FormState>();
  //------------------------------------------------------------------------

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    final name = userNameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;

    try {
      final response = await ApiService.signup(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      if (response.containsKey('token')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account created successfully!')),
        );
        Navigator.pop(context); // Go back to login or previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Signup failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
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
              SizedBox(height: 20.h),
              Text(
                "Create your account",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: lightBrown,
                ),
              ),
              SizedBox(height: 20.h),

              // Username
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: customTextField(
                  controller: userNameController,
                  hintText: 'Username',
                  prefixIcon: Icon(Icons.person, color: lightBrown),
                ),
              ),
              SizedBox(height: 20.h),

              // Email
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: customTextField(
                  controller: emailController,
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.mail, color: lightBrown),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email can\'t be empty';
                    }
                    bool isValidEmail = RegExp(
                      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value);
                    if (!isValidEmail) {
                      return 'Email format is not correct';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20.h),

              // Phone
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: customTextField(
                  controller: phoneController,
                  hintText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone, color: lightBrown),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number can\'t be empty';
                    }
                    if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                      return 'Invalid phone number';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20.h),

              // Password
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
              SizedBox(height: 20.h),

              // Confirm Password
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: customTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock, color: lightBrown),
                  obscureText: obscurePassword,
                ),
              ),
              SizedBox(height: 50.h),

              // Sign-up Button
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (passwordController.text != confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Passwords do not match')),
                      );
                    } else {
                      signUp();
                    }
                  }
                },
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                      backgroundColor: MaterialStateProperty.all<Color>(lightBrown),
                    ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Text(
                    "Sign-up",
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Cancel Button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: lightBrown,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
