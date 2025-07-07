import 'dart:math' as math; // import this

import 'package:apogee_2022/resources/resources.dart';
import 'package:apogee_2022/screens/orders/order_status.dart';
import 'package:apogee_2022/screens/orders/otp_widget.dart';
import 'package:apogee_2022/utils/scroll_remover.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'repo/model/order_card_model.dart';

class OrderWidget extends StatefulWidget {
  OrderWidget({super.key, required this.orderCardList});

  List<OrderCardModel> orderCardList;

  @override
  OrderWidgetState createState() => OrderWidgetState();
}

class OrderWidgetState extends State<OrderWidget> {
  int _currentIndex = 0;
  final carouselController = CarouselController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<OrderCardModel> myOrderCardList = widget.orderCardList;
    print('rebuilding');

    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 21, 27, 1),
      body: Stack(
        children: [
          Column(
            children: [
              Builder(builder: (context) {
                print('rebuilding2');
                return CarouselSlider.builder(
                  carouselController: carouselController,
                  options: CarouselOptions(
                    height: 300.h,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      if (!mounted) {
                        return;
                      }

                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  itemCount: myOrderCardList.length,
                  itemBuilder:
                      (BuildContext context, int index, int realIndex) {
                    return OrderStatus(
                      key: ValueKey(myOrderCardList[index].orderId),
                      // Add this line
                      orderCardModel: myOrderCardList[index],
                    );
                  },
                );
              }),
              SizedBox(height: 20.5.h),
              Center(
                child: DotsIndicator(
                  dotsCount:
                      myOrderCardList.length > 3 ? 3 : myOrderCardList.length,
                  position: _currentIndex % 3.toDouble(),
                  decorator: const DotsDecorator(
                    size: Size.square(8.0),
                    activeSize: Size.square(12.0),
                    color: Colors.grey,
                    activeColor: Colors.blue,
                  ),
                ),
              ),
//         ],
//       ),
//     );
//   }
// }

//TODO: this is the new code
            ],
          ),
          Positioned(
            left: 1.w,
            top: 125.h,
            child: IconButton(
                onPressed: () {
                  if (_currentIndex != 0) {
                    carouselController.previousPage();
                  }
                },
                icon: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: SvgPicture.asset(ImageAssets.rightArrow),
                )),
          ),
          // Right button
          Positioned(
            right: 1.w,
            top: 125.h,
            child: IconButton(
              onPressed: () {
                if (_currentIndex != myOrderCardList.length - 1) {
                  carouselController.nextPage();
                }
              },
              icon: SvgPicture.asset(ImageAssets.rightArrow),
              color: Colors.white,
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.475,
            minChildSize: 0.475,
            maxChildSize: 0.99,
            builder: (BuildContext context, ScrollController scrollController) {
              return ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: Container(
                  height: 720.h,
                  width: 430.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(26, 27, 41, 1),
                        Color.fromRGBO(41, 43, 83, 1)
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      SvgPicture.asset("assets/icons/bottomdragsheet.svg"),
                      // Figma Flutter Generator Order1502Widget - TEXT
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 26.h, left: 37.w),
                          child: Text(
                            'Order  #${myOrderCardList[_currentIndex].orderId}',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.openSans(
                                color: const Color(0xFFA6A6A6),
                                fontSize: 18.sp,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.bold,
                                height: 1),
                          ),
                        ),
                      ),
                      Column(
                        children: List.generate(
                            myOrderCardList[_currentIndex]
                                .menuItemInOrdersScreenList
                                .length,
                            (index) => Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 14.h, top: 20.h),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 51.w, right: 37.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 180.w,
                                          child: Text(
                                            myOrderCardList[_currentIndex]
                                                .menuItemInOrdersScreenList[
                                                    index]
                                                .name,
                                            style: GoogleFonts.notoSans(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.sp,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Text(
                                          '₹ ${myOrderCardList[_currentIndex].menuItemInOrdersScreenList[index].price} x ${myOrderCardList[_currentIndex].menuItemInOrdersScreenList[index].quantity}',
                                          style: GoogleFonts.openSans(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.97.sp,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 37.w, top: 12.h),
                          child: SizedBox(
                              width: 61.w,
                              child: const Divider(
                                thickness: 2,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 44.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SubTotal',
                              style: GoogleFonts.notoSans(
                                  fontSize: 17.12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            Text(
                              '₹ ${myOrderCardList[_currentIndex].subtotal.round()}',
                              style: GoogleFonts.notoSans(
                                  fontSize: 17.12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 250.h,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 50.h,
            left: 132.w,
            child: OtpWidget(
              orderCardModel: myOrderCardList[_currentIndex],
              key: ValueKey(myOrderCardList[_currentIndex].orderId),
            ),
          ),
        ],
      ),
    );
  }
}
