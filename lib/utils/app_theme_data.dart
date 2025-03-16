import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

//------App's Theme Data-----------------------------------
ThemeData themeData() {
  return ThemeData(
    primaryColor: darkBrown,
    primarySwatch: darkBrown,
    fontFamily: GoogleFonts.poppins().fontFamily,
    //-------App Bar Theme-----------------------
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: lightBrown),
      titleTextStyle: TextStyle(
        color: lightBrown,
        fontWeight: FontWeight.bold,
        fontSize: 16.sp,
      ),
    ),

    //-------Floating Action Button Themme-------
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: lightBrown,
    ),
    scaffoldBackgroundColor: Colors.white,
    //------------Alert Dialogue Theme----------
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: const StadiumBorder(),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
          (states) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            );
          },
        ),
      ),
    ),
  );
}
//---------------------------------------------------------

//------App Colors-----------------------------------------
Color color = const Color.fromARGB(255, 89, 54, 34);
Color grey = const Color.fromARGB(255, 166, 143, 123);
Color lightBrown = const Color.fromARGB(255, 168, 99, 38);
MaterialColor darkBrown = MaterialColorGenerator.from(color);

class MaterialColorGenerator {
  static MaterialColor from(Color color) {
    return MaterialColor(color.value, <int, Color>{
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1.0),
    });
  }
}
//---------------------------------------------------------