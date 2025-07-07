import 'package:apogee_2022/main.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/loader.dart';
import 'onboarding.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  PageController _controller = PageController(initialPage: 0, keepPage: false);

  List<Widget> onBoardingPages = const [
    OnBoarding(
        imagePath: 'assets/images/onbrd2.png',
        titleText: 'Keep track of events',
        text:
            'Now keep track of all events and make your schedule to never miss any.'),
    OnBoarding(
        imagePath: 'assets/images/onbrd3.png',
        titleText: 'Go cashless',
        text:
            'Use the unique QR code present on the wallet screen to enter prof shows and buy  merchandise'),
    OnBoarding(
        imagePath: 'assets/images/onbrd1.png',
        titleText: 'Order food',
        text:
            'Forget about the hassle of standing in long queues to order from the available stalls. Place orders and get live updates on the app.'),
  ];

  double currentIndexPage = 0.0;
  bool onLastPage = false, hasLoader = false;

  @override
  void initState() {
    print('onboarding page mai aaya');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(22, 23, 29, 1),
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 80.h),
                Padding(
                  padding: EdgeInsets.only(left: 357.w),
                  child: GestureDetector(
                    onTap: () {
                      Future.microtask(() {
                        RestartWidget.restartApp(context);
                      });
                    },
                    child: hasLoader
                        ? const Loader()
                        : Row(
                            children: [
                              Text(
                                "Skip",
                                style: GoogleFonts.notoSansGujarati(
                                    color: Color.fromRGBO(161, 161, 161, 1),
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                  ),
                )
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 630.h,
                ),
                Center(
                  child: DotsIndicator(
                    dotsCount: onBoardingPages.length,
                    position: currentIndexPage,
                    decorator: DotsDecorator(
                      size: Size(14.w, 10.h),
                      activeSize: Size(30.w, 10.h),
                      activeColor: Color.fromRGBO(152, 85, 217, 1),
                      color: Color.fromRGBO(50, 50, 50, 1),
                      spacing: EdgeInsets.symmetric(horizontal: 4.66.w),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(31.0)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(31.0)),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 103.h,
                ),
                Expanded(
                  child: PageView.builder(
                    itemBuilder: (context, index) {
                      return onBoardingPages[index];
                    },
                    itemCount: onBoardingPages.length,
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(
                        () {
                          currentIndexPage = index.toDouble();
                          if (currentIndexPage == 2) {
                            onLastPage = true;
                          } else {
                            onLastPage = false;
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 112.w, bottom: 43.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          onLastPage
                              ? RestartWidget.restartApp(context)
                              : _controller.nextPage(
                                  curve: Curves.ease,
                                  duration: Duration(milliseconds: 600));
                        },
                        child: Center(
                          child: Container(
                            width: 205.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: Color.fromRGBO(152, 85, 217, 1)),
                            child: Center(
                              child: Text(
                                !onLastPage ? 'Next' : 'Proceed!',
                                style: TextStyle(
                                    fontFamily: 'sui-generis',
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
