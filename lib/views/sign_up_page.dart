import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/views/home_page.dart';
import '../utils/app_theme_data.dart';
import '../utils/widgets/custom_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  //-------------------------------------------------------------------------
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool obscurePassword = true;

  final formKey = GlobalKey<FormState>();
  //-------------------------------------------------------------------------

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                  'assets/NextGen.png',
                  // color: lightBrown,
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: customTextField(
                  controller: userNameController,
                  hintText: 'Username',
                  prefixIcon: Icon(
                    Icons.person,
                    color: lightBrown,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: customTextField(
                  controller: emailController,
                  hintText: 'Email',
                  prefixIcon: Icon(
                    Icons.mail,
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
              SizedBox(height: 20.h),
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
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: customTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  prefixIcon: Icon(
                    Icons.lock,
                    color: lightBrown,
                  ),
                  obscureText: obscurePassword,
                ),
              ),
              SizedBox(height: 50.h),
              ElevatedButton(
                onPressed: () {
                  // if (formKey.currentState!.validate()) {
                  //   if (passwordController.text != confirmPasswordController.text) {
                  //     // Handle password mismatch
                  //   } else {
                  //     // Handle successful validation
                  //   }
                  // }
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
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
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
