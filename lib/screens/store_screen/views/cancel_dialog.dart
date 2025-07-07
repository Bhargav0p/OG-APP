import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/store_controller.dart';

class CancelDialog extends StatefulWidget {
  const CancelDialog(
      {Key? key, required this.id, required this.amount, required this.type})
      : super(key: key);
  final int id;
  final int amount;
  final String type;
  @override
  State<CancelDialog> createState() => _CancelDialogState();
}

class _CancelDialogState extends State<CancelDialog> {
  double slideWidth = 132.00;
  int time = 5;
  int secondsElapsed = 0;
  String name = "";

  void callFunctionEverySecond(Function functionToCall, int durationInSeconds) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      functionToCall();

      secondsElapsed++;

      if (secondsElapsed >= durationInSeconds) {
        timer.cancel();
      }
    });
  }

  getName() {
    if(widget.type == "Prof Show"){
      name = storeController
          .getProfShowList()
          .firstWhere((element) => (element.id == widget.id))
          .name!;
    } else {
      name = storeController
          .getMerchList()
          .firstWhere((element) => (element.id == widget.id))
          .name!;
    }
  }

  @override
  void initState() {
    secondsElapsed = 0;
    time = 6;
    callFunctionEverySecond(() async {
      print("time: $time");
      print("secondsElasped $secondsElapsed");
      if (time == 1 && (StoreController.isCancelled == false)) {
        Navigator.pop(context);
      }
      if (time - 1 > 0 && (StoreController.isCancelled == false)) {
        time--;
        setState(() {});
      }
    }, 6);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getName();
    return Stack(children: [
      Center(
        child: Container(
          height: 433.h,
          width: 398.w,
          decoration: BoxDecoration(
              color: const Color(0xff292934),
              borderRadius: BorderRadius.circular(24.r)),
          child: Padding(
            padding: EdgeInsets.only(
                top: 77.h, right: 13.w, left: 13.w, bottom: 18.h),
            child: Column(
              children: [
                Text(
                  "You have successfully\nPurchased",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSans(
                      color: Colors.white,
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 32.h, bottom: 18.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.type,
                            style: GoogleFonts.notoSans(
                              color: Colors.grey,
                              fontSize: 16.sp,
                            ),
                          ),
                          Text(
                            name,
                            style: GoogleFonts.notoSans(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                      Text(
                        "X${widget.amount}",
                        style: GoogleFonts.notoSans(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.yellow,
                ),
                SizedBox(
                  height: 32.h,
                ),
                SizedBox(
                  width: 358.w,
                  child: Stack(
                    children: [
                      Container(
                        height: 50.h,
                        width: 358.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: const Color(0xff58307e),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.only(top: 11.h, right: 20.w),
                          child: Text(
                            "${time - 1} sec",
                            style: GoogleFonts.notoSans(
                                fontSize: 18.sp, color: Colors.white),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onHorizontalDragEnd: (dragUpdateDetails) {
                          slideWidth = 132;
                          setState(() {});
                        },
                        onHorizontalDragUpdate: (dragUpdateDetails) {
                          if (slideWidth > 358) {
                            StoreController.isCancelled = true;
                            Navigator.pop(context);
                          }
                          if (slideWidth < 132) {
                            slideWidth = 132;
                          }
                          if (slideWidth >= 132) {
                            slideWidth =
                                slideWidth + dragUpdateDetails.delta.dx;
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: (slideWidth > 132) ? slideWidth.w : 132.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                              color: const Color(0xff9855d9),
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Center(
                            child: Text(
                              "Slide to Cancel",
                              style: GoogleFonts.notoSans(
                                  color: Colors.white, fontSize: 16.sp),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 21.h),
                  child: Text(
                    "To avail your items, use the QR code in the\nwallet section",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSans(
                      color: Colors.grey,
                      fontSize: 16.sp,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 165.h),
        child: Container(
          height: 131.h,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [
                Color.fromRGBO(18, 183, 106, 1),
                Color.fromRGBO(11, 96, 56, 0.25)
              ])),
          child: Center(
            child: SvgPicture.asset('assets/images/tick.svg'),
          ),
        ),
      ),
    ]);
  }
}
