import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoarding extends StatelessWidget {
  const OnBoarding(
      {Key? key,
      required this.titleText,
      required this.text,
      required this.imagePath})
      : super(key: key);
  final String titleText;
  final String text;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 46.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 451.h,
            width: 309.h,
            child: Image.asset(imagePath),
          ),
          SizedBox(height: 76.h),
          Center(
            child: Text(
              titleText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'sui-generis',
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 11.h,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 32.w, right: 32.w),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansGujarati(
                    color: Color.fromRGBO(161, 161, 161, 1),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }
}
