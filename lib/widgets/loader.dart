import 'dart:async';

import 'package:apogee_2022/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Loader extends StatefulWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  bool isError = false;
  late Timer timer;

  @override
  void initState() {
    timer = Timer(const Duration(seconds: 15), () {
      setState(() {
        isError = true;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff16171d),
      body: isError
          ? Center(
              child: Scaffold(
                backgroundColor: const Color.fromRGBO(18, 19, 24, 1),
                body: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 333.h,
                      ),
                      SvgPicture.asset('assets/images/loader_error.svg'),
                      SizedBox(
                        height: 27.h,
                      ),
                      Text(
                        'Unable to fetch details at the moment.',
                        style: GoogleFonts.notoSans(
                            color: const Color.fromRGBO(250, 250, 250, 1),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              //ErrorDialog(
              //  errorMessage: ErrorMessages.timeOutError, isFatalError: true))
            )
          : Center(
              child: SizedBox(
                height: 75,
                width: 75,
                child: SpinKitCubeGrid(
                  duration: Duration(milliseconds: 800),
                  color: ApogeeColors.purpleButtonColor,
                ),
              ),
            ),
    );
  }
}
