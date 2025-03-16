import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showSnackBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: GoogleFonts.poppins(),
      ),
    ),
  );
}