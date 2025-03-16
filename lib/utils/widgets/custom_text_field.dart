import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_gen_metro/utils/app_theme_data.dart';

Widget customTextField({
  required TextEditingController controller,
  required String hintText,
  required Icon prefixIcon,
  FocusNode? focusNode,
  String? Function(String?)? validator,
  Function()? ontapSufixIcon,
  bool? obscureText,
  TextInputType? keyBoardType,
  bool? isEnabled,
}) {
  return TextFormField(
    enabled: isEnabled ?? true,
    controller: controller,
    obscureText: obscureText ?? false,
    keyboardType: keyBoardType,
    validator: validator ??
        (value) {
          if (value == null || value.isEmpty) {
            return 'This field can\'t be empty';
          }
          return null;
        },
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: darkBrown, fontSize: 16.sp),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: darkBrown),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: lightBrown,
          width: 2,
        ),
      ),
      prefixIcon: SizedBox(
        width: 50.w,
        child: Row(
          children: [
            prefixIcon,
            SizedBox(width: 10.w),
            Container(
              height: 30,
              width: 2,
              color: lightBrown,
            )
          ],
        ),
      ),
      suffixIcon: ontapSufixIcon == null
          ? null
          : obscureText!
              ? InkWell(
                  onTap: ontapSufixIcon,
                  child: Icon(Icons.visibility_off, color: lightBrown),
                )
              : InkWell(
                  onTap: ontapSufixIcon,
                  child: Icon(Icons.visibility, color: lightBrown),
                ),
    ),
  );
}
