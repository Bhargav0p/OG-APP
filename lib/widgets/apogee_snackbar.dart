import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSnackBar {
  SnackBar apogeeSnackBar(String? text) {
    return SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(
        text ?? "Unknown Error",
        textAlign: TextAlign.center,
        style: GoogleFonts.openSans(
            color: const Color.fromRGBO(152, 85, 217, 1),
            fontSize: 15.sp,
            fontWeight: FontWeight.w500),
      ),
      backgroundColor: const Color.fromRGBO(14, 16, 20, 1),
      behavior: SnackBarBehavior.floating,
    );
  }
}
