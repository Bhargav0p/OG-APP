import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OkButton extends StatelessWidget {
  const OkButton({Key? key, this.buttonText}) : super(key: key);
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonText == null ? 258.w : 200.w,
      height: buttonText == null ? 59.h : 50.h,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(152, 85, 217, 1),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            offset: Offset(0, 2),
            blurRadius: 3,
          )
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          buttonText ?? 'Ok',
          style: GoogleFonts.openSans(
              color: const Color.fromARGB(255, 63, 7, 136),
              fontSize: 18.sp,
              fontWeight:
                  buttonText == null ? FontWeight.w800 : FontWeight.w700),
        ),
      ),
    );
  }
}
