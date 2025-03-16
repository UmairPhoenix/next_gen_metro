import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';
import 'package:next_gen_metro/utils/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //-------------------------------------------------------------------------
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  final formKey = GlobalKey<FormState>();
  //-------------------------------------------------------------------------

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                child: Image.asset(
                  'assets/logo.png',
                  color: lightBrown,
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: customTextField(
                  controller: emailController,
                  hintText: 'Email',
                  prefixIcon: Icon(
                    Icons.person,
                    color: lightBrown,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email can\'t be empty';
                    }
                    bool isValidEmail = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value);
                    if (!isValidEmail) {
                      return 'Email format is not correct';
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
                  prefixIcon: Icon(
                    Icons.lock,
                    color: lightBrown,
                  ),
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
                  onPressed: () {},
                  child: const Text("Forgot Password?"),
                ),
              ),
              SizedBox(height: 85.h),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Handle successful validation
                  }
                },
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                  backgroundColor: MaterialStateProperty.all<Color>(lightBrown),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Don't have an account?",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: darkBrown,
                ),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {}, // Removed navigation to signup page
                style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Text(
                    "Sign-up",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: lightBrown,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
